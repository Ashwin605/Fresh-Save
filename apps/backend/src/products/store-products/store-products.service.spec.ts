import { Test, TestingModule } from '@nestjs/testing';
import { StoreProductsService } from './store-products.service';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { ExpiryService } from '../../inventory/services/expiry.service';
import { StockService } from '../../inventory/services/stock.service';
import {
  ForbiddenException,
  BadRequestException,
  NotFoundException,
} from '@nestjs/common';
import { UserRole, InventoryStatus, CategoryStatus, ProductStatus } from '@prisma/client';

describe('StoreProductsService', () => {
  let service: StoreProductsService;
  let prisma: any;
  let audit: any;
  let expiryService: any;
  let stockService: any;

  const mockStore = {
    id: 'store-1',
    businessId: 'biz-1',
    name: 'Green Grocers',
    business: { ownerId: 'owner-1' },
  };

  const mockCategory = {
    id: 'cat-1',
    name: 'Dairy',
    slug: 'dairy',
    status: CategoryStatus.ACTIVE,
    deletedAt: null,
  };

  const mockProduct = {
    id: 'prod-1',
    name: 'Organic Whole Milk 1L',
    slug: 'organic-whole-milk-1l',
    categoryId: 'cat-1',
    brand: 'Organic Farm',
    sku: 'SKU-MILK-001',
    barcode: '1234567890123',
    image: '/public/uploads/products/milk.jpg',
    unit: '1 L',
    status: ProductStatus.ACTIVE,
    deletedAt: null,
    category: mockCategory,
  };

  const mockInventory = {
    id: 'inv-1',
    storeId: 'store-1',
    productId: 'prod-1',
    stockQuantity: 25,
    reservedQuantity: 2,
    sellingPrice: 4.5,
    originalPrice: 5.0,
    expiryDate: new Date('2026-12-01T00:00:00.000Z'),
    manufacturingDate: new Date('2026-10-01T00:00:00.000Z'),
    batchNumber: 'BATCH-001',
    status: InventoryStatus.ACTIVE,
    deletedAt: null,
    product: mockProduct,
    createdAt: new Date(),
    updatedAt: new Date(),
  };

  beforeEach(async () => {
    prisma = {
      store: {
        findFirst: jest.fn(),
      },
      storeStaff: {
        findUnique: jest.fn(),
      },
      product: {
        findUnique: jest.fn(),
        findFirst: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
      },
      category: {
        findUnique: jest.fn(),
      },
      inventory: {
        findFirst: jest.fn(),
        findMany: jest.fn(),
        count: jest.fn(),
        create: jest.fn(),
        update: jest.fn(),
      },
      inventoryStockMovement: {
        create: jest.fn(),
      },
      $transaction: jest.fn((callback) => callback(prisma)),
    };

    audit = {
      log: jest.fn().mockResolvedValue(undefined),
    };

    expiryService = {
      getExpiryStatus: jest.fn().mockReturnValue('FRESH'),
      getTimeUntilExpiry: jest.fn().mockReturnValue('38 days left'),
    };

    stockService = {
      adjustStock: jest.fn().mockResolvedValue({ updated: true }),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StoreProductsService,
        { provide: PrismaService, useValue: prisma },
        { provide: AuditService, useValue: audit },
        { provide: ExpiryService, useValue: expiryService },
        { provide: StockService, useValue: stockService },
      ],
    }).compile();

    service = module.get<StoreProductsService>(StoreProductsService);
  });

  describe('verifyStoreAccess', () => {
    it('should allow ADMIN or SUPER_ADMIN unconditionally', async () => {
      await expect(
        service.verifyStoreAccess('store-1', 'admin-id', UserRole.ADMIN),
      ).resolves.toBe(true);
      await expect(
        service.verifyStoreAccess('store-1', 'admin-id', UserRole.SUPER_ADMIN),
      ).resolves.toBe(true);
    });

    it('should allow SHOP_OWNER if store is owned', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      await expect(
        service.verifyStoreAccess('store-1', 'owner-1', UserRole.SHOP_OWNER),
      ).resolves.toBe(true);
    });

    it('should throw ForbiddenException if SHOP_OWNER does not own store', async () => {
      prisma.store.findFirst.mockResolvedValue(null);
      await expect(
        service.verifyStoreAccess('store-1', 'stranger-id', UserRole.SHOP_OWNER),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should throw ForbiddenException for unauthorized customer', async () => {
      await expect(
        service.verifyStoreAccess('store-1', 'customer-id', UserRole.CUSTOMER),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('findAll', () => {
    it('should return paginated store products with mapped attributes', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      prisma.inventory.findMany.mockResolvedValue([mockInventory]);
      prisma.inventory.count.mockResolvedValue(1);

      const result = await service.findAll(
        'store-1',
        'owner-1',
        UserRole.SHOP_OWNER,
        { page: 1, limit: 10 },
      );

      expect(result.data.items).toHaveLength(1);
      const item = result.data.items[0];
      expect(item.name).toBe('Organic Whole Milk 1L');
      expect(item.sellingPrice).toBe(4.5);
      expect(item.originalPrice).toBe(5.0);
      expect(item.stockQuantity).toBe(25);
      expect(item.availableQuantity).toBe(23); // 25 - 2 reserved
      expect(item.expiryStatus).toBe('FRESH');
    });
  });

  describe('create', () => {
    const validDto = {
      name: 'Organic Whole Milk 1L',
      categoryId: 'cat-1',
      brand: 'Organic Farm',
      sellingPrice: 4.5,
      originalPrice: 5.0,
      initialStockQuantity: 25,
      expiryDate: '2026-12-01T00:00:00.000Z',
      manufacturingDate: '2026-10-01T00:00:00.000Z',
    };

    it('should reject when sellingPrice > originalPrice', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      await expect(
        service.create('store-1', 'owner-1', UserRole.SHOP_OWNER, {
          ...validDto,
          sellingPrice: 10.0,
          originalPrice: 5.0,
        }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should reject when expiryDate <= manufacturingDate', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      await expect(
        service.create('store-1', 'owner-1', UserRole.SHOP_OWNER, {
          ...validDto,
          expiryDate: '2026-09-01T00:00:00.000Z',
          manufacturingDate: '2026-10-01T00:00:00.000Z',
        }),
      ).rejects.toThrow(BadRequestException);
    });

    it('should reject when category is inactive or missing', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      prisma.category.findUnique.mockResolvedValue(null);

      await expect(
        service.create('store-1', 'owner-1', UserRole.SHOP_OWNER, validDto),
      ).rejects.toThrow(BadRequestException);
    });

    it('should create new product and stock inventory successfully', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      prisma.category.findUnique.mockResolvedValue(mockCategory);
      prisma.product.findUnique.mockResolvedValue(null); // Slug generation
      prisma.product.findFirst.mockResolvedValue(null); // SKU uniqueness
      prisma.product.create.mockResolvedValue(mockProduct);
      prisma.inventory.findFirst.mockResolvedValue(null); // No previous inventory
      prisma.inventory.create.mockResolvedValue(mockInventory);

      const result = await service.create(
        'store-1',
        'owner-1',
        UserRole.SHOP_OWNER,
        validDto,
      );

      expect(prisma.product.create).toHaveBeenCalled();
      expect(prisma.inventory.create).toHaveBeenCalled();
      expect(prisma.inventoryStockMovement.create).toHaveBeenCalled();
      expect(result.name).toBe('Organic Whole Milk 1L');
      expect(result.sellingPrice).toBe(4.5);
    });
  });

  describe('update', () => {
    it('should update product metadata and pricing correctly', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      prisma.inventory.findFirst.mockResolvedValue(mockInventory);
      prisma.product.update.mockResolvedValue({
        ...mockProduct,
        name: 'Organic Whole Milk 1L Updated',
      });
      prisma.inventory.update.mockResolvedValue({
        ...mockInventory,
        sellingPrice: 4.25,
      });

      const result = await service.update(
        'store-1',
        'prod-1',
        'owner-1',
        UserRole.SHOP_OWNER,
        {
          name: 'Organic Whole Milk 1L Updated',
          sellingPrice: 4.25,
        },
      );

      expect(prisma.product.update).toHaveBeenCalled();
      expect(prisma.inventory.update).toHaveBeenCalled();
      expect(result.sellingPrice).toBe(4.25);
    });

    it('should prevent selling price from exceeding original price on update', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      prisma.inventory.findFirst.mockResolvedValue(mockInventory);

      await expect(
        service.update(
          'store-1',
          'prod-1',
          'owner-1',
          UserRole.SHOP_OWNER,
          { sellingPrice: 6.0 }, // originalPrice is 5.0
        ),
      ).rejects.toThrow(BadRequestException);
    });
  });

  describe('remove', () => {
    it('should soft-delete store product inventory', async () => {
      prisma.store.findFirst.mockResolvedValue(mockStore);
      prisma.inventory.findFirst.mockResolvedValue(mockInventory);
      prisma.inventory.update.mockResolvedValue({
        ...mockInventory,
        status: InventoryStatus.INACTIVE,
        deletedAt: new Date(),
      });

      const result = await service.remove(
        'store-1',
        'prod-1',
        'owner-1',
        UserRole.SHOP_OWNER,
      );

      expect(result.success).toBe(true);
      expect(prisma.inventory.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({
            status: InventoryStatus.INACTIVE,
          }),
        }),
      );
    });
  });
});
