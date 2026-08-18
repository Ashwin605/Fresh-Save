/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { CategoriesService } from './categories.service';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { BadRequestException } from '@nestjs/common';
import { CategoryStatus } from '@prisma/client';

describe('CategoriesService', () => {
  let service: CategoriesService;
  let prisma: PrismaService;
  let audit: AuditService;

  const mockPrisma = {
    category: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
    },
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
  };

  const mockAudit = {
    log: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CategoriesService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AuditService, useValue: mockAudit },
      ],
    }).compile();

    service = module.get<CategoriesService>(CategoriesService);
    prisma = module.get<PrismaService>(PrismaService);
    audit = module.get<AuditService>(AuditService);
    jest.clearAllMocks();
    
    // Clear out any old mock queue implementations
    mockPrisma.category.findUnique.mockReset();
    mockPrisma.category.create.mockReset();
    mockPrisma.category.update.mockReset();
    mockPrisma.category.findMany.mockReset();
  });

  describe('create', () => {
    it('should generate a unique slug and create category', async () => {
      mockPrisma.category.findUnique.mockResolvedValueOnce(null); // Slug check
      mockPrisma.category.create.mockResolvedValueOnce({ id: 'cat1', slug: 'dairy' });
      
      const result = await service.create('admin1', { name: 'Dairy' });
      
      expect(result.id).toBe('cat1');
      expect(mockPrisma.category.create).toHaveBeenCalledWith(
        expect.objectContaining({ data: expect.objectContaining({ slug: 'dairy' }) })
      );
    });
  });

  describe('update (circular dependency)', () => {
    it('should reject a category being its own parent', async () => {
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'c1', status: CategoryStatus.ACTIVE }); // find category itself
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'c1', status: CategoryStatus.ACTIVE }); // find parent to validate status
      await expect(service.update('c1', 'admin1', { parentId: 'c1' })).rejects.toThrow(BadRequestException);
    });

    it('should reject circular dependency', async () => {
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'c1', name: 'Cat 1', status: CategoryStatus.ACTIVE }); // find category itself
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'c2', name: 'Cat 2', status: CategoryStatus.ACTIVE }); // find parent
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'c2', parentId: 'c1' }); // check parent of c2
      mockPrisma.category.findUnique.mockResolvedValueOnce({ id: 'c1', parentId: null }); // check parent of c1

      await expect(service.update('c1', 'admin1', { parentId: 'c2' })).rejects.toThrow(BadRequestException);
    });
  });
});
