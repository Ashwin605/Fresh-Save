import { Test, TestingModule } from '@nestjs/testing';
import { CouponsService } from './coupons.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { BadRequestException } from '@nestjs/common';
import { ReservationStatus, DiscountType } from '@prisma/client';

describe('CouponsService', () => {
  let service: CouponsService;
  let prisma: PrismaService;

  const mockPrisma = {
    coupon: {
      findUnique: jest.fn(),
      create: jest.fn(),
      findMany: jest.fn(),
    },
    reservation: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    couponUsage: {
      count: jest.fn(),
    }
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CouponsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<CouponsService>(CouponsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should reject duplicate code', async () => {
      mockPrisma.coupon.findUnique.mockResolvedValue({});
      await expect(service.create({ code: 'SAVE50', discountType: DiscountType.FIXED_AMOUNT, discountValue: 50, startDate: '2025-01-01', expiryDate: '2025-12-31', title: 'Save' })).rejects.toThrow(BadRequestException);
    });
  });

  describe('validateCoupon', () => {
    it('should normalize code and validate', async () => {
      mockPrisma.coupon.findUnique.mockResolvedValue({
        id: '1', code: 'SAVE50', isActive: true, startDate: new Date('2020-01-01'), expiryDate: new Date('2030-01-01'), discountType: DiscountType.FIXED_AMOUNT, discountValue: 50
      });
      mockPrisma.reservation.findUnique.mockResolvedValue({
        id: 'cart-1', customerId: 'cust-1', status: ReservationStatus.PENDING, subtotal: 100, storeId: 'shop-1'
      });

      const res = await service.validateCoupon(' sAvE50 ', 'cart-1', 'cust-1');
      expect(mockPrisma.coupon.findUnique).toHaveBeenCalledWith({ where: { code: 'SAVE50' } });
      expect(res.valid).toBe(true);
    });

    it('should reject expired coupon', async () => {
      mockPrisma.coupon.findUnique.mockResolvedValue({
        id: '1', code: 'SAVE50', isActive: true, startDate: new Date('2020-01-01'), expiryDate: new Date('2021-01-01')
      });
      const res = await service.validateCoupon('SAVE50', 'cart-1', 'cust-1');
      expect(res.valid).toBe(false);
      expect(res.message).toBe('This coupon has expired.');
    });

    it('should enforce minimum order amount', async () => {
      mockPrisma.coupon.findUnique.mockResolvedValue({
        id: '1', code: 'SAVE50', isActive: true, startDate: new Date('2020-01-01'), expiryDate: new Date('2030-01-01'), minimumOrderAmount: 200
      });
      mockPrisma.reservation.findUnique.mockResolvedValue({
        id: 'cart-1', customerId: 'cust-1', status: ReservationStatus.PENDING, subtotal: 100, storeId: 'shop-1'
      });
      const res = await service.validateCoupon('SAVE50', 'cart-1', 'cust-1');
      expect(res.valid).toBe(false);
      expect(res.message).toContain('Add ₹100.00 more to use this coupon.');
    });
  });
});
