/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { OfferValidationService, ExpiryAwareInventory } from './offer-validation.service';
import { BadRequestException } from '@nestjs/common';
import { OfferStatus, StoreStatus, ProductStatus, InventoryStatus, Offer } from '@prisma/client';
import { ExpiryService } from '../../inventory/services/expiry.service';
import { ExpiryStatus } from '../../inventory/constants/expiry.constants';

describe('OfferValidationService', () => {
  let service: OfferValidationService;
  let expiryService: ExpiryService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OfferValidationService,
        {
          provide: ExpiryService,
          useValue: {
            getExpiryStatus: jest.fn().mockReturnValue(ExpiryStatus.FRESH),
          },
        },
      ],
    }).compile();

    service = module.get<OfferValidationService>(OfferValidationService);
    expiryService = module.get<ExpiryService>(ExpiryService);
  });

  describe('validateOfferDates', () => {
    it('should throw if start time is after end time', () => {
      const start = new Date('2023-01-10T10:00:00Z');
      const end = new Date('2023-01-09T10:00:00Z');
      const expiry = new Date('2023-01-15T10:00:00Z');
      expect(() => service.validateOfferDates(start, end, expiry)).toThrow(BadRequestException);
    });

    it('should throw if end time is after inventory expiry', () => {
      const start = new Date('2023-01-10T10:00:00Z');
      const end = new Date('2023-01-16T10:00:00Z');
      const expiry = new Date('2023-01-15T10:00:00Z');
      expect(() => service.validateOfferDates(start, end, expiry)).toThrow(BadRequestException);
    });
  });

  describe('getEffectiveOfferStatus', () => {
    it('should return SOLD_OUT if inventory stock is 0', () => {
      const offer = { status: OfferStatus.ACTIVE } as Offer;
      const status = service.getEffectiveOfferStatus(offer, 0, new Date('2099-01-01'), new Date('2023-01-01'));
      expect(status).toBe(OfferStatus.SOLD_OUT);
    });

    it('should return EXPIRED if current time >= end time', () => {
      const offer = { status: OfferStatus.ACTIVE, endsAt: new Date('2023-01-01T10:00:00Z') } as any;
      const status = service.getEffectiveOfferStatus(offer, 10, new Date('2099-01-01'), new Date('2023-01-02T10:00:00Z'));
      expect(status).toBe(OfferStatus.EXPIRED);
    });

    it('should return EXPIRED if inventory is expired', () => {
      jest.spyOn(expiryService, 'getExpiryStatus').mockReturnValue(ExpiryStatus.EXPIRED);
      const offer = { status: OfferStatus.ACTIVE, endsAt: new Date('2099-01-01T10:00:00Z') } as any;
      const status = service.getEffectiveOfferStatus(offer, 10, new Date('2023-01-01'), new Date('2023-01-02T10:00:00Z'));
      expect(status).toBe(OfferStatus.EXPIRED);
    });

    it('should respect manual cancellation', () => {
      const offer = { status: OfferStatus.CANCELLED, endsAt: new Date('2099-01-01T10:00:00Z') } as any;
      const status = service.getEffectiveOfferStatus(offer, 10, new Date('2099-01-01'), new Date('2023-01-02T10:00:00Z'));
      expect(status).toBe(OfferStatus.CANCELLED);
    });
  });
});
