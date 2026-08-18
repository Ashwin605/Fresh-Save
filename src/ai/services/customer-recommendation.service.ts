import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { PredictionType } from '@prisma/client';

export interface DealRecommendationRequest {
  latitude: number;
  longitude: number;
  radiusKm?: number;
}

@Injectable()
export class CustomerRecommendationService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Re-ranks deals for a customer based on geographical proximity, discount depth, and expiry urgency.
   * This is a foundation for personalized AI recommendations.
   */
  async recommendDeals(customerId: string, params: DealRecommendationRequest) {
    // 1. Fetch baseline candidate deals (In a real scenario, we would call DiscoveryService directly)
    // For this milestone, we will simulate fetching active offers.
    const activeOffers = await this.prisma.offer.findMany({
      where: {
        status: 'ACTIVE',
        inventory: {
          stockQuantity: { gt: 0 },
        },
      },
      include: {
        inventory: {
          include: {
            store: true,
            product: true,
          },
        },
      },
      take: 50,
    });

    // 2. Score each deal
    const scoredDeals = activeOffers.map((offer) => {
      let score = 0;
      const reasons: string[] = [];

      // A. Discount Depth (higher discount = better score)
      // Normalizing up to 100%
      const discountScore = Number(offer.discountValue) / 100;
      score += discountScore * 0.4; // 40% weight
      if (Number(offer.discountValue) >= 50) {
        reasons.push('High discount depth (>= 50%).');
      }

      // B. Expiry Urgency (closer to expiry = better score for food waste reduction)
      const now = new Date();
      const hoursUntilExpiry =
        (offer.inventory.expiryDate.getTime() - now.getTime()) /
        (1000 * 60 * 60);
      let expiryScore = 0;

      if (hoursUntilExpiry > 0 && hoursUntilExpiry < 24) {
        expiryScore = 1.0;
        reasons.push('Expiring very soon (within 24 hours).');
      } else if (hoursUntilExpiry < 72) {
        expiryScore = 0.5;
      }
      score += expiryScore * 0.3; // 30% weight

      // C. Distance (closer = better score)
      const storeLat = Number(offer.inventory.store.latitude);
      const storeLon = Number(offer.inventory.store.longitude);

      // Basic euclidean distance for ranking purposes (in a real app, use PostGIS ST_Distance)
      const distance =
        Math.sqrt(
          Math.pow(storeLat - params.latitude, 2) +
            Math.pow(storeLon - params.longitude, 2),
        ) * 111; // rough approximation to KM

      // Max radius penalty (assume deals beyond 20km are 0 score)
      const maxRadius = params.radiusKm || 20;
      const distanceScore = Math.max(0, 1 - distance / maxRadius);
      score += distanceScore * 0.3; // 30% weight

      if (distance < 2) {
        reasons.push('Very close to your location (< 2km).');
      }

      return {
        offerId: offer.id,
        productId: offer.inventory.productId,
        productName: offer.inventory.product.name,
        storeName: offer.inventory.store.name,
        discount: Number(offer.discountValue),
        distanceKm: parseFloat(distance.toFixed(2)),
        score: parseFloat(score.toFixed(3)),
        reasons,
      };
    });

    // 3. Sort by AI Score descending
    scoredDeals.sort((a, b) => b.score - a.score);

    // 4. We can log this interaction optionally, but to avoid spamming the AIPrediction table
    // on every customer search, we might only log if the user interacts (in a real system).
    // For milestone compliance, we will log the batch recommendation.

    await this.prisma.aIPrediction.create({
      data: {
        predictionType: PredictionType.DEAL_RECOMMENDATION,
        entityType: 'User',
        entityId: customerId,
        modelVersion: 'customer-ranking-v1',
        inputFeatureSnapshot: {
          latitude: params.latitude,
          longitude: params.longitude,
          radiusKm: params.radiusKm,
        },
        output: scoredDeals.slice(0, 5) as any, // Only store top 5 in DB
        confidence: 0.75,
      },
    });

    return scoredDeals.slice(0, 20); // Return top 20 to user
  }
}
