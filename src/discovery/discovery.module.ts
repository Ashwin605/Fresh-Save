// ============================================
// FreshSave — Discovery Module
// ============================================

import { Module } from '@nestjs/common';
import { DiscoveryController } from './discovery.controller';
import { DiscoveryService } from './discovery.service';
import { DiscoveryQueryService } from './services/discovery-query.service';
import { GeospatialService } from './services/geospatial.service';
import { DealRankingService } from './services/deal-ranking.service';
import { DiscoveryMapper } from './mappers/discovery.mapper';
import { InventoryModule } from '../inventory/inventory.module';

@Module({
  imports: [
    // ExpiryService is exported from InventoryModule
    InventoryModule,
  ],
  controllers: [DiscoveryController],
  providers: [
    DiscoveryService,
    DiscoveryQueryService,
    GeospatialService,
    DealRankingService,
    DiscoveryMapper,
  ],
})
export class DiscoveryModule {}
