// ============================================
// FreshSave — Reservation Transaction Service
// ============================================

import {
  Injectable,
  Logger,
  InternalServerErrorException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { OutboxService } from '../../common/outbox/outbox.service';
import { Prisma, ReservationStatus, StockMovementType } from '@prisma/client';

export interface CreateReservationItemParam {
  inventoryId: string;
  productId: string;
  offerId: string | null;
  quantity: number;
  originalUnitPrice: Prisma.Decimal;
  discountedUnitPrice: Prisma.Decimal;
  discountAmount: Prisma.Decimal;
  subtotal: Prisma.Decimal;
}

export interface CreateReservationParam {
  customerId: string;
  storeId: string;
  reservationCode: string;
  idempotencyKey?: string;
  expiresAt: Date;
  notes?: string;
  items: CreateReservationItemParam[];
  subtotal: Prisma.Decimal;
  totalDiscount: Prisma.Decimal;
  totalAmount: Prisma.Decimal;
}

@Injectable()
export class ReservationTransactionService {
  private readonly logger = new Logger(ReservationTransactionService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly auditService: AuditService,
    private readonly outboxService: OutboxService,
  ) {}

  /**
   * Creates a reservation transactionally.
   * Locks inventory rows, validates availability, updates reservedQuantity, and creates records.
   * Uses raw SQL for row locking (SELECT ... FOR UPDATE).
   */
  async createReservation(params: CreateReservationParam) {
    return this.prisma.$transaction(async (tx) => {
      // 1. Sort inventory IDs to prevent deadlocks when locking multiple rows
      const sortedInventoryIds = [...params.items]
        .map((i) => i.inventoryId)
        .sort();

      // 2. Lock inventory rows safely
      const lockedInventoryRows = await tx.$queryRawUnsafe<
        { id: string; stockQuantity: number; reservedQuantity: number }[]
      >(
        `
        SELECT "id", "stockQuantity", "reservedQuantity"
        FROM "Inventory"
        WHERE "id" IN (${sortedInventoryIds.map((_, i) => `$${i + 1}`).join(', ')})
        FOR UPDATE
      `,
        ...sortedInventoryIds,
      );

      const inventoryMap = new Map(
        lockedInventoryRows.map((row) => [row.id, row]),
      );

      // 3. Verify availability for each item
      for (const item of params.items) {
        const inventory = inventoryMap.get(item.inventoryId);
        if (!inventory) {
          throw new BadRequestException(
            `Inventory item ${item.inventoryId} not found or unavailable.`,
          );
        }

        const available = inventory.stockQuantity - inventory.reservedQuantity;
        if (available < item.quantity) {
          throw new BadRequestException(
            `Insufficient stock for inventory ${item.inventoryId}. Requested: ${item.quantity}, Available: ${available}.`,
          );
        }

        // 4. Update reserved quantity in DB directly
        await tx.inventory.update({
          where: { id: item.inventoryId },
          data: {
            reservedQuantity: {
              increment: item.quantity,
            },
          },
        });

        // 5. Create stock movement (RESERVATION_HELD)
        await tx.inventoryStockMovement.create({
          data: {
            inventoryId: item.inventoryId,
            type: StockMovementType.RESERVATION_HELD,
            quantity: item.quantity,
            previousQuantity: inventory.stockQuantity,
            newQuantity: inventory.stockQuantity, // physical stock doesn't change
            reason: `Reservation creation (Code: ${params.reservationCode})`,
            actorId: params.customerId,
          },
        });
      }

      // 6. Create the reservation and its items
      const reservation = await tx.reservation.create({
        data: {
          reservationCode: params.reservationCode,
          idempotencyKey: params.idempotencyKey,
          customerId: params.customerId,
          storeId: params.storeId,
          expiresAt: params.expiresAt,
          notes: params.notes,
          subtotal: params.subtotal,
          totalDiscount: params.totalDiscount,
          totalAmount: params.totalAmount,
          items: {
            create: params.items.map((item) => ({
              inventoryId: item.inventoryId,
              productId: item.productId,
              offerId: item.offerId,
              quantity: item.quantity,
              originalUnitPrice: item.originalUnitPrice,
              discountedUnitPrice: item.discountedUnitPrice,
              discountAmount: item.discountAmount,
              subtotal: item.subtotal,
            })),
          },
        },
        include: {
          items: true,
        },
      });

      // 6.5 Outbox event
      await this.outboxService.createEvent(
        tx,
        'RESERVATION_CREATED',
        'Reservation',
        reservation.id,
        {
          reservationId: reservation.id,
          customerId: reservation.customerId,
          storeId: reservation.storeId,
          reservationCode: reservation.reservationCode,
        },
      );

      // 7. Audit log
      await this.auditService.log(
        {
          actorId: params.customerId,
          action: 'RESERVATION_CREATED',
          entityType: 'Reservation',
          entityId: reservation.id,
          newData: {
            code: reservation.reservationCode,
            items: params.items.length,
          },
        },
        tx,
      );

      return reservation;
    });
  }

  /**
   * Releases reserved stock (used for Cancel, Reject, Expire).
   * Does NOT decrease physical stock, just reserved stock.
   */
  async releaseReservation(
    reservationId: string,
    targetStatus: ReservationStatus,
    actorId: string,
    reason?: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      // 1. Lock the reservation and include items
      const reservations = await tx.$queryRawUnsafe<
        { id: string; status: ReservationStatus; reservationCode: string }[]
      >(
        `
        SELECT "id", "status", "reservationCode"
        FROM "Reservation"
        WHERE "id" = $1
        FOR UPDATE
      `,
        reservationId,
      );

      const lockedReservation = reservations[0];
      if (!lockedReservation) {
        throw new BadRequestException('Reservation not found');
      }

      // Ensure we are releasing an active reservation
      if (
        lockedReservation.status === ReservationStatus.COMPLETED ||
        lockedReservation.status === ReservationStatus.CANCELLED ||
        lockedReservation.status === ReservationStatus.EXPIRED ||
        lockedReservation.status === ReservationStatus.REJECTED
      ) {
        throw new BadRequestException(
          `Reservation is already ${lockedReservation.status}`,
        );
      }

      const items = await tx.reservationItem.findMany({
        where: { reservationId },
        select: { inventoryId: true, quantity: true },
      });

      const sortedInventoryIds = [...items].map((i) => i.inventoryId).sort();

      // 2. Lock inventory rows
      if (sortedInventoryIds.length > 0) {
        await tx.$queryRawUnsafe(
          `
          SELECT "id" FROM "Inventory"
          WHERE "id" IN (${sortedInventoryIds.map((_, i) => `$${i + 1}`).join(', ')})
          FOR UPDATE
        `,
          ...sortedInventoryIds,
        );
      }

      // 3. Release reserved quantity for each item
      for (const item of items) {
        await tx.inventory.update({
          where: { id: item.inventoryId },
          data: {
            reservedQuantity: {
              decrement: item.quantity,
            },
          },
        });

        const inventoryData = await tx.inventory.findUnique({
          where: { id: item.inventoryId },
          select: { stockQuantity: true },
        });

        // 4. Create stock movement (RESERVATION_RELEASED)
        await tx.inventoryStockMovement.create({
          data: {
            inventoryId: item.inventoryId,
            type: StockMovementType.RESERVATION_RELEASED,
            quantity: item.quantity,
            previousQuantity: inventoryData?.stockQuantity || 0,
            newQuantity: inventoryData?.stockQuantity || 0, // physical stock doesn't change
            reason: `Reservation released (${targetStatus}): ${reason || 'No reason'}`,
            actorId: actorId,
          },
        });
      }

      // 5. Update reservation status
      const updateData: any = {
        status: targetStatus,
      };

      const now = new Date();
      if (targetStatus === ReservationStatus.CANCELLED) {
        updateData.cancelledAt = now;
        updateData.cancellationReason = reason;
      } else if (targetStatus === ReservationStatus.REJECTED) {
        updateData.rejectedAt = now;
        updateData.rejectionReason = reason;
      }

      const updatedReservation = await tx.reservation.update({
        where: { id: reservationId },
        data: updateData,
        include: { items: true },
      });

      // 5.5 Outbox event
      await this.outboxService.createEvent(
        tx,
        `RESERVATION_${targetStatus}`,
        'Reservation',
        updatedReservation.id,
        {
          reservationId: updatedReservation.id,
          customerId: updatedReservation.customerId,
          storeId: updatedReservation.storeId,
          reservationCode: updatedReservation.reservationCode,
          reason,
        },
      );

      // 6. Audit log
      await this.auditService.log(
        {
          actorId,
          action: `RESERVATION_${targetStatus}`,
          entityType: 'Reservation',
          entityId: reservationId,
          previousData: { status: lockedReservation.status },
          newData: { status: targetStatus, reason },
        },
        tx,
      );

      return updatedReservation;
    });
  }

  /**
   * Completes a reservation.
   * Decreases physical stock AND reserved stock simultaneously.
   */
  async completeReservation(reservationId: string, actorId: string) {
    return this.prisma.$transaction(async (tx) => {
      // 1. Lock the reservation
      const reservations = await tx.$queryRawUnsafe<
        { id: string; status: ReservationStatus; reservationCode: string }[]
      >(
        `
        SELECT "id", "status", "reservationCode"
        FROM "Reservation"
        WHERE "id" = $1
        FOR UPDATE
      `,
        reservationId,
      );

      const lockedReservation = reservations[0];
      if (!lockedReservation) {
        throw new BadRequestException('Reservation not found');
      }

      if (lockedReservation.status !== ReservationStatus.READY) {
        throw new BadRequestException(
          `Reservation must be READY before completion`,
        );
      }

      const items = await tx.reservationItem.findMany({
        where: { reservationId },
        select: { inventoryId: true, quantity: true },
      });

      const sortedInventoryIds = [...items].map((i) => i.inventoryId).sort();

      // 2. Lock inventory rows
      if (sortedInventoryIds.length > 0) {
        await tx.$queryRawUnsafe(
          `
          SELECT "id", "stockQuantity" FROM "Inventory"
          WHERE "id" IN (${sortedInventoryIds.map((_, i) => `$${i + 1}`).join(', ')})
          FOR UPDATE
        `,
          ...sortedInventoryIds,
        );
      }

      // 3. Decrease stock & reserved quantity for each item
      for (const item of items) {
        const inventoryBefore = await tx.inventory.findUnique({
          where: { id: item.inventoryId },
          select: { stockQuantity: true },
        });

        if (!inventoryBefore) {
          throw new InternalServerErrorException(
            `Inventory ${item.inventoryId} missing during completion.`,
          );
        }

        if (inventoryBefore.stockQuantity < item.quantity) {
          throw new BadRequestException(
            `Physical stock anomaly for ${item.inventoryId} during completion.`,
          );
        }

        const newStockQuantity = inventoryBefore.stockQuantity - item.quantity;

        await tx.inventory.update({
          where: { id: item.inventoryId },
          data: {
            stockQuantity: newStockQuantity,
            reservedQuantity: {
              decrement: item.quantity,
            },
          },
        });

        // 4. Create stock movement (RESERVATION_COMPLETED)
        await tx.inventoryStockMovement.create({
          data: {
            inventoryId: item.inventoryId,
            type: StockMovementType.RESERVATION_COMPLETED,
            quantity: item.quantity,
            previousQuantity: inventoryBefore.stockQuantity,
            newQuantity: newStockQuantity, // physical stock decreased!
            reason: `Reservation completed (Code: ${lockedReservation.reservationCode})`,
            actorId: actorId,
          },
        });
      }

      // 5. Update reservation status
      const updatedReservation = await tx.reservation.update({
        where: { id: reservationId },
        data: {
          status: ReservationStatus.COMPLETED,
          completedAt: new Date(),
        },
        include: { items: true },
      });

      // 5.5 Outbox event
      await this.outboxService.createEvent(
        tx,
        'RESERVATION_COMPLETED',
        'Reservation',
        updatedReservation.id,
        {
          reservationId: updatedReservation.id,
          customerId: updatedReservation.customerId,
          storeId: updatedReservation.storeId,
          reservationCode: updatedReservation.reservationCode,
        },
      );

      // 6. Audit log
      await this.auditService.log(
        {
          actorId,
          action: 'RESERVATION_COMPLETED',
          entityType: 'Reservation',
          entityId: reservationId,
          previousData: { status: lockedReservation.status },
          newData: { status: ReservationStatus.COMPLETED },
        },
        tx,
      );

      return updatedReservation;
    });
  }

  /**
   * State transitions that do not affect inventory (e.g., PENDING -> CONFIRMED, CONFIRMED -> READY).
   */
  async updateReservationStatus(
    reservationId: string,
    targetStatus: ReservationStatus,
    actorId: string,
  ) {
    return this.prisma.$transaction(async (tx) => {
      const reservations = await tx.$queryRawUnsafe<
        { id: string; status: ReservationStatus }[]
      >(
        `
        SELECT "id", "status"
        FROM "Reservation"
        WHERE "id" = $1
        FOR UPDATE
      `,
        reservationId,
      );

      const lockedReservation = reservations[0];
      if (!lockedReservation) {
        throw new BadRequestException('Reservation not found');
      }

      const updateData: any = {
        status: targetStatus,
      };

      const now = new Date();
      if (targetStatus === ReservationStatus.CONFIRMED) {
        updateData.confirmedAt = now;
      } else if (targetStatus === ReservationStatus.READY) {
        updateData.readyAt = now;
      }

      const updated = await tx.reservation.update({
        where: { id: reservationId },
        data: updateData,
        include: { items: true },
      });

      // 5.5 Outbox event
      await this.outboxService.createEvent(
        tx,
        `RESERVATION_${targetStatus}`,
        'Reservation',
        updated.id,
        {
          reservationId: updated.id,
          customerId: updated.customerId,
          storeId: updated.storeId,
          reservationCode: updated.reservationCode,
        },
      );

      await this.auditService.log(
        {
          actorId,
          action: `RESERVATION_${targetStatus}`,
          entityType: 'Reservation',
          entityId: reservationId,
          previousData: { status: lockedReservation.status },
          newData: { status: targetStatus },
        },
        tx,
      );

      return updated;
    });
  }
}
