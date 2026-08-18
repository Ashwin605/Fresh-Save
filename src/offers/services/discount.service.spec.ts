/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { DiscountService } from './discount.service';
import { DiscountType, Prisma } from '@prisma/client';
import { BadRequestException } from '@nestjs/common';

describe('DiscountService', () => {
  let service: DiscountService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [DiscountService],
    }).compile();

    service = module.get<DiscountService>(DiscountService);
  });

  describe('calculateDiscount', () => {
    it('should correctly calculate a PERCENTAGE discount', () => {
      const original = new Prisma.Decimal('100.00');
      const result = service.calculateDiscount(original, DiscountType.PERCENTAGE, 25);
      expect(result.discountedPrice.toFixed(2)).toBe('75.00');
      expect(result.discountAmount.toFixed(2)).toBe('25.00');
    });

    it('should correctly calculate a FIXED_AMOUNT discount', () => {
      const original = new Prisma.Decimal('150.00');
      const result = service.calculateDiscount(original, DiscountType.FIXED_AMOUNT, 30.50);
      expect(result.discountedPrice.toFixed(2)).toBe('119.50');
      expect(result.discountAmount.toFixed(2)).toBe('30.50');
    });

    it('should throw if discount is negative', () => {
      const original = new Prisma.Decimal('100.00');
      expect(() => service.calculateDiscount(original, DiscountType.FIXED_AMOUNT, -5))
        .toThrow(BadRequestException);
    });

    it('should throw if percentage discount exceeds max limit', () => {
      const original = new Prisma.Decimal('100.00');
      expect(() => service.calculateDiscount(original, DiscountType.PERCENTAGE, 96)) // Assumes max is 95
        .toThrow(BadRequestException);
    });

    it('should throw if discounted price becomes negative', () => {
      const original = new Prisma.Decimal('100.00');
      expect(() => service.calculateDiscount(original, DiscountType.FIXED_AMOUNT, 110))
        .toThrow(BadRequestException);
    });
  });
});
