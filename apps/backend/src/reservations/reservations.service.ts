// ============================================
// FreshSave — Reservations Orchestration Service
// ============================================

import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import {
  ReservationTransactionService,
  CreateReservationItemParam,
} from './services/reservation-transaction.service';
import { ReservationLifecycleService } from './services/reservation-lifecycle.service';
import { CreateReservationDto } from './dto/create-reservation.dto';
import {
  CustomerReservationQueryDto,
  StoreReservationQueryDto,
  AdminReservationQueryDto,
} from './dto/reservation-query.dto';
import { RESERVATION_CONSTANTS } from './constants/reservations.constants';
import { Prisma, ReservationStatus } from '@prisma/client';
import * as crypto from 'crypto';
import { ConfigService } from '@nestjs/config';
import { CouponsService } from '../coupons/coupons.service';
import { PricingService } from '../pricing/pricing.service';

@Injectable()
export class ReservationsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly txService: ReservationTransactionService,
    private readonly lifecycleService: ReservationLifecycleService,
    private readonly configService: ConfigService,
    private readonly couponsService: CouponsService,
    private readonly pricingService: PricingService,
  ) {}

  // ── CUSTOMER ACTIONS ───────────────────────────────────────────

  async createReservation(
    customerId: string,
    dto: CreateReservationDto,
    idempotencyKey?: string,
  ) {
    // 1. Idempotency Check
    if (idempotencyKey) {
      const existing = await this.prisma.reservation.findUnique({
        where: { idempotencyKey },
        include: { items: true },
      });
      if (existing) {
        if (existing.customerId !== customerId) {
          throw new ForbiddenException(
            'Idempotency key collision with another user.',
          );
        }
        return existing;
      }
    }

    // 2 & 3. Authoritative Pricing Calculation
    // The PricingService handles loading DB prices, offers, validating coupons, limits and math.
    const priceSnapshot = await this.pricingService.calculateCartPrice({
      customerId,
      storeId: dto.storeId,
      items: dto.items,
      couponCode: dto.couponCode,
    });

    // 4. Map the calculated snapshot to ReservationItemParams for transaction
    const createItemParams: CreateReservationItemParam[] = priceSnapshot.items.map(item => ({
      inventoryId: item.inventoryId,
      productId: item.productId,
      offerId: item.offerId,
      quantity: item.quantity,
      originalUnitPrice: item._rawOriginalPrice,
      discountedUnitPrice: item._rawDiscountedPrice,
      discountAmount: item._rawOriginalPrice.minus(item._rawDiscountedPrice),
      subtotal: item._rawSubtotal,
    }));

    // 5. Generate Code & Expiry
    const reservationCode = this.generateReservationCode();
    const holdMinutes =
      this.configService.get<number>('RESERVATION_HOLD_MINUTES') ||
      RESERVATION_CONSTANTS.DEFAULT_HOLD_MINUTES;
    const expiresAt = new Date(Date.now() + holdMinutes * 60000);

    // 6. Execute Transaction using EXACT snapshot from PricingService
    const reservation = await this.txService.createReservation({
      customerId,
      storeId: dto.storeId,
      reservationCode,
      idempotencyKey,
      expiresAt,
      notes: dto.notes,
      items: createItemParams,
      subtotal: priceSnapshot._raw.totalSubtotal,
      totalDiscount: priceSnapshot._raw.totalDiscount,
      totalAmount: priceSnapshot._raw.finalTotal,
    });

    if (priceSnapshot._raw.appliedCouponId) {
      await this.prisma.reservation.update({
        where: { id: reservation.id },
        data: { appliedCouponId: priceSnapshot._raw.appliedCouponId }
      });
      
      await this.prisma.couponUsage.create({
        data: {
          couponId: priceSnapshot._raw.appliedCouponId,
          customerId: customerId,
          orderId: reservation.id,
        }
      });

      await this.prisma.coupon.update({
        where: { id: priceSnapshot._raw.appliedCouponId },
        data: { usedCount: { increment: 1 } }
      });
    }

    return reservation;
  }

  async cancelReservation(
    customerId: string,
    reservationId: string,
    reason?: string,
  ) {
    const reservation = await this.getReservationIfOwner(
      reservationId,
      customerId,
    );

    this.lifecycleService.validateTransition(
      reservation.status,
      ReservationStatus.CANCELLED,
    );

    return this.txService.releaseReservation(
      reservationId,
      ReservationStatus.CANCELLED,
      customerId,
      reason,
    );
  }

  async getCustomerReservations(
    customerId: string,
    query: CustomerReservationQueryDto,
  ) {
    const { status, startDate, endDate, page = 1, limit = 20 } = query;
    const where: Prisma.ReservationWhereInput = { customerId };

    if (status) where.status = status;
    if (startDate || endDate) {
      where.createdAt = {};
      if (startDate) where.createdAt.gte = new Date(startDate);
      if (endDate) where.createdAt.lte = new Date(endDate);
    }

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.reservation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: { store: true, items: { include: { product: true } } },
      }),
      this.prisma.reservation.count({ where }),
    ]);

    return {
      items,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async getCustomerReservationById(customerId: string, reservationId: string) {
    return this.getReservationIfOwner(reservationId, customerId, true);
  }

  // ── STORE ACTIONS ──────────────────────────────────────────────

  async getStoreReservations(
    userId: string,
    storeId: string,
    query: StoreReservationQueryDto,
  ) {
    await this.verifyStoreAccess(storeId, userId);

    const {
      status,
      startDate,
      endDate,
      reservationCode,
      page = 1,
      limit = 20,
    } = query;
    const where: Prisma.ReservationWhereInput = { storeId };

    if (status) where.status = status;
    if (reservationCode) where.reservationCode = reservationCode;
    if (startDate || endDate) {
      where.createdAt = {};
      if (startDate) where.createdAt.gte = new Date(startDate);
      if (endDate) where.createdAt.lte = new Date(endDate);
    }

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.reservation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
        include: {
          customer: { select: { id: true, name: true, phone: true } },
          items: { include: { product: true } },
        },
      }),
      this.prisma.reservation.count({ where }),
    ]);

    return {
      items,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async confirmReservation(userId: string, reservationId: string) {
    const reservation = await this.getReservationForStoreAction(
      reservationId,
      userId,
    );

    // Cannot confirm if expired in real time
    if (
      reservation.status === ReservationStatus.PENDING &&
      reservation.expiresAt <= new Date()
    ) {
      throw new BadRequestException(
        'Reservation has expired and cannot be confirmed.',
      );
    }

    this.lifecycleService.validateTransition(
      reservation.status,
      ReservationStatus.CONFIRMED,
    );
    return this.txService.updateReservationStatus(
      reservationId,
      ReservationStatus.CONFIRMED,
      userId,
    );
  }

  async rejectReservation(
    userId: string,
    reservationId: string,
    reason?: string,
  ) {
    const reservation = await this.getReservationForStoreAction(
      reservationId,
      userId,
    );
    this.lifecycleService.validateTransition(
      reservation.status,
      ReservationStatus.REJECTED,
    );

    return this.txService.releaseReservation(
      reservationId,
      ReservationStatus.REJECTED,
      userId,
      reason,
    );
  }

  async markReady(userId: string, reservationId: string) {
    const reservation = await this.getReservationForStoreAction(
      reservationId,
      userId,
    );
    this.lifecycleService.validateTransition(
      reservation.status,
      ReservationStatus.READY,
    );
    return this.txService.updateReservationStatus(
      reservationId,
      ReservationStatus.READY,
      userId,
    );
  }

  async completeReservation(userId: string, reservationId: string) {
    const reservation = await this.getReservationForStoreAction(
      reservationId,
      userId,
    );
    this.lifecycleService.validateTransition(
      reservation.status,
      ReservationStatus.COMPLETED,
    );
    return this.txService.completeReservation(reservationId, userId);
  }

  // ── ADMIN ACTIONS ──────────────────────────────────────────────

  async getAdminReservations(query: AdminReservationQueryDto) {
    const {
      status,
      startDate,
      endDate,
      storeId,
      customerId,
      page = 1,
      limit = 20,
    } = query;
    const where: Prisma.ReservationWhereInput = {};

    if (status) where.status = status;
    if (storeId) where.storeId = storeId;
    if (customerId) where.customerId = customerId;
    // Note: businessId filtering requires a join, skipping for brevity but can be added if needed

    if (startDate || endDate) {
      where.createdAt = {};
      if (startDate) where.createdAt.gte = new Date(startDate);
      if (endDate) where.createdAt.lte = new Date(endDate);
    }

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.reservation.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.reservation.count({ where }),
    ]);

    return {
      items,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  // ── HELPERS ────────────────────────────────────────────────────

  private async getReservationIfOwner(
    reservationId: string,
    customerId: string,
    includeAll = false,
  ) {
    const reservation = await this.prisma.reservation.findUnique({
      where: { id: reservationId },
      include: includeAll
        ? { store: true, items: { include: { product: true } } }
        : undefined,
    });

    if (!reservation) {
      throw new NotFoundException('Reservation not found');
    }
    if (reservation.customerId !== customerId) {
      throw new ForbiddenException(
        'You do not have access to this reservation.',
      );
    }

    return reservation;
  }

  private async getReservationForStoreAction(
    reservationId: string,
    userId: string,
  ) {
    const reservation = await this.prisma.reservation.findUnique({
      where: { id: reservationId },
      select: { id: true, storeId: true, status: true, expiresAt: true },
    });

    if (!reservation) {
      throw new NotFoundException('Reservation not found');
    }

    await this.verifyStoreAccess(reservation.storeId, userId);

    return reservation;
  }

  private async verifyStoreAccess(storeId: string, userId: string) {
    const store = await this.prisma.store.findUnique({
      where: { id: storeId },
      include: { business: true },
    });

    if (!store) {
      throw new NotFoundException('Store not found');
    }

    if (store.business.ownerId === userId) return; // Shop Owner

    const staff = await this.prisma.storeStaff.findUnique({
      where: { storeId_userId: { storeId, userId } },
    });

    if (!staff || staff.status !== 'ACTIVE') {
      throw new ForbiddenException(
        'You are not authorized to manage reservations for this store.',
      );
    }
  }

  private generateReservationCode(): string {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let randomPart = '';
    for (let i = 0; i < RESERVATION_CONSTANTS.CODE_LENGTH; i++) {
      randomPart += chars.charAt(crypto.randomInt(chars.length));
    }
    return `${RESERVATION_CONSTANTS.CODE_PREFIX}${randomPart}`;
  }
}
