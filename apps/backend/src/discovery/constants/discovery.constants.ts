// ============================================
// FreshSave — Discovery Constants
// ============================================

/**
 * Default geospatial configuration values.
 * These are overridden by the ConfigService when available.
 */
export const DISCOVERY_DEFAULTS = {
  /** Default search radius in kilometers */
  DEFAULT_RADIUS_KM: 5,
  /** Maximum allowed search radius in kilometers */
  MAX_RADIUS_KM: 50,
  /** Maximum page size for public discovery endpoints */
  MAX_PAGE_SIZE: 50,
  /** Default page size */
  DEFAULT_PAGE_SIZE: 20,
};

/**
 * Allowlist of safe sort fields for nearby deals.
 * Maps user-facing sort names to SQL-safe column expressions.
 * NEVER interpolate user-provided values directly into SQL.
 */
export const DEAL_SORT_FIELDS: Record<string, string> = {
  distance: 'distance_meters',
  discount: 'effective_discount_pct',
  price: 'discounted_price',
  expiry: 'expiry_date',
  newest: 'offer_created_at',
};

/**
 * Allowlist of safe sort fields for nearby stores.
 */
export const STORE_SORT_FIELDS: Record<string, string> = {
  distance: 'distance_meters',
  name: 'store_name',
};

/**
 * Valid sort directions.
 */
export const SORT_DIRECTIONS = ['asc', 'desc'] as const;
export type SortDirection = (typeof SORT_DIRECTIONS)[number];

/**
 * Default ranking weights.
 * Each weight is a multiplier for the corresponding normalized score (0..1).
 * Sum should ideally equal 1.0 for easy interpretation.
 */
export const DEFAULT_RANKING_WEIGHTS = {
  distanceWeight: 0.25,
  discountWeight: 0.3,
  expiryUrgencyWeight: 0.3,
  availabilityWeight: 0.15,
};

/**
 * Expiry urgency score mapping for ranking.
 * Higher values indicate greater urgency = higher ranking for FreshSave's purpose.
 */
export const EXPIRY_URGENCY_SCORES: Record<string, number> = {
  EXPIRED: 0,
  CRITICAL: 1.0,
  URGENT: 0.8,
  EXPIRING_SOON: 0.6,
  FRESH: 0.3,
};

/**
 * Cap for availability normalization.
 * Stock quantities above this value all receive the maximum availability score.
 */
export const AVAILABILITY_CAP = 50;
