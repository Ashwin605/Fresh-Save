import { Injectable, BadRequestException, NotFoundException, ConflictException } from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { CreateShopRatingDto } from './dto/create-shop-rating.dto';
import { ReservationStatus } from '@prisma/client';

@Injectable()
export class ShopRatingsService {
  constructor(private prisma: PrismaService) {}

  async createRating(shopId: string, customerId: string, dto: CreateShopRatingDto) {
    // 1. Check if the order/reservation exists and belongs to the customer & shop
    const order = await this.prisma.reservation.findUnique({
      where: { id: dto.orderId },
    });

    if (!order) {
      throw new NotFoundException('Order not found.');
    }

    if (order.customerId !== customerId) {
      throw new BadRequestException('Order does not belong to you.');
    }

    if (order.storeId !== shopId) {
      throw new BadRequestException('Order does not belong to this shop.');
    }

    // 2. Check if the order is completed
    if (order.status !== ReservationStatus.COMPLETED) {
      throw new BadRequestException('You can rate the shop after your order is completed.');
    }

    // 3. Check if rating already exists
    const existingRating = await this.prisma.shopRating.findUnique({
      where: {
        customerId_orderId: {
          customerId: customerId,
          orderId: dto.orderId,
        },
      },
    });

    if (existingRating) {
      throw new ConflictException('You have already rated this order.');
    }

    // 4. Create rating
    const rating = await this.prisma.shopRating.create({
      data: {
        shopId: shopId,
        customerId: customerId,
        orderId: dto.orderId,
        rating: dto.rating,
        review: dto.review,
      },
    });

    return {
      success: true,
      message: 'Rating submitted successfully',
      data: {
        id: rating.id,
        shopId: rating.shopId,
        orderId: rating.orderId,
        rating: rating.rating,
        review: rating.review,
        createdAt: rating.createdAt,
      }
    };
  }

  async getRatings(shopId: string, page: number = 1, limit: number = 10) {
    const skip = (page - 1) * limit;

    const [total, ratings] = await Promise.all([
      this.prisma.shopRating.count({ where: { shopId } }),
      this.prisma.shopRating.findMany({
        where: { shopId },
        include: {
          customer: {
            select: { name: true }
          }
        },
        orderBy: { createdAt: 'desc' },
        skip,
        take: limit,
      }),
    ]);

    return {
      success: true,
      data: {
        ratings: ratings.map(r => ({
          id: r.id,
          rating: r.rating,
          review: r.review,
          customer: {
            name: r.customer.name,
          },
          createdAt: r.createdAt,
        })),
        pagination: {
          page,
          limit,
          total,
        },
      }
    };
  }

  async getRatingSummary(shopId: string) {
    const agg = await this.prisma.shopRating.aggregate({
      where: { shopId },
      _avg: { rating: true },
      _count: { rating: true },
    });

    const totalRatings = agg._count.rating;
    const averageRating = totalRatings > 0 ? Number(agg._avg.rating?.toFixed(1) || 0) : 0;

    const distributionRaw = await this.prisma.shopRating.groupBy({
      by: ['rating'],
      where: { shopId },
      _count: { rating: true },
    });

    const distribution: Record<string, number> = {
      "5": 0, "4": 0, "3": 0, "2": 0, "1": 0
    };

    distributionRaw.forEach(d => {
      distribution[d.rating.toString()] = d._count.rating;
    });

    return {
      success: true,
      data: {
        averageRating,
        totalRatings,
        distribution,
      }
    };
  }
}
