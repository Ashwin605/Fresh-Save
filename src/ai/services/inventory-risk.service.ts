import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AiProvider } from '../providers/ai-provider.interface';
import { FeatureEngineeringService } from './feature-engineering.service';
import { PredictionType } from '@prisma/client';

@Injectable()
export class InventoryRiskService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly aiProvider: AiProvider,
    private readonly featureService: FeatureEngineeringService,
  ) {}

  async calculateRisk(inventoryId: string) {
    // 1. Gather features
    const features =
      await this.featureService.getInventoryFeatures(inventoryId);

    // 2. Call AI Provider for prediction
    const prediction = await this.aiProvider.predictInventoryRisk(features);

    // 3. Store the prediction for audit/history
    await this.prisma.aIPrediction.create({
      data: {
        predictionType: PredictionType.INVENTORY_RISK,
        entityType: 'Inventory',
        entityId: inventoryId,
        modelVersion: 'rules-v1', // Should ideally come from config or the provider itself
        inputFeatureSnapshot: features as any,
        output: prediction as any,
        confidence: prediction.confidence,
      },
    });

    return prediction;
  }
}
