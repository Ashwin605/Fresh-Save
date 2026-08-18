import { Injectable, BadRequestException } from '@nestjs/common';
import { DiscountType, Prisma } from '@prisma/client';
import { OFFERS_CONSTANTS } from '../constants/offers.constants';

@Injectable()
export class DiscountService {
  /**
   * Calculates the discounted price given the original price, discount type, and discount value.
   * Uses Prisma's Decimal for safe monetary math.
   *
   * @param originalPrice The original selling price of the inventory
   * @param discountType 'PERCENTAGE' or 'FIXED_AMOUNT'
   * @param discountValue The numeric value of the discount
   * @returns The newly calculated discounted price
   */
  calculateDiscount(
    originalPrice: Prisma.Decimal,
    discountType: DiscountType,
    discountValue: number,
  ): { discountedPrice: Prisma.Decimal; discountAmount: Prisma.Decimal } {
    // Basic validations
    if (discountValue <= 0) {
      throw new BadRequestException('Discount value must be greater than zero');
    }

    if (
      discountType === DiscountType.PERCENTAGE &&
      discountValue > OFFERS_CONSTANTS.MAX_DISCOUNT_PERCENTAGE
    ) {
      throw new BadRequestException(
        `Discount percentage cannot exceed ${OFFERS_CONSTANTS.MAX_DISCOUNT_PERCENTAGE}%`,
      );
    }

    let finalPrice = new Prisma.Decimal(originalPrice);
    const value = new Prisma.Decimal(discountValue);
    let discountAmount = new Prisma.Decimal(0);

    if (discountType === DiscountType.PERCENTAGE) {
      // (original * percentage) / 100
      discountAmount = finalPrice.mul(value).div(100);
      finalPrice = finalPrice.sub(discountAmount);
    } else if (discountType === DiscountType.FIXED_AMOUNT) {
      discountAmount = value;
      finalPrice = finalPrice.sub(discountAmount);
    }

    // Must not be negative
    if (finalPrice.lessThan(OFFERS_CONSTANTS.MIN_DISCOUNTED_PRICE)) {
      throw new BadRequestException(
        `Calculated discounted price cannot be less than ${OFFERS_CONSTANTS.MIN_DISCOUNTED_PRICE}`,
      );
    }

    // Must not exceed original price
    if (finalPrice.greaterThan(originalPrice)) {
      throw new BadRequestException(
        'Discounted price cannot be greater than original price',
      );
    }

    return {
      discountedPrice: finalPrice.toDecimalPlaces(2),
      discountAmount: discountAmount.toDecimalPlaces(2),
    };
  }
}
