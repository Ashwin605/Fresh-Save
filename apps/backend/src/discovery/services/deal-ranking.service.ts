// ============================================
// FreshSave — Deal Ranking Service
// ============================================

import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ExpiryService } from '../../inventory/services/expiry.service';
import {
  EXPIRY_URGENCY_SCORES,
  DEFAULT_RANKING_WEIGHTS,
  AVAILABILITY_CAP,
} from '../constants/discovery.constants';
import {
  RankingScoreBreakdown,
  RankingWeights,
} from '../interfaces/discovery.interfaces';

/**
 * Deterministic deal ranking service.
 *
 * Formula:
 *   score = (discountScore × discountWeight)
 *         + (expiryUrgencyScore × expiryUrgencyWeight)
 *         + (distanceScore × distanceWeight)
 *         + (availabilityScore × availabilityWeight)
 *
 * Each factor is normalized to 0..1.
 * Weights are configurable via environment variables.
 *
 * This is NOT AI — it is a deterministic, explainable formula.
 */
@Injectable()
export class DealRankingService {
  private readonly logger = new Logger(DealRankingService.name);
  private readonly weights: RankingWeights;

  constructor(
    private readonly configService: ConfigService,
    private readonly expiryService: ExpiryService,
  ) {
    this.weights = {
      distanceWeight: this.configService.get<number>(
        'discovery.ranking.distanceWeight',
        DEFAULT_RANKING_WEIGHTS.distanceWeight,
      ),
      discountWeight: this.configService.get<number>(
        'discovery.ranking.discountWeight',
        DEFAULT_RANKING_WEIGHTS.discountWeight,
      ),
      expiryUrgencyWeight: this.configService.get<number>(
        'discovery.ranking.expiryUrgencyWeight',
        DEFAULT_RANKING_WEIGHTS.expiryUrgencyWeight,
      ),
      availabilityWeight: this.configService.get<number>(
        'discovery.ranking.availabilityWeight',
        DEFAULT_RANKING_WEIGHTS.availabilityWeight,
      ),
    };

    this.logger.log(
      `Ranking weights initialized: ${JSON.stringify(this.weights)}`,
    );
  }

  /**
   * Calculate the relevance score for a deal.
   *
   * @param effectiveDiscountPct - The effective discount percentage (0-100)
   * @param expiryDate - The inventory expiry date
   * @param distanceKm - Distance from customer in kilometers
   * @param availableQuantity - Available stock (stock - reserved)
   * @param maxRadiusKm - Maximum radius for distance normalization
   * @returns Score breakdown with total score (0..1)
   */
  calculateScore(
    effectiveDiscountPct: number,
    expiryDate: Date,
    distanceKm: number,
    availableQuantity: number,
    maxRadiusKm: number,
  ): RankingScoreBreakdown {
    // 1. Discount score: higher discount = higher score (normalized 0..1)
    const discountScore = Math.min(effectiveDiscountPct / 100, 1);

    // 2. Expiry urgency score: uses the existing ExpiryService
    const expiryStatus = this.expiryService.getExpiryStatus(expiryDate);
    const expiryUrgencyScore = EXPIRY_URGENCY_SCORES[expiryStatus] ?? 0;

    // 3. Distance score: closer = higher score (normalized 0..1)
    // 1 - (distance / maxRadius), clamped to [0, 1]
    const distanceScore = Math.max(
      0,
      1 - Math.min(distanceKm / maxRadiusKm, 1),
    );

    // 4. Availability score: more stock = slightly more confidence (capped)
    const availabilityScore = Math.min(availableQuantity / AVAILABILITY_CAP, 1);

    // Weighted sum
    const totalScore =
      discountScore * this.weights.discountWeight +
      expiryUrgencyScore * this.weights.expiryUrgencyWeight +
      distanceScore * this.weights.distanceWeight +
      availabilityScore * this.weights.availabilityWeight;

    return {
      discountScore: Math.round(discountScore * 1000) / 1000,
      expiryUrgencyScore: Math.round(expiryUrgencyScore * 1000) / 1000,
      distanceScore: Math.round(distanceScore * 1000) / 1000,
      availabilityScore: Math.round(availabilityScore * 1000) / 1000,
      totalScore: Math.round(totalScore * 1000) / 1000,
    };
  }

  /**
   * Calculate effective discount percentage regardless of discount type.
   * For PERCENTAGE type, it's the discount value itself.
   * For FIXED_AMOUNT type, it's (discountAmount / originalPrice) * 100.
   */
  getEffectiveDiscountPct(
    discountType: string,
    discountValue: number,
    originalPrice: number,
  ): number {
    if (discountType === 'PERCENTAGE') {
      return discountValue;
    }

    // FIXED_AMOUNT: calculate effective percentage
    if (originalPrice <= 0) return 0;
    return (discountValue / originalPrice) * 100;
  }

  /**
   * Get the current ranking weights (for debugging/documentation).
   */
  getWeights(): RankingWeights {
    return { ...this.weights };
  }
}
