import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { CreateCouponDto } from './dto/create-coupon.dto';
import { UpdateCouponDto } from './dto/update-coupon.dto';
import { DiscountType, ReservationStatus } from '@prisma/client';

@Injectable()
export class CouponsService {
  constructor(private readonly prisma: PrismaService) {}

  async create(data: CreateCouponDto) {
    const code = data.code.trim().toUpperCase();
    const existing = await this.prisma.coupon.findUnique({ where: { code } });
    if (existing) {
      throw new BadRequestException('Coupon code already exists');
    }
    return this.prisma.coupon.create({ data: { ...data, code } });
  }

  async findAllAdmin(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.coupon.findMany({ skip, take: limit, orderBy: { createdAt: 'desc' }, include: { shop: true } }),
      this.prisma.coupon.count(),
    ]);
    return { data, total, page, limit };
  }

  async update(id: string, data: UpdateCouponDto) {
    if (data.code) {
      data.code = data.code.trim().toUpperCase();
    }

    const immutableFields = [
      'code',
      'discountType',
      'discountValue',
      'minimumOrderAmount',
      'maximumDiscountAmount',
      'shopId',
    ];

    const attemptedEdits = Object.keys(data).filter(
      (key) => immutableFields.includes(key) && data[key as keyof UpdateCouponDto] !== undefined
    );

    if (attemptedEdits.length > 0) {
      return this.prisma.$transaction(async (tx) => {
        const lockedCoupons = await tx.$queryRawUnsafe<
          { id: string; usedCount: number }[]
        >(
          `SELECT "id", "usedCount" FROM "coupons" WHERE "id" = $1 FOR UPDATE`,
          id,
        );

        if (lockedCoupons.length === 0) {
          throw new NotFoundException('Coupon not found');
        }

        const coupon = lockedCoupons[0];
        if (coupon.usedCount > 0) {
          throw new BadRequestException(
            `Cannot edit ${attemptedEdits.join(', ')} on a coupon that has already been used.`,
          );
        }

        return tx.coupon.update({
          where: { id },
          data,
        });
      });
    }

    try {
      return await this.prisma.coupon.update({
        where: { id },
        data,
      });
    } catch (error: any) {
      if (error.code === 'P2025') {
        throw new NotFoundException('Coupon not found');
      }
      throw error;
    }
  }

  async remove(id: string) {
    return this.prisma.coupon.update({ where: { id }, data: { isActive: false } });
  }

  async findAllAvailable(userId: string) {
    const now = new Date();
    const coupons = await this.prisma.coupon.findMany({
      where: {
        isActive: true,
        startDate: { lte: now },
        expiryDate: { gte: now },
      },
      include: { shop: { select: { id: true, name: true } } },
    });
    return { success: true, data: { coupons } };
  }

  async validateCoupon(code: string, storeId: string | undefined, subtotal: number, userId: string) {
    code = code.trim().toUpperCase();
    const coupon = await this.prisma.coupon.findUnique({ where: { code } });
    
    if (!coupon) {
      return { success: true, valid: false, message: 'Invalid coupon code.' };
    }
    
    if (!coupon.isActive) {
      return { success: true, valid: false, message: 'This coupon is currently unavailable.' };
    }
    
    const now = new Date();
    if (coupon.startDate > now) {
      return { success: true, valid: false, message: 'This coupon is not active yet.' };
    }
    
    if (coupon.expiryDate < now) {
      return { success: true, valid: false, message: 'This coupon has expired.' };
    }
    
    if (coupon.usageLimit && coupon.usedCount >= coupon.usageLimit) {
      return { success: true, valid: false, message: 'This coupon has reached its usage limit.' };
    }

    if (coupon.perUserLimit) {
      const userUsageCount = await this.prisma.couponUsage.count({
        where: { couponId: coupon.id, customerId: userId },
      });
      if (userUsageCount >= coupon.perUserLimit) {
        return { success: true, valid: false, message: 'You have already used this coupon.' };
      }
    }

    if (coupon.shopId && coupon.shopId !== storeId) {
      return { success: true, valid: false, message: 'This coupon is not valid for this shop.' };
    }

    if (coupon.minimumOrderAmount && subtotal < Number(coupon.minimumOrderAmount)) {
      return { success: true, valid: false, message: `Add ₹${(Number(coupon.minimumOrderAmount) - subtotal).toFixed(2)} more to use this coupon.` };
    }

    return {
      success: true,
      valid: true,
      message: 'Coupon is valid',
      data: {
        couponId: coupon.id,
        code: coupon.code,
        discountType: coupon.discountType,
        discountValue: Number(coupon.discountValue),
      }
    };
  }
}
