export interface RiskPredictionOutput {
  inventoryId: string;
  riskLevel: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  riskScore: number;
  daysUntilExpiry: number;
  availableQuantity: number;
  confidence: number;
  reasons: string[];
}

export interface DiscountRecommendationOutput {
  inventoryId: string;
  recommendedDiscount: {
    type: 'PERCENTAGE' | 'FIXED';
    value: number;
  };
  expectedPrice: number;
  confidence: number;
  riskLevel: string;
  reasoning: string[];
}

export abstract class AiProvider {
  /**
   * Generates a risk score for a given inventory item.
   * @param features Snapshot of relevant numerical and categorical features.
   */
  abstract predictInventoryRisk(features: any): Promise<RiskPredictionOutput>;

  /**
   * Recommends a discount based on inventory risk and historical features.
   * @param features Snapshot of relevant numerical and categorical features.
   */
  abstract recommendDiscount(
    features: any,
  ): Promise<DiscountRecommendationOutput>;
}
