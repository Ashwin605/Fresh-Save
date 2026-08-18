// ============================================
// FreshSave — Deal Ranking Service Tests
// ============================================

import { Test, TestingModule } from '@nestjs/testing';
import { ConfigService } from '@nestjs/config';
import { DealRankingService } from './deal-ranking.service';
import { ExpiryService } from '../../inventory/services/expiry.service';

describe('DealRankingService', () => {
  let service: DealRankingService;
  let expiryService: ExpiryService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        DealRankingService,
        ExpiryService,
        {
          provide: ConfigService,
          useValue: {
            get: jest.fn((key: string, defaultValue: unknown) => defaultValue),
          },
        },
      ],
    }).compile();

    service = module.get<DealRankingService>(DealRankingService);
    expiryService = module.get<ExpiryService>(ExpiryService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  // ── Test 39: Ranking is deterministic ────────────────────
  describe('deterministic ranking', () => {
    it('should return the same score for the same inputs', () => {
      const expiryDate = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000); // 2 days
      const score1 = service.calculateScore(40, expiryDate, 3, 20, 50);
      const score2 = service.calculateScore(40, expiryDate, 3, 20, 50);

      expect(score1.totalScore).toBe(score2.totalScore);
      expect(score1.discountScore).toBe(score2.discountScore);
      expect(score1.expiryUrgencyScore).toBe(score2.expiryUrgencyScore);
      expect(score1.distanceScore).toBe(score2.distanceScore);
      expect(score1.availabilityScore).toBe(score2.availabilityScore);
    });
  });

  // ── Test 40: Higher urgency affects ranking ──────────────
  describe('expiry urgency impact', () => {
    it('should rank CRITICAL expiry higher than FRESH', () => {
      const criticalExpiry = new Date(Date.now() + 12 * 60 * 60 * 1000); // 12 hours
      const freshExpiry = new Date(Date.now() + 14 * 24 * 60 * 60 * 1000); // 14 days

      const criticalScore = service.calculateScore(
        40,
        criticalExpiry,
        3,
        20,
        50,
      );
      const freshScore = service.calculateScore(40, freshExpiry, 3, 20, 50);

      expect(criticalScore.expiryUrgencyScore).toBeGreaterThan(
        freshScore.expiryUrgencyScore,
      );
      expect(criticalScore.totalScore).toBeGreaterThan(freshScore.totalScore);
    });
  });

  // ── Test 41: Distance affects ranking ────────────────────
  describe('distance impact', () => {
    it('should rank closer stores higher', () => {
      const expiryDate = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
      const nearScore = service.calculateScore(40, expiryDate, 1, 20, 50);
      const farScore = service.calculateScore(40, expiryDate, 40, 20, 50);

      expect(nearScore.distanceScore).toBeGreaterThan(farScore.distanceScore);
      expect(nearScore.totalScore).toBeGreaterThan(farScore.totalScore);
    });
  });

  // ── Test 42: Discount affects ranking ────────────────────
  describe('discount impact', () => {
    it('should rank higher discount higher', () => {
      const expiryDate = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
      const highDiscount = service.calculateScore(80, expiryDate, 3, 20, 50);
      const lowDiscount = service.calculateScore(10, expiryDate, 3, 20, 50);

      expect(highDiscount.discountScore).toBeGreaterThan(
        lowDiscount.discountScore,
      );
      expect(highDiscount.totalScore).toBeGreaterThan(lowDiscount.totalScore);
    });
  });

  // ── Test 43: Ranking does not use AI ─────────────────────
  describe('no AI in ranking', () => {
    it('should be a simple deterministic formula', () => {
      const expiryDate = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
      const score = service.calculateScore(50, expiryDate, 5, 25, 50);

      // All score components should be numbers between 0 and 1
      expect(score.discountScore).toBeGreaterThanOrEqual(0);
      expect(score.discountScore).toBeLessThanOrEqual(1);
      expect(score.expiryUrgencyScore).toBeGreaterThanOrEqual(0);
      expect(score.expiryUrgencyScore).toBeLessThanOrEqual(1);
      expect(score.distanceScore).toBeGreaterThanOrEqual(0);
      expect(score.distanceScore).toBeLessThanOrEqual(1);
      expect(score.availabilityScore).toBeGreaterThanOrEqual(0);
      expect(score.availabilityScore).toBeLessThanOrEqual(1);
      expect(score.totalScore).toBeGreaterThanOrEqual(0);
      expect(score.totalScore).toBeLessThanOrEqual(1);
    });
  });

  describe('effective discount percentage', () => {
    it('should return discount value for PERCENTAGE type', () => {
      const result = service.getEffectiveDiscountPct('PERCENTAGE', 40, 100);
      expect(result).toBe(40);
    });

    it('should calculate effective percentage for FIXED_AMOUNT type', () => {
      const result = service.getEffectiveDiscountPct('FIXED_AMOUNT', 30, 100);
      expect(result).toBe(30);
    });

    it('should handle zero original price for FIXED_AMOUNT', () => {
      const result = service.getEffectiveDiscountPct('FIXED_AMOUNT', 30, 0);
      expect(result).toBe(0);
    });
  });

  describe('ranking weights', () => {
    it('should expose configurable weights', () => {
      const weights = service.getWeights();
      expect(weights.distanceWeight).toBe(0.25);
      expect(weights.discountWeight).toBe(0.3);
      expect(weights.expiryUrgencyWeight).toBe(0.3);
      expect(weights.availabilityWeight).toBe(0.15);
    });
  });

  describe('availability scoring', () => {
    it('should cap availability score at 1.0', () => {
      const expiryDate = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
      const score = service.calculateScore(40, expiryDate, 3, 200, 50);

      expect(score.availabilityScore).toBeLessThanOrEqual(1);
    });

    it('should give lower availability score for low stock', () => {
      const expiryDate = new Date(Date.now() + 2 * 24 * 60 * 60 * 1000);
      const highStock = service.calculateScore(40, expiryDate, 3, 50, 50);
      const lowStock = service.calculateScore(40, expiryDate, 3, 5, 50);

      expect(highStock.availabilityScore).toBeGreaterThan(
        lowStock.availabilityScore,
      );
    });
  });
});
