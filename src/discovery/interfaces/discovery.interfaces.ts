// ============================================
// FreshSave — Discovery Interfaces
// ============================================

import { Prisma } from '@prisma/client';

/**
 * Raw row returned from the nearby deals SQL query.
 * Field names match the SQL column aliases exactly.
 */
export interface RawDealRow {
  offer_id: string;
  offer_title: string | null;
  offer_description: string | null;
  discount_type: string;
  discount_value: Prisma.Decimal;
  original_price_snapshot: Prisma.Decimal;
  discounted_price: Prisma.Decimal;
  discount_amount: Prisma.Decimal;
  starts_at: Date;
  ends_at: Date;
  offer_status: string;
  offer_created_at: Date;

  inventory_id: string;
  stock_quantity: number;
  reserved_quantity: number;
  expiry_date: Date;
  inventory_status: string;

  product_id: string;
  product_name: string;
  brand: string | null;
  product_image: string | null;
  unit: string | null;
  category_id: string;
  category_name: string;
  category_slug: string;

  store_id: string;
  store_name: string;
  store_logo: string | null;
  store_address: string | null;
  store_city: string | null;

  distance_meters: number;
}

/**
 * Raw row returned from the nearby stores SQL query.
 */
export interface RawStoreRow {
  store_id: string;
  store_name: string;
  store_description: string | null;
  store_logo: string | null;
  store_cover_image: string | null;
  store_address: string | null;
  store_city: string | null;
  store_status: string;
  distance_meters: number;
  active_deal_count: number;
}

/**
 * Customer-safe deal response.
 */
export interface DiscoveryDealResponse {
  id: string;
  product: {
    id: string;
    name: string;
    brand: string | null;
    image: string | null;
    unit: string | null;
    category: {
      id: string;
      name: string;
      slug: string;
    };
  };
  offer: {
    title: string | null;
    description: string | null;
    discountType: string;
    discountValue: number;
    originalPrice: number;
    discountedPrice: number;
    discountAmount: number;
    startsAt: string;
    endsAt: string;
  };
  inventory: {
    availableQuantity: number;
    expiryDate: string;
    expiryStatus: string;
  };
  store: {
    id: string;
    name: string;
    logo: string | null;
    address: string | null;
    city: string | null;
  };
  distance: {
    value: number;
    unit: string;
  };
  relevanceScore: number;
}

/**
 * Customer-safe store response.
 */
export interface DiscoveryStoreResponse {
  id: string;
  name: string;
  description: string | null;
  logo: string | null;
  coverImage: string | null;
  address: string | null;
  city: string | null;
  distance: {
    value: number;
    unit: string;
  };
  activeDealCount: number;
}

/**
 * Ranking score breakdown for a deal.
 * Provides explainability — not a black-box score.
 */
export interface RankingScoreBreakdown {
  discountScore: number;
  expiryUrgencyScore: number;
  distanceScore: number;
  availabilityScore: number;
  totalScore: number;
}

/**
 * Configuration for ranking weights.
 */
export interface RankingWeights {
  distanceWeight: number;
  discountWeight: number;
  expiryUrgencyWeight: number;
  availabilityWeight: number;
}
