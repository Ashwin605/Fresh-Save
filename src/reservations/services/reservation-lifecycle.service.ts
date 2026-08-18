// ============================================
// FreshSave — Reservation Lifecycle Service
// ============================================

import { Injectable, BadRequestException } from '@nestjs/common';
import { ReservationStatus } from '@prisma/client';
import { ALLOWED_STATUS_TRANSITIONS } from '../constants/reservations.constants';

/**
 * Enforces valid state transitions for reservations.
 * Prevents arbitrary state changes (e.g. CANCELLED -> CONFIRMED).
 */
@Injectable()
export class ReservationLifecycleService {
  /**
   * Validates if a transition from currentStatus to targetStatus is allowed.
   * Throws BadRequestException if the transition is invalid.
   *
   * @param currentStatus The current status of the reservation
   * @param targetStatus The desired new status
   */
  validateTransition(
    currentStatus: ReservationStatus,
    targetStatus: ReservationStatus,
  ): void {
    if (currentStatus === targetStatus) {
      throw new BadRequestException(
        `Reservation is already in ${currentStatus} state.`,
      );
    }

    const allowedNextStates = ALLOWED_STATUS_TRANSITIONS[currentStatus];

    if (!allowedNextStates || !allowedNextStates.includes(targetStatus)) {
      throw new BadRequestException(
        `Invalid state transition from ${currentStatus} to ${targetStatus}. Allowed next states: ${allowedNextStates?.join(', ') || 'none'}.`,
      );
    }
  }

  /**
   * Checks if the reservation can be safely modified.
   * Terminal states (COMPLETED, CANCELLED, EXPIRED, REJECTED) cannot be modified.
   */
  isModifiable(status: ReservationStatus): boolean {
    const terminalStates: ReservationStatus[] = [
      ReservationStatus.COMPLETED,
      ReservationStatus.CANCELLED,
      ReservationStatus.EXPIRED,
      ReservationStatus.REJECTED,
    ];

    return !terminalStates.includes(status);
  }
}
