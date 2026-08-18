export default () => ({
  app: {
    nodeEnv: process.env.NODE_ENV || 'development',
    port: parseInt(process.env.APP_PORT || '3000', 10),
    name: process.env.APP_NAME || 'FreshSave',
    apiPrefix: process.env.API_PREFIX || 'api/v1',
    corsOrigins: (process.env.CORS_ORIGINS || 'http://localhost:3000')
      .split(',')
      .map((origin) => origin.trim()),
  },

  database: {
    host: process.env.DATABASE_HOST || 'localhost',
    port: parseInt(process.env.DATABASE_PORT || '5432', 10),
    user: process.env.DATABASE_USER || 'freshsave',
    password: process.env.DATABASE_PASSWORD || 'freshsave_secret',
    name: process.env.DATABASE_NAME || 'freshsave_db',
    url: process.env.DATABASE_URL,
  },

  redis: {
    host: process.env.REDIS_HOST || 'localhost',
    port: parseInt(process.env.REDIS_PORT || '6379', 10),
    password: process.env.REDIS_PASSWORD || undefined,
    db: parseInt(process.env.REDIS_DB || '0', 10),
    url: process.env.REDIS_URL,
  },

  logging: {
    level: process.env.LOG_LEVEL || 'debug',
  },

  jwt: {
    accessSecret: process.env.JWT_ACCESS_SECRET || 'fallback_access_secret',
    refreshSecret: process.env.JWT_REFRESH_SECRET || 'fallback_refresh_secret',
    accessExpiration: process.env.JWT_ACCESS_EXPIRATION || '15m',
    refreshExpiration: process.env.JWT_REFRESH_EXPIRATION || '7d',
  },

  discovery: {
    defaultRadiusKm: parseFloat(process.env.DISCOVERY_DEFAULT_RADIUS_KM || '5'),
    maxRadiusKm: parseFloat(process.env.DISCOVERY_MAX_RADIUS_KM || '50'),
    maxPageSize: parseInt(process.env.DISCOVERY_MAX_PAGE_SIZE || '50', 10),
    ranking: {
      distanceWeight: parseFloat(process.env.RANKING_DISTANCE_WEIGHT || '0.25'),
      discountWeight: parseFloat(process.env.RANKING_DISCOUNT_WEIGHT || '0.30'),
      expiryUrgencyWeight: parseFloat(
        process.env.RANKING_EXPIRY_WEIGHT || '0.30',
      ),
      availabilityWeight: parseFloat(
        process.env.RANKING_AVAILABILITY_WEIGHT || '0.15',
      ),
    },
  },
});
