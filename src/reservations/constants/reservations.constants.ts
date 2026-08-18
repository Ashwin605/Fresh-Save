// ============================================
// FreshSave — Reservation Constants
// ============================================

import { ReservationStatus } from '@prisma/client';

export const RESERVATION_CONSTANTS = {
  // Default time in minutes before a pending reservation expires automatically
  DEFAULT_HOLD_MINUTES: 30,

  // Prefix for auto-generated reservation codes
  CODE_PREFIX: 'FS-',

  // Length of the random alphanumeric part of the reservation code
  CODE_LENGTH: 6,
};

/**
 * Valid state transitions for the Reservation Lifecycle.
 * A map where the key is the current status, and the value is an array of allowed next statuses.
 */
export const ALLOWED_STATUS_TRANSITIONS: Record<
  ReservationStatus,
  ReservationStatus[]
> = {
  [ReservationStatus.PENDING]: [
    ReservationStatus.CONFIRMED,
    ReservationStatus.REJECTED,
    ReservationStatus.CANCELLED,
    ReservationStatus.EXPIRED,
  ],
  [ReservationStatus.CONFIRMED]: [
    ReservationStatus.READY,
    ReservationStatus.CANCELLED,
  ],
  [ReservationStatus.READY]: [ReservationStatus.COMPLETED],
  // Terminal states have no outbound transitions
  [ReservationStatus.COMPLETED]: [],
  [ReservationStatus.CANCELLED]: [],
  [ReservationStatus.EXPIRED]: [],
  [ReservationStatus.REJECTED]: [],
};
