import { Module, MiddlewareConsumer, NestModule } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { configuration, validate } from './config';
import { DatabaseModule } from './database/database.module';
import { RedisModule } from './redis/redis.module';
import { HealthModule } from './health/health.module';
import { AuthModule } from './auth/auth.module';
import { BusinessesModule } from './businesses/businesses.module';
import { StoresModule } from './stores/stores.module';
import { ProductsModule } from './products/products.module';
import { InventoryModule } from './inventory/inventory.module';
import { OffersModule } from './offers/offers.module';
import { DiscoveryModule } from './discovery/discovery.module';
import { ReservationsModule } from './reservations/reservations.module';
import { NotificationsModule } from './notifications/notifications.module';
import { OutboxModule } from './common/outbox/outbox.module';
import { AiModule } from './ai/ai.module';
import { AdminModule } from './admin/admin.module';
import { RequestIdMiddleware } from './common/middleware/request-id.middleware';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';

@Module({
  imports: [
    // ── Configuration ──────────────────────────────────────
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
      validate,
      envFilePath: ['.env'],
    }),

    // ── Rate Limiting ──────────────────────────────────────
    ThrottlerModule.forRoot([
      {
        ttl: 60000,
        limit: 100, // 100 requests per minute by default
      },
    ]),

    // ── Infrastructure ─────────────────────────────────────
    DatabaseModule,
    RedisModule,

    // ── Feature Modules ────────────────────────────────────
    HealthModule,
    AuthModule,
    AdminModule,
    BusinessesModule,
    StoresModule,
    ProductsModule,
    InventoryModule,
    OffersModule,
    DiscoveryModule,
    ReservationsModule,
    NotificationsModule,
    OutboxModule,
    AiModule,
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): void {
    consumer.apply(RequestIdMiddleware).forRoutes('*');
  }
}
