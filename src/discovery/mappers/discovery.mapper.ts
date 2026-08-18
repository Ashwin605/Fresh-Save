// ============================================
// FreshSave — Discovery Mapper
// ============================================

import { Injectable } from '@nestjs/common';
import { ExpiryService } from '../../inventory/services/expiry.service';
import { GeospatialService } from '../services/geospatial.service';
import { DealRankingService } from '../services/deal-ranking.service';
import {
  RawDealRow,
  RawStoreRow,
  DiscoveryDealResponse,
  DiscoveryStoreResponse,
} from '../interfaces/discovery.interfaces';

/**
 * Maps raw database rows to customer-safe response DTOs.
 *
 * This mapper is the single point of control for what data is
 * exposed to public endpoints. It explicitly selects safe fields
 * and excludes all private/internal information.
 */
@Injectable()
export class DiscoveryMapper {
  constructor(
    private readonly expiryService: ExpiryService,
    private readonly geospatialService: GeospatialService,
    private readonly dealRankingService: DealRankingService,
  ) {}

  /**
   * Map a raw deal row to a customer-safe response.
   * Calculates relevance score and expiry status.
   *
   * @param row - Raw SQL result row
   * @param maxRadiusKm - Maximum radius for distance normalization in ranking
   */
  mapDealRow(row: RawDealRow, maxRadiusKm: number): DiscoveryDealResponse {
    const distanceKm = this.geospatialService.metersToKm(
      Number(row.distance_meters),
    );

    const originalPrice = Number(row.original_price_snapshot);
    const discountValue = Number(row.discount_value);
    const effectiveDiscountPct =
      this.dealRankingService.getEffectiveDiscountPct(
        row.discount_type,
        discountValue,
        originalPrice,
      );

    const availableQuantity =
      Number(row.stock_quantity) - Number(row.reserved_quantity);

    const expiryStatus = this.expiryService.getExpiryStatus(
      new Date(row.expiry_date),
    );

    const ranking = this.dealRankingService.calculateScore(
      effectiveDiscountPct,
      new Date(row.expiry_date),
      distanceKm,
      availableQuantity,
      maxRadiusKm,
    );

    return {
      id: row.offer_id,
      product: {
        id: row.product_id,
        name: row.product_name,
        brand: row.brand,
        image: row.product_image,
        unit: row.unit,
        category: {
          id: row.category_id,
          name: row.category_name,
          slug: row.category_slug,
        },
      },
      offer: {
        title: row.offer_title,
        description: row.offer_description,
        discountType: row.discount_type,
        discountValue: discountValue,
        originalPrice: originalPrice,
        discountedPrice: Number(row.discounted_price),
        discountAmount: Number(row.discount_amount),
        startsAt: new Date(row.starts_at).toISOString(),
        endsAt: new Date(row.ends_at).toISOString(),
      },
      inventory: {
        availableQuantity,
        expiryDate: new Date(row.expiry_date).toISOString(),
        expiryStatus,
      },
      store: {
        id: row.store_id,
        name: row.store_name,
        logo: row.store_logo,
        address: row.store_address,
        city: row.store_city,
      },
      distance: {
        value: distanceKm,
        unit: 'km',
      },
      relevanceScore: ranking.totalScore,
    };
  }

  /**
   * Map multiple deal rows and optionally sort by relevance score.
   */
  mapDealRows(
    rows: RawDealRow[],
    maxRadiusKm: number,
    sortByRelevance: boolean = false,
  ): DiscoveryDealResponse[] {
    const mapped = rows.map((row) => this.mapDealRow(row, maxRadiusKm));

    if (sortByRelevance) {
      // Sort by relevance score descending (highest relevance first)
      mapped.sort((a, b) => b.relevanceScore - a.relevanceScore);
    }

    return mapped;
  }

  /**
   * Map a raw store row to a customer-safe response.
   */
  mapStoreRow(row: RawStoreRow): DiscoveryStoreResponse {
    return {
      id: row.store_id,
      name: row.store_name,
      description: row.store_description,
      logo: row.store_logo,
      coverImage: row.store_cover_image,
      address: row.store_address,
      city: row.store_city,
      distance: {
        value: this.geospatialService.metersToKm(Number(row.distance_meters)),
        unit: 'km',
      },
      activeDealCount: Number(row.active_deal_count),
    };
  }

  /**
   * Map multiple store rows.
   */
  mapStoreRows(rows: RawStoreRow[]): DiscoveryStoreResponse[] {
    return rows.map((row) => this.mapStoreRow(row));
  }
}
