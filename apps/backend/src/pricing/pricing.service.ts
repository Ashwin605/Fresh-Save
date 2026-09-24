import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { CouponsService } from '../coupons/coupons.service';
import { Prisma } from '@prisma/client';

export interface CalculateCartItem {
  inventoryId: string;
  quantity: number;
}

export interface CalculateCartParams {
  customerId: string;
  storeId: string;
  items: CalculateCartItem[];
  couponCode?: string;
}

@Injectable()
export class PricingService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly couponsService: CouponsService,
  ) {}

  async calculateCartPrice(params: CalculateCartParams) {
    const { customerId, storeId, items, couponCode } = params;

    // 1. Validate Store & Business
    const store = await this.prisma.store.findUnique({
      where: { id: storeId },
      include: { business: true },
    });

    if (!store || store.status !== 'ACTIVE' || store.verificationStatus !== 'VERIFIED') {
      throw new BadRequestException('Store is inactive or unverified.');
    }
    if (store.business.status !== 'ACTIVE' || store.business.verificationStatus !== 'VERIFIED') {
      throw new BadRequestException('Business is inactive or unverified.');
    }

    // 2. Prevent duplicate inventory IDs
    const uniqueIds = new Set(items.map((i) => i.inventoryId));
    if (uniqueIds.size !== items.length) {
      throw new BadRequestException('Duplicate inventory items found in request.');
    }

    // 3. Load authoritative product prices & calculate item subtotals
    const resultItems = [];
    let totalSubtotal = new Prisma.Decimal(0);
    let totalOfferDiscount = new Prisma.Decimal(0);

    for (const item of items) {
      const inventory = await this.prisma.inventory.findUnique({
        where: { id: item.inventoryId },
        include: { product: true },
      });

      if (!inventory) {
        throw new BadRequestException(`Inventory item ${item.inventoryId} not found.`);
      }
      if (inventory.storeId !== storeId) {
        throw new BadRequestException(`Inventory ${item.inventoryId} does not belong to the requested store.`);
      }
      if (inventory.status !== 'ACTIVE' || inventory.expiryDate <= new Date()) {
        throw new BadRequestException(`Inventory ${item.inventoryId} is not active or has expired.`);
      }

      // Check Offers
      const now = new Date();
      const offer = await this.prisma.offer.findFirst({
        where: {
          inventoryId: item.inventoryId,
          status: 'ACTIVE',
          startsAt: { lte: now },
          endsAt: { gte: now },
        },
        orderBy: { discountValue: 'desc' },
      });

      const originalPrice = inventory.sellingPrice;
      const discountedPrice = offer ? offer.discountedPrice : originalPrice;
      
      const offerDiscountUnit = originalPrice.minus(discountedPrice);
      const subtotal = originalPrice.mul(item.quantity);
      const offerDiscountTotal = offerDiscountUnit.mul(item.quantity);
      const finalItemPrice = discountedPrice.mul(item.quantity);

      totalSubtotal = totalSubtotal.plus(subtotal);
      totalOfferDiscount = totalOfferDiscount.plus(offerDiscountTotal);

      resultItems.push({
        inventoryId: inventory.id,
        productId: inventory.productId,
        name: inventory.product.name,
        quantity: item.quantity,
        unitPrice: Number(originalPrice),
        subtotal: Number(subtotal),
        offerId: offer ? offer.id : null,
        offerDiscount: Number(offerDiscountTotal),
        finalPrice: Number(finalItemPrice),
        
        // Return raw decimals for precision calculation downstream
        _rawOriginalPrice: originalPrice,
        _rawDiscountedPrice: discountedPrice,
        _rawSubtotal: subtotal,
      });
    }

    // 4. Calculate Subtotal after offers
    const subtotalAfterOffers = totalSubtotal.minus(totalOfferDiscount);
    
    // 5. Validate and Calculate Coupon Discount
    let couponDiscount = new Prisma.Decimal(0);
    let appliedCouponId: string | null = null;
    let couponInfo: any = null;

    if (couponCode) {
      // Use standard validation mechanism
      const validation = await this.couponsService.validateCoupon(
        couponCode,
        storeId,
        Number(subtotalAfterOffers), // Minimum order amount is checked against post-offer subtotal
        customerId
      );
      
      if (!validation.valid || !validation.data) {
        throw new BadRequestException(validation.message);
      }

      appliedCouponId = validation.data.couponId;
      const coupon = await this.prisma.coupon.findUnique({ where: { id: appliedCouponId } });
      
      if (coupon) {
        if (coupon.discountType === 'FIXED_AMOUNT') {
          couponDiscount = coupon.discountValue;
        } else {
          couponDiscount = subtotalAfterOffers.mul(coupon.discountValue.div(100));
          if (coupon.maximumDiscountAmount && couponDiscount.gt(coupon.maximumDiscountAmount)) {
            couponDiscount = coupon.maximumDiscountAmount;
          }
        }
        
        // Prevent negative totals
        if (couponDiscount.gt(subtotalAfterOffers)) {
          couponDiscount = subtotalAfterOffers;
        }

        couponInfo = {
          id: coupon.id,
          code: coupon.code,
          discountType: coupon.discountType,
          discountValue: Number(coupon.discountValue),
          calculatedDiscount: Number(couponDiscount)
        };
      }
    }

    // 6. Delivery Fee and Tax
    // As per user requirement: "Do NOT invent delivery pricing rules. Return tax as zero/omit it according to the existing architecture."
    // Current architecture has no tax or delivery fee modeled in `Reservation`, it only handles `subtotal`, `totalDiscount`, `totalAmount`.
    const deliveryFee = new Prisma.Decimal(0);
    const tax = new Prisma.Decimal(0);

    // 7. Calculate final total
    const totalDiscount = totalOfferDiscount.plus(couponDiscount);
    let finalTotal = totalSubtotal.minus(totalDiscount).plus(deliveryFee).plus(tax);
    
    if (finalTotal.lt(0)) {
      finalTotal = new Prisma.Decimal(0);
    }

    return {
      items: resultItems,
      subtotal: Number(totalSubtotal),
      subtotalAfterOffers: Number(subtotalAfterOffers),
      offerDiscount: Number(totalOfferDiscount),
      couponDiscount: Number(couponDiscount),
      totalDiscount: Number(totalDiscount),
      deliveryFee: Number(deliveryFee),
      tax: Number(tax),
      total: Number(finalTotal),
      coupon: couponInfo,
      
      // Raw values for precision storage in DB
      _raw: {
        totalSubtotal,
        totalOfferDiscount,
        couponDiscount,
        totalDiscount,
        finalTotal,
        appliedCouponId,
      }
    };
  }
}
