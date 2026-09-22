// ============================================
// FreshSave — Reservation Expiration Service
// ============================================

import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { ReservationTransactionService } from './reservation-transaction.service';
import { ReservationStatus } from '@prisma/client';

/**
 * Service to process expired reservations idempotently.
 * Can be called by a CRON job or manually triggered.
 */
@Injectable()
export class ReservationExpirationService {
  private readonly logger = new Logger(ReservationExpirationService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly transactionService: ReservationTransactionService,
  ) {}

  /**
   * Finds all PENDING reservations where expiresAt <= NOW(),
   * and processes them safely.
   */
  async processExpiredReservations(): Promise<{
    processedCount: number;
    errors: number;
  }> {
    this.logger.log('Starting expiration sweep...');
    const now = new Date();

    // 1. Find eligible reservations
    const expiredReservations = await this.prisma.reservation.findMany({
      where: {
        status: ReservationStatus.PENDING,
        expiresAt: {
          lte: now,
        },
      },
      select: {
        id: true,
        customerId: true, // We use the customer as the actor for system expiration for audit purposes
      },
    });

    let processedCount = 0;
    let errors = 0;

    for (const res of expiredReservations) {
      try {
        // transactionService handles locking and will only process if it's still PENDING
        // This makes the operation idempotent and safe against race conditions.
        await this.transactionService.releaseReservation(
          res.id,
          ReservationStatus.EXPIRED,
          res.customerId, // actor is the customer implicitly
          'Reservation expired automatically',
        );
        processedCount++;
        this.logger.log(`Successfully expired reservation: ${res.id}`);
      } catch (err: any) {
        // If it was already completed/cancelled by another thread, the transaction service
        // will throw a BadRequestException, which we catch here and ignore as it's safe.
        if (err.status === 400 && err.message.includes('already')) {
          this.logger.debug(
            `Reservation ${res.id} changed state during sweep, skipping.`,
          );
        } else {
          this.logger.error(
            `Failed to expire reservation ${res.id}: ${err.message}`,
            err.stack,
          );
          errors++;
        }
      }
    }

    this.logger.log(
      `Expiration sweep completed. Processed: ${processedCount}, Errors: ${errors}`,
    );
    return { processedCount, errors };
  }
}
