import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { AiProvider } from './providers/ai-provider.interface';
import { RuleBasedProvider } from './providers/rule-based.provider';
import { FeatureEngineeringService } from './services/feature-engineering.service';
import { InventoryRiskService } from './services/inventory-risk.service';
import { DiscountRecommendationService } from './services/discount-recommendation.service';
import { CustomerRecommendationService } from './services/customer-recommendation.service';
import { AiInventoryController } from './controllers/ai-inventory.controller';
import { AiCustomerController } from './controllers/ai-customer.controller';
import { AiAdminController } from './controllers/ai-admin.controller';

@Module({
  imports: [DatabaseModule],
  controllers: [AiInventoryController, AiCustomerController, AiAdminController],
  providers: [
    {
      provide: AiProvider,
      useClass: RuleBasedProvider,
    },
    FeatureEngineeringService,
    InventoryRiskService,
    DiscountRecommendationService,
    CustomerRecommendationService,
  ],
  exports: [
    AiProvider,
    InventoryRiskService,
    DiscountRecommendationService,
    CustomerRecommendationService,
  ],
})
export class AiModule {}
