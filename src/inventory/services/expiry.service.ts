import { Injectable } from '@nestjs/common';
import {
  EXPIRY_THRESHOLDS_DAYS,
  ExpiryStatus,
} from '../constants/expiry.constants';

@Injectable()
export class ExpiryService {
  /**
   * Determine the expiry status of an inventory batch based on its expiry date.
   */
  getExpiryStatus(
    expiryDate: Date,
    referenceDate: Date = new Date(),
  ): ExpiryStatus {
    const diffTime = expiryDate.getTime() - referenceDate.getTime();

    // If the date is past the reference date
    if (diffTime <= 0) {
      return ExpiryStatus.EXPIRED;
    }

    const diffDays = diffTime / (1000 * 60 * 60 * 24);

    if (diffDays <= EXPIRY_THRESHOLDS_DAYS.CRITICAL) {
      return ExpiryStatus.CRITICAL;
    }

    if (diffDays <= EXPIRY_THRESHOLDS_DAYS.URGENT) {
      return ExpiryStatus.URGENT;
    }

    if (diffDays <= EXPIRY_THRESHOLDS_DAYS.EXPIRING_SOON) {
      return ExpiryStatus.EXPIRING_SOON;
    }

    return ExpiryStatus.FRESH;
  }

  /**
   * Return a human-readable object of time remaining.
   */
  getTimeUntilExpiry(expiryDate: Date, referenceDate: Date = new Date()) {
    const diffTime = expiryDate.getTime() - referenceDate.getTime();

    if (diffTime <= 0) {
      return { days: 0, hours: 0, isExpired: true };
    }

    const days = Math.floor(diffTime / (1000 * 60 * 60 * 24));
    const hours = Math.floor(
      (diffTime % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60),
    );

    return { days, hours, isExpired: false };
  }
}
