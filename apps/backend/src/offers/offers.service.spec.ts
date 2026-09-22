/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { OffersService } from './offers.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { DiscountService } from './services/discount.service';
import { OfferValidationService } from './services/offer-validation.service';
import { UserRole, OfferStatus, DiscountType, Prisma } from '@prisma/client';
import { ForbiddenException, ConflictException } from '@nestjs/common';

describe('OffersService', () => {
  let service: OffersService;
  
  const mockPrisma = {
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
    store: { findFirst: jest.fn() },
    storeStaff: { findUnique: jest.fn() },
    inventory: { findUnique: jest.fn() },
    offer: {
      findMany: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
  };

  const mockAudit = { log: jest.fn() };
  const mockDiscount = { calculateDiscount: jest.fn().mockReturnValue({ discountedPrice: new Prisma.Decimal(90), discountAmount: new Prisma.Decimal(10) }) };
  const mockOfferValidation = {
    validateInventoryEligibility: jest.fn(),
    validateOfferDates: jest.fn(),
    getEffectiveOfferStatus: jest.fn(),
  };

  beforeEach(async () => {
    jest.clearAllMocks();
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        OffersService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AuditService, useValue: mockAudit },
        { provide: DiscountService, useValue: mockDiscount },
        { provide: OfferValidationService, useValue: mockOfferValidation },
      ],
    }).compile();

    service = module.get<OffersService>(OffersService);
  });

  describe('create', () => {
    it('should throw ConflictException if an active offer already exists', async () => {
      mockPrisma.inventory.findUnique.mockResolvedValueOnce({
        id: 'inv1', storeId: 's1', originalPrice: new Prisma.Decimal(100), sellingPrice: new Prisma.Decimal(100), expiryDate: new Date(), stockQuantity: 10,
        store: {}, product: {}
      });
      mockPrisma.store.findFirst.mockResolvedValueOnce({ id: 's1' }); // Auth success
      
      // Found an active offer
      mockPrisma.offer.findMany.mockResolvedValueOnce([{ id: 'off1', status: OfferStatus.ACTIVE }]);
      mockOfferValidation.getEffectiveOfferStatus.mockReturnValueOnce(OfferStatus.ACTIVE);

      await expect(service.create('inv1', 'user1', UserRole.SHOP_OWNER, {
        discountType: DiscountType.PERCENTAGE,
        discountValue: 10,
        startsAt: new Date().toISOString(),
        endsAt: new Date().toISOString(),
      })).rejects.toThrow(ConflictException);
    });
  });
});
