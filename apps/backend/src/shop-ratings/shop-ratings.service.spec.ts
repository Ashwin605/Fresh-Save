import { Test, TestingModule } from '@nestjs/testing';
import { ShopRatingsService } from './shop-ratings.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { BadRequestException, NotFoundException, ConflictException } from '@nestjs/common';
import { ReservationStatus } from '@prisma/client';

describe('ShopRatingsService', () => {
  let service: ShopRatingsService;
  let prisma: PrismaService;

  const mockPrisma = {
    reservation: {
      findUnique: jest.fn(),
    },
    shopRating: {
      findUnique: jest.fn(),
      create: jest.fn(),
      count: jest.fn(),
      findMany: jest.fn(),
      aggregate: jest.fn(),
      groupBy: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ShopRatingsService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<ShopRatingsService>(ShopRatingsService);
    prisma = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('createRating', () => {
    it('should throw NotFoundException if order does not exist', async () => {
      mockPrisma.reservation.findUnique.mockResolvedValue(null);
      await expect(
        service.createRating('shop-1', 'cust-1', { orderId: 'order-1', rating: 5 })
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw BadRequestException if order belongs to another customer', async () => {
      mockPrisma.reservation.findUnique.mockResolvedValue({ customerId: 'cust-2', storeId: 'shop-1', status: ReservationStatus.COMPLETED });
      await expect(
        service.createRating('shop-1', 'cust-1', { orderId: 'order-1', rating: 5 })
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException if order is not completed', async () => {
      mockPrisma.reservation.findUnique.mockResolvedValue({ customerId: 'cust-1', storeId: 'shop-1', status: ReservationStatus.PENDING });
      await expect(
        service.createRating('shop-1', 'cust-1', { orderId: 'order-1', rating: 5 })
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw BadRequestException if order does not belong to the shop', async () => {
      mockPrisma.reservation.findUnique.mockResolvedValue({ customerId: 'cust-1', storeId: 'shop-2', status: ReservationStatus.COMPLETED });
      await expect(
        service.createRating('shop-1', 'cust-1', { orderId: 'order-1', rating: 5 })
      ).rejects.toThrow(BadRequestException);
    });

    it('should throw ConflictException if already rated', async () => {
      mockPrisma.reservation.findUnique.mockResolvedValue({ customerId: 'cust-1', storeId: 'shop-1', status: ReservationStatus.COMPLETED });
      mockPrisma.shopRating.findUnique.mockResolvedValue({ id: 'rating-1' });
      await expect(
        service.createRating('shop-1', 'cust-1', { orderId: 'order-1', rating: 5 })
      ).rejects.toThrow(ConflictException);
    });

    it('should create rating if all validations pass', async () => {
      mockPrisma.reservation.findUnique.mockResolvedValue({ customerId: 'cust-1', storeId: 'shop-1', status: ReservationStatus.COMPLETED });
      mockPrisma.shopRating.findUnique.mockResolvedValue(null);
      mockPrisma.shopRating.create.mockResolvedValue({ id: 'rating-1', rating: 5, review: 'Great' });

      const result = await service.createRating('shop-1', 'cust-1', { orderId: 'order-1', rating: 5, review: 'Great' });
      expect(result.success).toBe(true);
      expect(mockPrisma.shopRating.create).toHaveBeenCalled();
    });
  });

  describe('getRatingSummary', () => {
    it('should return correct summary', async () => {
      mockPrisma.shopRating.aggregate.mockResolvedValue({ _count: { rating: 10 }, _avg: { rating: 4.5 } });
      mockPrisma.shopRating.groupBy.mockResolvedValue([
        { rating: 5, _count: { rating: 5 } },
        { rating: 4, _count: { rating: 5 } },
      ]);

      const result = await service.getRatingSummary('shop-1');
      expect(result.success).toBe(true);
      expect(result.data.averageRating).toBe(4.5);
      expect(result.data.totalRatings).toBe(10);
      expect(result.data.distribution['5']).toBe(5);
    });
  });
});
