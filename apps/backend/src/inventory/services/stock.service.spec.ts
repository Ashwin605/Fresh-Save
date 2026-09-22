/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { StockService } from './stock.service';
import { PrismaService } from '../../database/prisma/prisma.service';
import { BadRequestException } from '@nestjs/common';
import { AdjustStockAction } from '../dto/adjust-stock.dto';
import { StockMovementType } from '@prisma/client';

describe('StockService', () => {
  let service: StockService;
  let prisma: PrismaService;

  const mockPrisma = {
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
    $queryRaw: jest.fn(),
    inventory: {
      update: jest.fn(),
    },
    inventoryStockMovement: {
      create: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StockService,
        { provide: PrismaService, useValue: mockPrisma },
      ],
    }).compile();

    service = module.get<StockService>(StockService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  describe('adjustStock', () => {
    it('should throw BadRequest if inventory not found', async () => {
      mockPrisma.$queryRaw.mockResolvedValueOnce([]); // No rows returned

      await expect(
        service.adjustStock('inv1', 'actor1', {
          action: AdjustStockAction.ADD,
          quantity: 10,
        }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should successfully ADD stock', async () => {
      mockPrisma.$queryRaw.mockResolvedValueOnce([{ stockQuantity: 20 }]);
      mockPrisma.inventory.update.mockResolvedValueOnce({});
      mockPrisma.inventoryStockMovement.create.mockResolvedValueOnce({});

      const res = await service.adjustStock('inv1', 'actor1', {
        action: AdjustStockAction.ADD,
        quantity: 10,
      });

      expect(res.previousQuantity).toBe(20);
      expect(res.newQuantity).toBe(30);
      expect(mockPrisma.inventory.update).toHaveBeenCalledWith({
        where: { id: 'inv1' },
        data: { stockQuantity: 30 },
      });
      expect(mockPrisma.inventoryStockMovement.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          type: StockMovementType.ADJUSTMENT,
          quantity: 10,
          previousQuantity: 20,
          newQuantity: 30,
        }),
      });
    });

    it('should successfully REMOVE stock', async () => {
      mockPrisma.$queryRaw.mockResolvedValueOnce([{ stockQuantity: 20 }]);
      mockPrisma.inventory.update.mockResolvedValueOnce({});
      mockPrisma.inventoryStockMovement.create.mockResolvedValueOnce({});

      const res = await service.adjustStock('inv1', 'actor1', {
        action: AdjustStockAction.REMOVE,
        quantity: 5,
      });

      expect(res.previousQuantity).toBe(20);
      expect(res.newQuantity).toBe(15);
    });

    it('should throw if REMOVE causes negative stock', async () => {
      mockPrisma.$queryRaw.mockResolvedValueOnce([{ stockQuantity: 20 }]);

      await expect(
        service.adjustStock('inv1', 'actor1', {
          action: AdjustStockAction.REMOVE,
          quantity: 25,
        }),
      ).rejects.toThrow(BadRequestException);
    });
  });
});
