// ============================================
// FreshSave — Discovery Query Service
// ============================================

import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { GeospatialService } from './geospatial.service';
import { NearbyDealsQueryDto } from '../dto/nearby-deals-query.dto';
import { NearbyStoresQueryDto } from '../dto/nearby-stores-query.dto';
import { DEAL_SORT_FIELDS } from '../constants/discovery.constants';
import { RawDealRow, RawStoreRow } from '../interfaces/discovery.interfaces';

/**
 * Builds and executes PostGIS-powered discovery queries.
 *
 * All filtering (spatial, eligibility, business rules) is performed
 * in the database to avoid loading unnecessary data into Node.js.
 *
 * Uses parameterized queries throughout — user input is NEVER
 * interpolated directly into SQL strings.
 */
@Injectable()
export class DiscoveryQueryService {
  private readonly logger = new Logger(DiscoveryQueryService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly geospatialService: GeospatialService,
  ) {}

  /**
   * Execute the nearby deals query with all filters applied database-side.
   *
   * Query pipeline:
   * 1. PostGIS ST_DWithin radius filter on stores
   * 2. Store eligibility (ACTIVE + VERIFIED)
   * 3. Business eligibility (ACTIVE + VERIFIED)
   * 4. Inventory eligibility (ACTIVE, not expired, available stock)
   * 5. Product eligibility (ACTIVE)
   * 6. Offer eligibility (ACTIVE, within time window)
   * 7. User-specified filters (search, category, discount, price, expiry, store)
   * 8. Distance calculation via ST_Distance
   *
   * Returns raw rows — ranking and mapping happen in calling service.
   */
  async findNearbyDeals(
    query: NearbyDealsQueryDto,
    defaultRadius: number,
  ): Promise<{ rows: RawDealRow[]; total: number }> {
    const {
      latitude,
      longitude,
      radius = defaultRadius,
      categoryId,
      search,
      storeId,
      minDiscount,
      maxPrice,
      expiryWithinHours,
      sortBy = 'relevance',
      sortOrder = 'asc',
      page = 1,
      limit = 20,
    } = query;

    const radiusMeters = this.geospatialService.kmToMeters(radius);
    const offset = (page - 1) * limit;

    // Build parameterized query
    // $1 = longitude, $2 = latitude, $3 = radius in meters
    const params: unknown[] = [longitude, latitude, radiusMeters];
    let paramIndex = 4;

    // Dynamic WHERE conditions
    const conditions: string[] = [];

    // Search filter
    if (search) {
      conditions.push(
        `(p."name" ILIKE $${paramIndex} OR p."brand" ILIKE $${paramIndex})`,
      );
      params.push(`%${search}%`);
      paramIndex++;
    }

    // Category filter (includes child categories)
    if (categoryId) {
      conditions.push(
        `(p."categoryId" = $${paramIndex} OR c."parentId" = $${paramIndex})`,
      );
      params.push(categoryId);
      paramIndex++;
    }

    // Store filter
    if (storeId) {
      conditions.push(`s."id" = $${paramIndex}`);
      params.push(storeId);
      paramIndex++;
    }

    // Min discount filter (effective percentage)
    if (minDiscount !== undefined) {
      conditions.push(`
        CASE
          WHEN o."discountType" = 'PERCENTAGE' THEN o."discountValue"
          ELSE (o."discountAmount" / NULLIF(o."originalPriceSnapshot", 0)) * 100
        END >= $${paramIndex}
      `);
      params.push(minDiscount);
      paramIndex++;
    }

    // Max price filter (on discounted price)
    if (maxPrice !== undefined) {
      conditions.push(`o."discountedPrice" <= $${paramIndex}`);
      params.push(maxPrice);
      paramIndex++;
    }

    // Expiry filter
    if (expiryWithinHours !== undefined) {
      conditions.push(
        `i."expiryDate" <= (NOW() + INTERVAL '1 hour' * $${paramIndex})`,
      );
      params.push(expiryWithinHours);
      paramIndex++;
    }

    const dynamicWhere =
      conditions.length > 0 ? 'AND ' + conditions.join(' AND ') : '';

    // Determine ORDER BY — only use allowlisted sort fields
    let orderClause: string;
    if (sortBy === 'relevance' || !DEAL_SORT_FIELDS[sortBy]) {
      // Default: relevance sorting is handled post-query by ranking service
      // Here we use a reasonable default: expiry ASC (most urgent first), then distance
      orderClause = 'i."expiryDate" ASC, distance_meters ASC';
    } else {
      const safeColumn = DEAL_SORT_FIELDS[sortBy];
      const safeDirection = sortOrder === 'desc' ? 'DESC' : 'ASC';
      orderClause = `${safeColumn} ${safeDirection}`;
    }

    // Count query
    const countSql = `
      SELECT COUNT(*) as total
      FROM "Offer" o
        INNER JOIN "Inventory" i ON o."inventoryId" = i."id"
        INNER JOIN "Product" p ON i."productId" = p."id"
        INNER JOIN "Category" c ON p."categoryId" = c."id"
        INNER JOIN "Store" s ON i."storeId" = s."id"
        INNER JOIN "Business" b ON s."businessId" = b."id"
      WHERE
        s."location" IS NOT NULL
        AND ST_DWithin(
          s."location",
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
          $3
        )
        AND s."status" = 'ACTIVE'
        AND s."verificationStatus" = 'VERIFIED'
        AND s."deletedAt" IS NULL
        AND b."status" = 'ACTIVE'
        AND b."verificationStatus" = 'VERIFIED'
        AND b."deletedAt" IS NULL
        AND o."status" = 'ACTIVE'
        AND o."startsAt" <= NOW()
        AND o."endsAt" > NOW()
        AND o."deletedAt" IS NULL
        AND i."status" = 'ACTIVE'
        AND i."expiryDate" > NOW()
        AND (i."stockQuantity" - i."reservedQuantity") > 0
        AND i."deletedAt" IS NULL
        AND p."status" = 'ACTIVE'
        AND p."deletedAt" IS NULL
        AND c."status" = 'ACTIVE'
        ${dynamicWhere}
    `;

    // Data query
    const dataSql = `
      SELECT
        o."id" as offer_id,
        o."title" as offer_title,
        o."description" as offer_description,
        o."discountType" as discount_type,
        o."discountValue" as discount_value,
        o."originalPriceSnapshot" as original_price_snapshot,
        o."discountedPrice" as discounted_price,
        o."discountAmount" as discount_amount,
        o."startsAt" as starts_at,
        o."endsAt" as ends_at,
        o."status" as offer_status,
        o."createdAt" as offer_created_at,
        i."id" as inventory_id,
        i."stockQuantity" as stock_quantity,
        i."reservedQuantity" as reserved_quantity,
        i."expiryDate" as expiry_date,
        i."status" as inventory_status,
        p."id" as product_id,
        p."name" as product_name,
        p."brand" as brand,
        p."image" as product_image,
        p."unit" as unit,
        p."categoryId" as category_id,
        c."name" as category_name,
        c."slug" as category_slug,
        s."id" as store_id,
        s."name" as store_name,
        s."logo" as store_logo,
        s."address" as store_address,
        COALESCE(
          (s."address"::text)::varchar,
          ''
        ) as store_city_raw,
        ST_Distance(
          s."location",
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography
        ) as distance_meters,
        CASE
          WHEN o."discountType" = 'PERCENTAGE' THEN o."discountValue"::float
          ELSE (o."discountAmount"::float / NULLIF(o."originalPriceSnapshot"::float, 0)) * 100
        END as effective_discount_pct
      FROM "Offer" o
        INNER JOIN "Inventory" i ON o."inventoryId" = i."id"
        INNER JOIN "Product" p ON i."productId" = p."id"
        INNER JOIN "Category" c ON p."categoryId" = c."id"
        INNER JOIN "Store" s ON i."storeId" = s."id"
        INNER JOIN "Business" b ON s."businessId" = b."id"
      WHERE
        s."location" IS NOT NULL
        AND ST_DWithin(
          s."location",
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
          $3
        )
        AND s."status" = 'ACTIVE'
        AND s."verificationStatus" = 'VERIFIED'
        AND s."deletedAt" IS NULL
        AND b."status" = 'ACTIVE'
        AND b."verificationStatus" = 'VERIFIED'
        AND b."deletedAt" IS NULL
        AND o."status" = 'ACTIVE'
        AND o."startsAt" <= NOW()
        AND o."endsAt" > NOW()
        AND o."deletedAt" IS NULL
        AND i."status" = 'ACTIVE'
        AND i."expiryDate" > NOW()
        AND (i."stockQuantity" - i."reservedQuantity") > 0
        AND i."deletedAt" IS NULL
        AND p."status" = 'ACTIVE'
        AND p."deletedAt" IS NULL
        AND c."status" = 'ACTIVE'
        ${dynamicWhere}
      ORDER BY ${orderClause}
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `;

    params.push(limit, offset);

    this.logger.debug(
      `Executing nearby deals query: lat=${latitude}, lng=${longitude}, radius=${radius}km, filters=${conditions.length}`,
    );

    // Execute both queries in parallel
    const [countResult, rows] = await Promise.all([
      this.prisma.$queryRawUnsafe<[{ total: bigint }]>(
        countSql,
        ...params.slice(0, paramIndex - 1),
      ),
      this.prisma.$queryRawUnsafe<RawDealRow[]>(dataSql, ...params),
    ]);

    const total = Number(countResult[0]?.total ?? 0);

    return { rows, total };
  }

  /**
   * Execute the nearby stores query.
   * Only returns eligible stores (ACTIVE, VERIFIED, business ACTIVE + VERIFIED).
   * Includes a count of active deals per store.
   */
  async findNearbyStores(
    query: NearbyStoresQueryDto,
    defaultRadius: number,
  ): Promise<{ rows: RawStoreRow[]; total: number }> {
    const {
      latitude,
      longitude,
      radius = defaultRadius,
      search,
      categoryId,
      page = 1,
      limit = 20,
    } = query;

    const radiusMeters = this.geospatialService.kmToMeters(radius);
    const offset = (page - 1) * limit;

    const params: unknown[] = [longitude, latitude, radiusMeters];
    let paramIndex = 4;

    const conditions: string[] = [];

    if (search) {
      conditions.push(`s."name" ILIKE $${paramIndex}`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    if (categoryId) {
      // Only show stores that have inventory with products in this category
      conditions.push(`
        EXISTS (
          SELECT 1 FROM "Inventory" inv
          INNER JOIN "Product" prod ON inv."productId" = prod."id"
          WHERE inv."storeId" = s."id"
            AND (prod."categoryId" = $${paramIndex} OR EXISTS (
              SELECT 1 FROM "Category" cat WHERE cat."id" = prod."categoryId" AND cat."parentId" = $${paramIndex}
            ))
            AND inv."status" = 'ACTIVE'
            AND inv."deletedAt" IS NULL
        )
      `);
      params.push(categoryId);
      paramIndex++;
    }

    const dynamicWhere =
      conditions.length > 0 ? 'AND ' + conditions.join(' AND ') : '';

    const countSql = `
      SELECT COUNT(*) as total
      FROM "Store" s
        INNER JOIN "Business" b ON s."businessId" = b."id"
      WHERE
        s."location" IS NOT NULL
        AND ST_DWithin(
          s."location",
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
          $3
        )
        AND s."status" = 'ACTIVE'
        AND s."verificationStatus" = 'VERIFIED'
        AND s."deletedAt" IS NULL
        AND b."status" = 'ACTIVE'
        AND b."verificationStatus" = 'VERIFIED'
        AND b."deletedAt" IS NULL
        ${dynamicWhere}
    `;

    const dataSql = `
      SELECT
        s."id" as store_id,
        s."name" as store_name,
        s."description" as store_description,
        s."logo" as store_logo,
        s."coverImage" as store_cover_image,
        s."address" as store_address,
        s."address" as store_city,
        s."status" as store_status,
        ST_Distance(
          s."location",
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography
        ) as distance_meters,
        (
          SELECT COUNT(*)
          FROM "Offer" o
          INNER JOIN "Inventory" i ON o."inventoryId" = i."id"
          WHERE i."storeId" = s."id"
            AND o."status" = 'ACTIVE'
            AND o."startsAt" <= NOW()
            AND o."endsAt" > NOW()
            AND o."deletedAt" IS NULL
            AND i."status" = 'ACTIVE'
            AND i."expiryDate" > NOW()
            AND (i."stockQuantity" - i."reservedQuantity") > 0
            AND i."deletedAt" IS NULL
        )::int as active_deal_count
      FROM "Store" s
        INNER JOIN "Business" b ON s."businessId" = b."id"
      WHERE
        s."location" IS NOT NULL
        AND ST_DWithin(
          s."location",
          ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
          $3
        )
        AND s."status" = 'ACTIVE'
        AND s."verificationStatus" = 'VERIFIED'
        AND s."deletedAt" IS NULL
        AND b."status" = 'ACTIVE'
        AND b."verificationStatus" = 'VERIFIED'
        AND b."deletedAt" IS NULL
        ${dynamicWhere}
      ORDER BY distance_meters ASC
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}
    `;

    params.push(limit, offset);

    this.logger.debug(
      `Executing nearby stores query: lat=${latitude}, lng=${longitude}, radius=${radius}km`,
    );

    const [countResult, rows] = await Promise.all([
      this.prisma.$queryRawUnsafe<[{ total: bigint }]>(
        countSql,
        ...params.slice(0, paramIndex - 1),
      ),
      this.prisma.$queryRawUnsafe<RawStoreRow[]>(dataSql, ...params),
    ]);

    const total = Number(countResult[0]?.total ?? 0);

    return { rows, total };
  }

  /**
   * Fetch a single deal by offer ID with optional distance calculation.
   * Validates eligibility (active offer, active store, active inventory, etc.)
   */
  async findDealById(
    offerId: string,
    latitude?: number,
    longitude?: number,
  ): Promise<RawDealRow | null> {
    const hasLocation = latitude !== undefined && longitude !== undefined;

    const distanceSelect = hasLocation
      ? `ST_Distance(
          s."location",
          ST_SetSRID(ST_MakePoint($2, $3), 4326)::geography
        ) as distance_meters`
      : `0 as distance_meters`;

    const params: unknown[] = [offerId];
    if (hasLocation) {
      params.push(longitude, latitude);
    }

    const sql = `
      SELECT
        o."id" as offer_id,
        o."title" as offer_title,
        o."description" as offer_description,
        o."discountType" as discount_type,
        o."discountValue" as discount_value,
        o."originalPriceSnapshot" as original_price_snapshot,
        o."discountedPrice" as discounted_price,
        o."discountAmount" as discount_amount,
        o."startsAt" as starts_at,
        o."endsAt" as ends_at,
        o."status" as offer_status,
        o."createdAt" as offer_created_at,
        i."id" as inventory_id,
        i."stockQuantity" as stock_quantity,
        i."reservedQuantity" as reserved_quantity,
        i."expiryDate" as expiry_date,
        i."status" as inventory_status,
        p."id" as product_id,
        p."name" as product_name,
        p."brand" as brand,
        p."image" as product_image,
        p."unit" as unit,
        p."categoryId" as category_id,
        c."name" as category_name,
        c."slug" as category_slug,
        s."id" as store_id,
        s."name" as store_name,
        s."logo" as store_logo,
        s."address" as store_address,
        s."address" as store_city,
        ${distanceSelect}
      FROM "Offer" o
        INNER JOIN "Inventory" i ON o."inventoryId" = i."id"
        INNER JOIN "Product" p ON i."productId" = p."id"
        INNER JOIN "Category" c ON p."categoryId" = c."id"
        INNER JOIN "Store" s ON i."storeId" = s."id"
        INNER JOIN "Business" b ON s."businessId" = b."id"
      WHERE
        o."id" = $1
        AND s."status" = 'ACTIVE'
        AND s."verificationStatus" = 'VERIFIED'
        AND s."deletedAt" IS NULL
        AND b."status" = 'ACTIVE'
        AND b."verificationStatus" = 'VERIFIED'
        AND b."deletedAt" IS NULL
        AND o."status" = 'ACTIVE'
        AND o."startsAt" <= NOW()
        AND o."endsAt" > NOW()
        AND o."deletedAt" IS NULL
        AND i."status" = 'ACTIVE'
        AND i."expiryDate" > NOW()
        AND (i."stockQuantity" - i."reservedQuantity") > 0
        AND i."deletedAt" IS NULL
        AND p."status" = 'ACTIVE'
        AND p."deletedAt" IS NULL
        AND c."status" = 'ACTIVE'
      LIMIT 1
    `;

    const rows = await this.prisma.$queryRawUnsafe<RawDealRow[]>(
      sql,
      ...params,
    );

    return rows[0] ?? null;
  }
}
