/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { ProductsService } from './products.service';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { ConflictException, BadRequestException } from '@nestjs/common';
import { CategoryStatus, ProductStatus } from '@prisma/client';

describe('ProductsService', () => {
  let service: ProductsService;
  let prisma: PrismaService;
  let audit: AuditService;

  const mockPrisma = {
    product: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
      count: jest.fn(),
    },
    category: {
      findUnique: jest.fn(),
    },
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
  };

  const mockAudit = {
    log: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        ProductsService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AuditService, useValue: mockAudit },
      ],
    }).compile();

    service = module.get<ProductsService>(ProductsService);
    prisma = module.get<PrismaService>(PrismaService);
    audit = module.get<AuditService>(AuditService);
    jest.clearAllMocks();
    
    mockPrisma.product.findUnique.mockReset();
    mockPrisma.product.findFirst.mockReset();
    mockPrisma.product.create.mockReset();
    mockPrisma.product.update.mockReset();
    mockPrisma.product.findMany.mockReset();
    mockPrisma.product.count.mockReset();
    mockPrisma.category.findUnique.mockReset();
  });

  describe('create', () => {
    it('should throw ConflictException if SKU already exists', async () => {
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'cat1', status: CategoryStatus.ACTIVE });
      mockPrisma.product.findFirst.mockResolvedValueOnce({ id: 'p1', sku: 'SKU1' });
      await expect(service.create('admin1', { name: 'Test', categoryId: 'cat1', sku: 'SKU1' })).rejects.toThrow(ConflictException);
    });

    it('should throw BadRequestException if category is inactive', async () => {
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'cat1', status: CategoryStatus.INACTIVE });
      await expect(service.create('admin1', { name: 'Test', categoryId: 'cat1' })).rejects.toThrow(BadRequestException);
    });

    it('should create product and log it', async () => {
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'cat1', status: CategoryStatus.ACTIVE });
      mockPrisma.product.findFirst.mockResolvedValueOnce(null); // sku check
      mockPrisma.product.findFirst.mockResolvedValueOnce(null); // barcode check
      mockPrisma.product.findUnique.mockResolvedValueOnce(null); // slug check
      mockPrisma.product.create.mockResolvedValueOnce({ id: 'p1', name: 'Test', slug: 'test' });
      
      const result = await service.create('admin1', { name: 'Test', categoryId: 'cat1', sku: 'sku2', barcode: 'bar2' });
      expect(result.id).toBe('p1');
    });
  });

  describe('findAll', () => {
    it('should paginate and search products', async () => {
      mockPrisma.product.findMany.mockResolvedValueOnce([{ id: 'p1' }]);
      mockPrisma.product.count.mockResolvedValueOnce(1);

      const result = await service.findAll({ search: 'milk', page: 2, limit: 10 });
      expect(result.data.pagination.page).toBe(2);
      expect(mockPrisma.product.findMany).toHaveBeenCalledWith(
        expect.objectContaining({
          skip: 10,
          take: 10,
          where: expect.objectContaining({
            OR: expect.arrayContaining([
              { name: { contains: 'milk', mode: 'insensitive' } }
            ])
          })
        })
      );
    });
  });

  describe('remove', () => {
    it('should soft delete (archive) the product', async () => {
      mockPrisma.product.findUnique.mockResolvedValueOnce({ id: 'p1', status: ProductStatus.ACTIVE });
      mockPrisma.product.update.mockResolvedValueOnce({ id: 'p1', status: ProductStatus.INACTIVE });

      const result = await service.remove('p1', 'admin1');
      expect(result.success).toBe(true);
      expect(mockPrisma.product.update).toHaveBeenCalledWith(
        expect.objectContaining({
          data: expect.objectContaining({ status: ProductStatus.INACTIVE })
        })
      );
    });
  });
});
