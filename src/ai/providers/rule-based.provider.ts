import { Injectable, Logger } from '@nestjs/common';
import {
  AiProvider,
  RiskPredictionOutput,
  DiscountRecommendationOutput,
} from './ai-provider.interface';

@Injectable()
export class RuleBasedProvider implements AiProvider {
  private readonly logger = new Logger(RuleBasedProvider.name);

  async predictInventoryRisk(features: any): Promise<RiskPredictionOutput> {
    const {
      inventoryId,
      availableQuantity,
      hoursUntilExpiry,
      dailyVelocity,
      hasSufficientHistory,
    } = features;

    const daysUntilExpiry = Math.max(hoursUntilExpiry / 24, 0.01);
    let riskScore = 0.5;
    let confidence = 0.5;
    let riskLevel: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL' = 'MEDIUM';
    const reasons: string[] = [];

    if (!hasSufficientHistory) {
      confidence = 0.2;
      reasons.push('Insufficient historical demand data (Cold Start).');
    } else {
      confidence = 0.85; // Heuristic statistical confidence

      const expectedSales = dailyVelocity * daysUntilExpiry;
      const coverageRatio = availableQuantity / (expectedSales || 0.1); // Avoid division by zero

      if (coverageRatio < 0.5) {
        riskScore = 0.1;
        riskLevel = 'LOW';
        reasons.push(
          `Expected sales (${expectedSales.toFixed(1)}) exceeds available stock (${availableQuantity}).`,
        );
      } else if (coverageRatio < 1.0) {
        riskScore = 0.3;
        riskLevel = 'MEDIUM';
        reasons.push(`Demand pace is sufficient to clear stock.`);
      } else if (coverageRatio < 2.0) {
        riskScore = 0.7;
        riskLevel = 'HIGH';
        reasons.push(
          `Expected sales (${expectedSales.toFixed(1)}) is lower than available stock (${availableQuantity}).`,
        );
      } else {
        riskScore = 0.95;
        riskLevel = 'CRITICAL';
        reasons.push(
          `Significant excess stock relative to demand velocity (${dailyVelocity.toFixed(1)}/day).`,
        );
      }
    }

    // Overrides for immediate expiry urgency
    if (hoursUntilExpiry < 24 && availableQuantity > 0) {
      riskScore = Math.max(riskScore, 0.9);
      riskLevel = 'CRITICAL';
      reasons.push('Inventory expires within 24 hours!');
    } else if (hoursUntilExpiry < 72 && availableQuantity > 10) {
      riskScore = Math.max(riskScore, 0.8);
      riskLevel = 'HIGH';
      reasons.push('Inventory expires within 3 days with significant stock.');
    }

    return {
      inventoryId,
      riskLevel,
      riskScore: parseFloat(riskScore.toFixed(2)),
      daysUntilExpiry: parseFloat(daysUntilExpiry.toFixed(2)),
      availableQuantity,
      confidence,
      reasons,
    };
  }

  async recommendDiscount(
    features: any,
  ): Promise<DiscountRecommendationOutput> {
    const {
      inventoryId,
      riskLevel,
      riskScore,
      originalPrice,
      currentDiscount,
    } = features;

    let targetDiscountValue = 0;
    const reasons: string[] = [];

    if (riskLevel === 'CRITICAL') {
      targetDiscountValue = 60; // 60%
      reasons.push(
        'Critical risk level requires aggressive discounting to clear stock.',
      );
    } else if (riskLevel === 'HIGH') {
      targetDiscountValue = 40;
      reasons.push('High risk level suggests a moderate to high discount.');
    } else if (riskLevel === 'MEDIUM') {
      targetDiscountValue = 20;
      reasons.push('Medium risk level suggests a small promotional discount.');
    } else {
      targetDiscountValue = 0;
      reasons.push(
        'Low risk level indicates no discount is strictly necessary.',
      );
    }

    // Keep existing discount if it's already higher than our recommendation
    if (currentDiscount && currentDiscount > targetDiscountValue) {
      targetDiscountValue = currentDiscount;
      reasons.push(
        `Maintaining current aggressive discount of ${currentDiscount}%.`,
      );
    }

    const expectedPrice = originalPrice * (1 - targetDiscountValue / 100);

    return {
      inventoryId,
      recommendedDiscount: {
        type: 'PERCENTAGE',
        value: targetDiscountValue,
      },
      expectedPrice: parseFloat(expectedPrice.toFixed(2)),
      confidence: 0.8, // Model confidence
      riskLevel,
      reasoning: reasons,
    };
  }
}
