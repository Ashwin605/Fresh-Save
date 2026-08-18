/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { InventoryService } from './inventory.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { ExpiryService } from './services/expiry.service';
import { StockService } from './services/stock.service';
import { UserRole, ProductStatus } from '@prisma/client';
import { ForbiddenException, BadRequestException } from '@nestjs/common';

describe('InventoryService', () => {
  let service: InventoryService;
  let prisma: PrismaService;
  let audit: AuditService;

  const mockPrisma = {
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
    store: { findFirst: jest.fn() },
    storeStaff: { findUnique: jest.fn() },
    product: { findUnique: jest.fn() },
    inventory: {
      create: jest.fn(),
      findUnique: jest.fn(),
      update: jest.fn(),
    },
  };

  const mockAudit = { log: jest.fn() };
  const mockExpiry = {
    getExpiryStatus: jest.fn(),
    getTimeUntilExpiry: jest.fn(),
  };
  const mockStock = {
    adjustStock: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        InventoryService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AuditService, useValue: mockAudit },
        { provide: ExpiryService, useValue: mockExpiry },
        { provide: StockService, useValue: mockStock },
      ],
    }).compile();

    service = module.get<InventoryService>(InventoryService);
    jest.resetAllMocks();
  });

  describe('verifyStoreAccess', () => {
    it('should allow ADMIN', async () => {
      await expect(service.verifyStoreAccess('s1', 'u1', UserRole.ADMIN)).resolves.toBe(true);
    });

    it('should reject SHOP_OWNER if they dont own the store', async () => {
      mockPrisma.store.findFirst.mockResolvedValueOnce(null);
      await expect(service.verifyStoreAccess('s1', 'u1', UserRole.SHOP_OWNER)).rejects.toThrow(ForbiddenException);
    });
  });

  describe('create', () => {
    it('should reject if product is inactive', async () => {
      // Mock verifyStoreAccess
      mockPrisma.store.findFirst.mockResolvedValueOnce({ id: 's1' });
      mockPrisma.product.findUnique.mockResolvedValueOnce({ id: 'p1', status: ProductStatus.INACTIVE });

      await expect(
        service.create('s1', 'actor', UserRole.SHOP_OWNER, {
          productId: 'p1',
          stockQuantity: 10,
          originalPrice: 100,
          sellingPrice: 80,
          expiryDate: '2026-01-01T00:00:00Z',
        })
      ).rejects.toThrow(BadRequestException);
    });
  });
});
