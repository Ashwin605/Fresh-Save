import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AiProvider } from '../providers/ai-provider.interface';
import { FeatureEngineeringService } from './feature-engineering.service';
import { InventoryRiskService } from './inventory-risk.service';
import { PredictionType } from '@prisma/client';

@Injectable()
export class DiscountRecommendationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly aiProvider: AiProvider,
    private readonly featureService: FeatureEngineeringService,
    private readonly riskService: InventoryRiskService,
  ) {}

  async recommendDiscount(inventoryId: string) {
    // 1. We need the risk prediction to feed into the discount model
    const risk = await this.riskService.calculateRisk(inventoryId);
    const features =
      await this.featureService.getInventoryFeatures(inventoryId);

    // Merge risk features into the input for the discount provider
    const combinedFeatures = {
      ...features,
      riskLevel: risk.riskLevel,
      riskScore: risk.riskScore,
    };

    // 2. Recommend discount
    const recommendation =
      await this.aiProvider.recommendDiscount(combinedFeatures);

    // 3. Store the prediction
    await this.prisma.aIPrediction.create({
      data: {
        predictionType: PredictionType.DISCOUNT_RECOMMENDATION,
        entityType: 'Inventory',
        entityId: inventoryId,
        modelVersion: 'rules-v1',
        inputFeatureSnapshot: combinedFeatures as any,
        output: recommendation as any,
        confidence: recommendation.confidence,
      },
    });

    return recommendation;
  }
}
