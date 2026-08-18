// ============================================
// FreshSave — Discovery Service
// ============================================

import { Injectable, Logger, NotFoundException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PrismaService } from '../database/prisma/prisma.service';
import { DiscoveryQueryService } from './services/discovery-query.service';
import { DiscoveryMapper } from './mappers/discovery.mapper';
import { NearbyDealsQueryDto } from './dto/nearby-deals-query.dto';
import { NearbyStoresQueryDto } from './dto/nearby-stores-query.dto';
import { ProductDiscoveryQueryDto } from './dto/product-discovery-query.dto';
import { DealDetailQueryDto } from './dto/deal-detail-query.dto';
import { DISCOVERY_DEFAULTS } from './constants/discovery.constants';
import { createPaginatedResponse } from '../common/dto/pagination.dto';
import { CategoryStatus, ProductStatus, Prisma } from '@prisma/client';

/**
 * Main discovery service orchestrating all sub-services.
 * Coordinates geospatial filtering, eligibility checks, ranking,
 * pagination, and response mapping.
 */
@Injectable()
export class DiscoveryService {
  private readonly logger = new Logger(DiscoveryService.name);
  private readonly defaultRadius: number;
  private readonly maxRadius: number;

  constructor(
    private readonly configService: ConfigService,
    private readonly prisma: PrismaService,
    private readonly discoveryQuery: DiscoveryQueryService,
    private readonly mapper: DiscoveryMapper,
  ) {
    this.defaultRadius = this.configService.get<number>(
      'discovery.defaultRadiusKm',
      DISCOVERY_DEFAULTS.DEFAULT_RADIUS_KM,
    );
    this.maxRadius = this.configService.get<number>(
      'discovery.maxRadiusKm',
      DISCOVERY_DEFAULTS.MAX_RADIUS_KM,
    );

    this.logger.log(
      `Discovery service initialized: defaultRadius=${this.defaultRadius}km, maxRadius=${this.maxRadius}km`,
    );
  }

  /**
   * Find nearby deals based on customer location and filters.
   * This is the primary discovery endpoint for FreshSave.
   */
  async findNearbyDeals(query: NearbyDealsQueryDto) {
    const page = query.page ?? 1;
    const limit = query.limit ?? DISCOVERY_DEFAULTS.DEFAULT_PAGE_SIZE;
    const sortByRelevance = !query.sortBy || query.sortBy === 'relevance';

    const { rows, total } = await this.discoveryQuery.findNearbyDeals(
      query,
      this.defaultRadius,
    );

    const radiusKm = query.radius ?? this.defaultRadius;
    const mappedItems = this.mapper.mapDealRows(
      rows,
      radiusKm,
      sortByRelevance,
    );

    return createPaginatedResponse(mappedItems, total, page, limit);
  }

  /**
   * Find nearby stores based on customer location.
   * Only returns stores eligible for public discovery.
   */
  async findNearbyStores(query: NearbyStoresQueryDto) {
    const page = query.page ?? 1;
    const limit = query.limit ?? DISCOVERY_DEFAULTS.DEFAULT_PAGE_SIZE;

    const { rows, total } = await this.discoveryQuery.findNearbyStores(
      query,
      this.defaultRadius,
    );

    const mappedItems = this.mapper.mapStoreRows(rows);

    return createPaginatedResponse(mappedItems, total, page, limit);
  }

  /**
   * Public product discovery — browse the product catalog.
   * Returns customer-safe product information without store management data.
   */
  async findProducts(query: ProductDiscoveryQueryDto) {
    const {
      page = 1,
      limit = DISCOVERY_DEFAULTS.DEFAULT_PAGE_SIZE,
      search,
      categoryId,
      brand,
      sortBy = 'newest',
      sortOrder = 'desc',
    } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.ProductWhereInput = {
      status: ProductStatus.ACTIVE,
      deletedAt: null,
    };

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { brand: { contains: search, mode: 'insensitive' } },
      ];
    }

    if (categoryId) {
      // Include child categories
      where.OR = where.OR
        ? [
            ...where.OR,
            { categoryId: categoryId },
            { category: { parentId: categoryId } },
          ]
        : undefined;
      if (!where.OR) {
        where.AND = [
          {
            OR: [
              { categoryId: categoryId },
              { category: { parentId: categoryId } },
            ],
          },
        ];
      }
    }

    // When both search and categoryId, we need to combine them properly
    if (search && categoryId) {
      where.AND = [
        {
          OR: [
            { name: { contains: search, mode: 'insensitive' } },
            { brand: { contains: search, mode: 'insensitive' } },
          ],
        },
        {
          OR: [
            { categoryId: categoryId },
            { category: { parentId: categoryId } },
          ],
        },
      ];
      delete where.OR;
    }

    if (brand) {
      where.brand = { equals: brand, mode: 'insensitive' };
    }

    // Safe sort field mapping
    const sortFieldMap: Record<string, string> = {
      name: 'name',
      brand: 'brand',
      newest: 'createdAt',
    };
    const orderField = sortFieldMap[sortBy] || 'createdAt';
    const orderDir = sortOrder === 'asc' ? 'asc' : 'desc';

    const [items, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        select: {
          id: true,
          name: true,
          slug: true,
          description: true,
          brand: true,
          image: true,
          unit: true,
          category: {
            select: { id: true, name: true, slug: true },
          },
        },
        skip,
        take: limit,
        orderBy: { [orderField]: orderDir },
      }),
      this.prisma.product.count({ where }),
    ]);

    return createPaginatedResponse(items, total, page, limit);
  }

  /**
   * Return active categories suitable for customer browsing.
   * Excludes archived/inactive categories.
   */
  async findCategories() {
    const categories = await this.prisma.category.findMany({
      where: {
        status: CategoryStatus.ACTIVE,
        deletedAt: null,
        parentId: null, // Top-level categories
      },
      select: {
        id: true,
        name: true,
        slug: true,
        description: true,
        icon: true,
        image: true,
        children: {
          where: { status: CategoryStatus.ACTIVE, deletedAt: null },
          select: {
            id: true,
            name: true,
            slug: true,
            description: true,
            icon: true,
            image: true,
          },
        },
      },
      orderBy: { name: 'asc' },
    });

    return categories;
  }

  /**
   * Get a single deal's detail by offer ID.
   * Public endpoint — only returns the deal if it's eligible.
   * Optionally calculates distance if lat/lng provided.
   */
  async findDealDetail(offerId: string, query: DealDetailQueryDto) {
    const row = await this.discoveryQuery.findDealById(
      offerId,
      query.latitude,
      query.longitude,
    );

    if (!row) {
      throw new NotFoundException('Deal not found or is no longer available');
    }

    const radiusKm =
      query.latitude !== undefined ? this.maxRadius : this.defaultRadius;

    return this.mapper.mapDealRow(row, radiusKm);
  }
}
