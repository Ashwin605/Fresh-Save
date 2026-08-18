/* eslint-disable */
import { Test, TestingModule } from '@nestjs/testing';
import { StoresService } from './stores.service';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { UserRole } from '@prisma/client';
import { ForbiddenException, ConflictException } from '@nestjs/common';

describe('StoresService', () => {
  let service: StoresService;
  let prisma: PrismaService;
  let audit: AuditService;

  const mockPrisma = {
    business: {
      findUnique: jest.fn(),
    },
    store: {
      findUnique: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      findMany: jest.fn(),
    },
    user: {
      findUnique: jest.fn(),
      update: jest.fn(),
    },
    storeStaff: {
      findUnique: jest.fn(),
      create: jest.fn(),
      delete: jest.fn(),
    },
    $transaction: jest.fn(async (cb) => cb(mockPrisma)),
    $executeRaw: jest.fn(),
  };

  const mockAudit = {
    log: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        StoresService,
        { provide: PrismaService, useValue: mockPrisma },
        { provide: AuditService, useValue: mockAudit },
      ],
    }).compile();

    service = module.get<StoresService>(StoresService);
    prisma = module.get<PrismaService>(PrismaService);
    audit = module.get<AuditService>(AuditService);
    jest.clearAllMocks();
  });

  describe('create', () => {
    it('should throw ForbiddenException if user does not own business', async () => {
      mockPrisma.business.findUnique.mockResolvedValueOnce({
        id: 'b1',
        ownerId: 'other',
      });
      await expect(
        service.create('b1', 'owner1', { name: 'Test' }),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should create a store and log it', async () => {
      mockPrisma.business.findUnique.mockResolvedValueOnce({
        id: 'b1',
        ownerId: 'owner1',
      });
      mockPrisma.store.create.mockResolvedValueOnce({
        id: 's1',
        businessId: 'b1',
      });

      const result = await service.create('b1', 'owner1', {
        name: 'Test',
        latitude: 12,
        longitude: 12,
      });

      expect(result.id).toBe('s1');
      expect(mockPrisma.$executeRaw).toHaveBeenCalled();
      expect(mockAudit.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'STORE_CREATED', actorId: 'owner1' }),
        expect.any(Object),
      );
    });
  });

  describe('findOne', () => {
    it('should allow SHOP_OWNER to view their own store', async () => {
      mockPrisma.store.findUnique.mockResolvedValueOnce({
        id: 's1',
        business: { ownerId: 'owner1' },
      });
      const result = await service.findOne('s1', 'owner1', UserRole.SHOP_OWNER);
      expect(result.id).toBe('s1');
    });

    it('should throw ForbiddenException for SHOP_OWNER accessing another store', async () => {
      mockPrisma.store.findUnique.mockResolvedValueOnce({
        id: 's1',
        business: { ownerId: 'owner2' },
      });
      await expect(
        service.findOne('s1', 'owner1', UserRole.SHOP_OWNER),
      ).rejects.toThrow(ForbiddenException);
    });

    it('should allow SHOP_STAFF to view assigned store', async () => {
      mockPrisma.store.findUnique.mockResolvedValueOnce({
        id: 's1',
        business: { ownerId: 'owner2' },
      });
      mockPrisma.storeStaff.findUnique.mockResolvedValueOnce({ id: 'staff1' });
      const result = await service.findOne(
        's1',
        'staffUser1',
        UserRole.SHOP_STAFF,
      );
      expect(result.id).toBe('s1');
    });
  });

  describe('addStaff', () => {
    it('should throw ConflictException if adding an admin', async () => {
      mockPrisma.store.findUnique.mockResolvedValueOnce({
        id: 's1',
        business: { ownerId: 'owner1' },
      });
      mockPrisma.user.findUnique.mockResolvedValueOnce({
        id: 'u1',
        role: UserRole.ADMIN,
      });
      await expect(
        service.addStaff('s1', 'owner1', { email: 'test@example.com' }),
      ).rejects.toThrow(ConflictException);
    });
  });
});
