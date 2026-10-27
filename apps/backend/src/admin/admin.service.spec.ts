import { Test, TestingModule } from '@nestjs/testing';
import { AdminService } from './admin.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { UserRole, UserStatus } from '@prisma/client';
import { NotFoundException, ForbiddenException } from '@nestjs/common';

describe('AdminService', () => {
  let service: AdminService;
  let prisma: PrismaService;

  const mockPrisma = {
    reservation: {
      groupBy: jest.fn(),
      aggregate: jest.fn(),
    },
    coupon: {
      count: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    couponUsage: {
      count: jest.fn(),
      groupBy: jest.fn(),
      findMany: jest.fn(),
    },
    offer: {
      count: jest.fn(),
      findMany: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    shopRating: {
      aggregate: jest.fn(),
      count: jest.fn(),
      findMany: jest.fn(),
      update: jest.fn(),
      groupBy: jest.fn(),
    },
    store: {
      count: jest.fn(),
      findMany: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    user: {
      count: jest.fn(),
      findMany: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    business: {
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
    },
    product: {
      count: jest.fn(),
      findMany: jest.fn(),
      update: jest.fn(),
    },
    inventory: {
      findMany: jest.fn(),
      count: jest.fn(),
    },
    inventoryStockMovement: {
      findMany: jest.fn(),
      count: jest.fn(),
    },
    auditLog: {
      create: jest.fn(),
      findMany: jest.fn(),
      count: jest.fn(),
    },
    session: {
      findMany: jest.fn(),
    },
    contactRequest: {
      findMany: jest.fn(),
      count: jest.fn(),
      update: jest.fn(),
    },
    payment: {
      findMany: jest.fn(),
      count: jest.fn(),
      findUnique: jest.fn(),
    },
    $transaction: jest.fn((callback) => callback(mockPrisma)),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AdminService,
        {
          provide: PrismaService,
          useValue: mockPrisma,
        },
      ],
    }).compile();

    service = module.get<AdminService>(AdminService);
    prisma = module.get<PrismaService>(PrismaService);
    jest.clearAllMocks();
  });

  describe('getDashboardMetrics', () => {
    it('should aggregate genuine metrics accurately from database', async () => {
      mockPrisma.reservation.groupBy.mockResolvedValueOnce([
        { status: 'COMPLETED', _count: 15 },
        { status: 'PENDING', _count: 5 },
        { status: 'CANCELLED', _count: 2 },
      ]);

      mockPrisma.reservation.aggregate.mockResolvedValueOnce({
        _sum: {
          subtotal: 10000,
          totalDiscount: 1500,
          totalAmount: 8500,
        },
      });

      mockPrisma.coupon.count.mockResolvedValueOnce(3); // activeCoupons
      mockPrisma.couponUsage.count.mockResolvedValueOnce(45); // couponUsages
      mockPrisma.offer.count.mockResolvedValueOnce(8); // activeOffers
      mockPrisma.offer.count.mockResolvedValueOnce(2); // expiredOffers

      mockPrisma.shopRating.aggregate.mockResolvedValueOnce({
        _avg: { rating: 4.8 },
        _count: 50,
      });
      mockPrisma.shopRating.count.mockResolvedValueOnce(40); // fiveStar
      mockPrisma.shopRating.count.mockResolvedValueOnce(1); // oneStar

      // Stores count
      mockPrisma.store.count.mockResolvedValueOnce(10); // totalStores
      mockPrisma.store.count.mockResolvedValueOnce(8); // activeStores
      mockPrisma.store.count.mockResolvedValueOnce(2); // pendingStores

      // Shopkeepers count
      mockPrisma.user.count.mockResolvedValueOnce(6); // totalShopkeepers
      mockPrisma.user.count.mockResolvedValueOnce(5); // activeShopkeepers
      mockPrisma.user.count.mockResolvedValueOnce(1); // suspendedShopkeepers

      // Products count
      mockPrisma.product.count.mockResolvedValueOnce(120); // totalProducts
      mockPrisma.product.count.mockResolvedValueOnce(110); // activeProducts
      mockPrisma.product.count.mockResolvedValueOnce(10); // inactiveProducts

      const result = await service.getDashboardMetrics();

      expect(result.orders.total).toBe(22);
      expect(result.orders.completed).toBe(15);
      expect(result.orders.pending).toBe(5);
      expect(result.orders.cancelled).toBe(2);

      expect(result.revenue.gross).toBe(10000);
      expect(result.revenue.discounts).toBe(1500);
      expect(result.revenue.net).toBe(8500);

      expect(result.stores.total).toBe(10);
      expect(result.stores.active).toBe(8);
      expect(result.stores.pendingVerification).toBe(2);

      expect(result.shopkeepers.total).toBe(6);
      expect(result.shopkeepers.active).toBe(5);
      expect(result.shopkeepers.suspended).toBe(1);

      expect(result.products.total).toBe(120);
      expect(result.products.active).toBe(110);
      expect(result.products.inactive).toBe(10);

      expect(result.coupons.active).toBe(3);
      expect(result.offers.active).toBe(8);
      expect(result.ratings.average).toBe(4.8);
    });
  });

  describe('Store Management', () => {
    it('should update store status to VERIFIED and activate store & business with audit logging', async () => {
      mockPrisma.store.update.mockResolvedValueOnce({
        id: 'store-1',
        businessId: 'biz-1',
        status: 'ACTIVE',
        verificationStatus: 'VERIFIED',
      });
      mockPrisma.business.update.mockResolvedValueOnce({
        id: 'biz-1',
        verificationStatus: 'VERIFIED',
      });
      mockPrisma.auditLog.create.mockResolvedValueOnce({ id: 'log-1' });

      const result = await service.updateStoreStatus('store-1', 'VERIFIED', 'admin-1');

      expect(mockPrisma.store.update).toHaveBeenCalledWith({
        where: { id: 'store-1' },
        data: { verificationStatus: 'VERIFIED', status: 'ACTIVE' },
      });
      expect(mockPrisma.business.update).toHaveBeenCalledWith({
        where: { id: 'biz-1' },
        data: { verificationStatus: 'VERIFIED' },
      });
      expect(mockPrisma.auditLog.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          actorId: 'admin-1',
          action: 'UPDATE_STORE_STATUS_VERIFIED',
          entityType: 'Store',
          entityId: 'store-1',
        }),
      });
      expect(result.status).toBe('ACTIVE');
    });

    it('should update store status to SUSPENDED when suspended', async () => {
      mockPrisma.store.update.mockResolvedValueOnce({
        id: 'store-1',
        businessId: 'biz-1',
        status: 'SUSPENDED',
        verificationStatus: 'SUSPENDED',
      });
      mockPrisma.business.update.mockResolvedValueOnce({});
      mockPrisma.auditLog.create.mockResolvedValueOnce({});

      await service.updateStoreStatus('store-1', 'SUSPENDED', 'admin-1');

      expect(mockPrisma.store.update).toHaveBeenCalledWith({
        where: { id: 'store-1' },
        data: { verificationStatus: 'SUSPENDED', status: 'SUSPENDED' },
      });
    });
  });

  describe('Shopkeeper Access Control', () => {
    it('should suspend a shopkeeper and record audit log', async () => {
      mockPrisma.user.findUnique.mockResolvedValueOnce({
        id: 'user-1',
        role: UserRole.SHOP_OWNER,
      });
      mockPrisma.user.update.mockResolvedValueOnce({
        id: 'user-1',
        status: UserStatus.SUSPENDED,
      });
      mockPrisma.auditLog.create.mockResolvedValueOnce({});

      const result = await service.suspendUser('user-1', 'admin-1', 'Policy breach');

      expect(mockPrisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: { status: UserStatus.SUSPENDED },
      });
      expect(mockPrisma.auditLog.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          action: 'UPDATE_USER_STATUS_SUSPENDED',
          entityId: 'user-1',
        }),
      });
      expect(result.success).toBe(true);
    });

    it('should prevent modifying SUPER_ADMIN', async () => {
      mockPrisma.user.findUnique.mockResolvedValueOnce({
        id: 'admin-super',
        role: UserRole.SUPER_ADMIN,
      });

      await expect(
        service.updateUserStatus('admin-super', UserStatus.SUSPENDED, 'admin-1'),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should reinstate a suspended user', async () => {
      mockPrisma.user.findUnique.mockResolvedValueOnce({
        id: 'user-1',
        role: UserRole.SHOP_OWNER,
        status: UserStatus.SUSPENDED,
      });
      mockPrisma.user.update.mockResolvedValueOnce({
        id: 'user-1',
        status: UserStatus.ACTIVE,
      });
      mockPrisma.auditLog.create.mockResolvedValueOnce({});

      const result = await service.reinstateUser('user-1', 'admin-1');

      expect(mockPrisma.user.update).toHaveBeenCalledWith({
        where: { id: 'user-1' },
        data: { status: UserStatus.ACTIVE },
      });
      expect(result.success).toBe(true);
    });
  });

  describe('Product Governance', () => {
    it('should update product status and log audit entry', async () => {
      mockPrisma.product.update.mockResolvedValueOnce({
        id: 'prod-1',
        status: 'ACTIVE',
      });
      mockPrisma.auditLog.create.mockResolvedValueOnce({});

      const result = await service.updateProductStatus('prod-1', 'ACTIVE', 'admin-1');

      expect(mockPrisma.product.update).toHaveBeenCalledWith({
        where: { id: 'prod-1' },
        data: { status: 'ACTIVE' },
      });
      expect(mockPrisma.auditLog.create).toHaveBeenCalledWith({
        data: expect.objectContaining({
          actorId: 'admin-1',
          action: 'UPDATE_PRODUCT_STATUS_ACTIVE',
          entityType: 'Product',
          entityId: 'prod-1',
        }),
      });
      expect(result.status).toBe('ACTIVE');
    });
  });
});
