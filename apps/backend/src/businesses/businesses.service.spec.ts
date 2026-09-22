/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { BusinessesService } from './businesses.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { UserRole } from '@prisma/client';
import { ForbiddenException, ConflictException } from '@nestjs/common';

describe('BusinessesService', () => {
  let service: BusinessesService;
  let prisma: PrismaService;
  let audit: AuditService;

  const mockPrisma = {
    business: {
      findFirst: jest.fn(),
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
      count: jest.fn(),
    },
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
  };

  const mockAudit = {
    log: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        BusinessesService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AuditService, useValue: mockAudit },
      ],
    }).compile();

    service = module.get<BusinessesService>(BusinessesService);
    prisma = module.get<PrismaService>(PrismaService);
    audit = module.get<AuditService>(AuditService);
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should throw ConflictException if owner already has a business', async () => {
      mockPrisma.business.findFirst.mockResolvedValueOnce({ id: 'b1' });
      await expect(
        service.create('owner1', { businessName: 'Test' }),
      ).rejects.toThrow(ConflictException);
    });

    it('should create a business and log it', async () => {
      mockPrisma.business.findFirst.mockResolvedValueOnce(null);
      mockPrisma.business.create.mockResolvedValueOnce({
        id: 'b1',
        ownerId: 'owner1',
      });

      const result = await service.create('owner1', { businessName: 'Test' });

      expect(result.id).toBe('b1');
      expect(mockAudit.log).toHaveBeenCalledWith(
        expect.objectContaining({
          action: 'BUSINESS_CREATED',
          actorId: 'owner1',
        }),
        expect.any(Object),
      );
    });
  });

  describe('findOne', () => {
    it('should allow SHOP_OWNER to view their own business', async () => {
      mockPrisma.business.findUnique.mockResolvedValueOnce({
        id: 'b1',
        ownerId: 'owner1',
      });
      const result = await service.findOne('b1', 'owner1', UserRole.SHOP_OWNER);
      expect(result.id).toBe('b1');
    });

    it('should throw ForbiddenException for SHOP_OWNER accessing another business', async () => {
      mockPrisma.business.findUnique.mockResolvedValueOnce({
        id: 'b1',
        ownerId: 'owner2',
      });
      await expect(
        service.findOne('b1', 'owner1', UserRole.SHOP_OWNER),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should allow ADMIN to view any business', async () => {
      mockPrisma.business.findUnique.mockResolvedValueOnce({
        id: 'b1',
        ownerId: 'owner2',
      });
      const result = await service.findOne('b1', 'admin1', UserRole.ADMIN);
      expect(result.id).toBe('b1');
    });
  });
});
