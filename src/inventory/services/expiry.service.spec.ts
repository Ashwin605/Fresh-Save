/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { ExpiryService } from './expiry.service';
import {
  ExpiryStatus,
  EXPIRY_THRESHOLDS_DAYS,
} from '../constants/expiry.constants';

describe('ExpiryService', () => {
  let service: ExpiryService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [ExpiryService],
    }).compile();

    service = module.get<ExpiryService>(ExpiryService);
  });

  describe('getExpiryStatus', () => {
    it('should return EXPIRED for past dates', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-09T10:00:00Z');
      expect(service.getExpiryStatus(expiry, now)).toBe(ExpiryStatus.EXPIRED);
    });

    it('should return CRITICAL for <= 1 day', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-11T09:00:00Z'); // 23 hours
      expect(service.getExpiryStatus(expiry, now)).toBe(ExpiryStatus.CRITICAL);
    });

    it('should return URGENT for <= 3 days', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-12T10:00:00Z'); // 2 days
      expect(service.getExpiryStatus(expiry, now)).toBe(ExpiryStatus.URGENT);
    });

    it('should return EXPIRING_SOON for <= 7 days', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-16T10:00:00Z'); // 6 days
      expect(service.getExpiryStatus(expiry, now)).toBe(
        ExpiryStatus.EXPIRING_SOON,
      );
    });

    it('should return FRESH for > 7 days', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-20T10:00:00Z'); // 10 days
      expect(service.getExpiryStatus(expiry, now)).toBe(ExpiryStatus.FRESH);
    });
  });

  describe('getTimeUntilExpiry', () => {
    it('should calculate days and hours correctly', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-12T15:30:00Z'); // 2 days, 5.5 hours

      const result = service.getTimeUntilExpiry(expiry, now);
      expect(result).toEqual({ days: 2, hours: 5, isExpired: false });
    });

    it('should return 0 for expired items', () => {
      const now = new Date('2023-01-10T10:00:00Z');
      const expiry = new Date('2023-01-05T15:30:00Z');

      const result = service.getTimeUntilExpiry(expiry, now);
      expect(result).toEqual({ days: 0, hours: 0, isExpired: true });
    });
  });
});
