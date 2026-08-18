/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { CreateStoreDto } from './dto/create-store.dto';
import { UpdateStoreDto } from './dto/update-store.dto';
import { AddStoreStaffDto } from './dto/add-store-staff.dto';
import { UserRole, StoreStatus, VerificationStatus } from '@prisma/client';

@Injectable()
export class StoresService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async create(businessId: string, ownerId: string, dto: CreateStoreDto) {
    const business = await this.prisma.business.findUnique({
      where: { id: businessId },
    });

    if (!business) {
      throw new NotFoundException('Business not found');
    }
    if (business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this business');
    }

    return this.prisma.$transaction(async (tx) => {
      const store = await tx.store.create({
        data: {
          businessId,
          name: dto.name,
          description: dto.description,
          logo: dto.logo,
          coverImage: dto.coverImage,
          phone: dto.phone,
          email: dto.email,
          address: dto.address,
          latitude: dto.latitude,
          longitude: dto.longitude,
          openingHours: dto.openingHours as any,
        },
      });

      // Handle PostGIS Location if lat/lng are provided
      if (dto.latitude !== undefined && dto.longitude !== undefined) {
        await tx.$executeRaw`
          UPDATE "Store"
          SET location = ST_SetSRID(ST_MakePoint(${dto.longitude}, ${dto.latitude}), 4326)::geography
          WHERE id = ${store.id};
        `;
      }

      await this.audit.log(
        {
          actorId: ownerId,
          action: 'STORE_CREATED',
          entityType: 'Store',
          entityId: store.id,
          newData: store,
        },
        tx,
      );

      return store;
    });
  }

  async findBusinessStores(businessId: string, ownerId: string) {
    const business = await this.prisma.business.findUnique({
      where: { id: businessId },
    });

    if (!business) {
      throw new NotFoundException('Business not found');
    }
    if (business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this business');
    }

    return this.prisma.store.findMany({
      where: { businessId },
    });
  }

  async findOne(id: string, actorId: string, actorRole: UserRole) {
    const store = await this.prisma.store.findUnique({
      where: { id },
      include: { business: true },
    });

    if (!store) {
      throw new NotFoundException('Store not found');
    }

    if (actorRole === UserRole.SHOP_OWNER) {
      if (store.business.ownerId !== actorId) {
        throw new ForbiddenException('You do not own this store');
      }
    } else if (actorRole === UserRole.SHOP_STAFF) {
      const staffRecord = await this.prisma.storeStaff.findUnique({
        where: { storeId_userId: { storeId: store.id, userId: actorId } },
      });
      if (!staffRecord) {
        throw new ForbiddenException('You are not assigned to this store');
      }
    }

    // Strip business relation if you don't want to return it, or leave it.
    return store;
  }

  async update(id: string, ownerId: string, dto: UpdateStoreDto) {
    const store = await this.prisma.store.findUnique({
      where: { id },
      include: { business: true },
    });

    if (!store) {
      throw new NotFoundException('Store not found');
    }
    if (store.business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this store');
    }

    return this.prisma.$transaction(async (tx) => {
      const updatedStore = await tx.store.update({
        where: { id },
        data: {
          name: dto.name,
          description: dto.description,
          logo: dto.logo,
          coverImage: dto.coverImage,
          phone: dto.phone,
          email: dto.email,
          address: dto.address,
          latitude: dto.latitude,
          longitude: dto.longitude,
          openingHours: dto.openingHours as any,
        },
      });

      if (dto.latitude !== undefined && dto.longitude !== undefined) {
        await tx.$executeRaw`
          UPDATE "Store"
          SET location = ST_SetSRID(ST_MakePoint(${dto.longitude}, ${dto.latitude}), 4326)::geography
          WHERE id = ${updatedStore.id};
        `;
      }

      await this.audit.log(
        {
          actorId: ownerId,
          action: 'STORE_UPDATED',
          entityType: 'Store',
          entityId: store.id,
          previousData: store,
          newData: updatedStore,
        },
        tx,
      );

      return updatedStore;
    });
  }

  // --- STAFF MANAGEMENT ---

  async addStaff(storeId: string, ownerId: string, dto: AddStoreStaffDto) {
    const store = await this.prisma.store.findUnique({
      where: { id: storeId },
      include: { business: true },
    });

    if (!store) {
      throw new NotFoundException('Store not found');
    }
    if (store.business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this store');
    }

    const user = await this.prisma.user.findUnique({
      where: { email: dto.email.toLowerCase().trim() },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (
      user.role === UserRole.ADMIN ||
      user.role === UserRole.SUPER_ADMIN ||
      user.role === UserRole.SHOP_OWNER
    ) {
      throw new ConflictException(
        'User is an admin or shop owner and cannot be added as staff',
      );
    }

    const existingStaff = await this.prisma.storeStaff.findUnique({
      where: { storeId_userId: { storeId, userId: user.id } },
    });

    if (existingStaff) {
      throw new ConflictException('User is already staff at this store');
    }

    return this.prisma.$transaction(async (tx) => {
      const staff = await tx.storeStaff.create({
        data: {
          storeId,
          userId: user.id,
        },
      });

      // Update global role to SHOP_STAFF if they were just a CUSTOMER
      if (user.role === UserRole.CUSTOMER) {
        await tx.user.update({
          where: { id: user.id },
          data: { role: UserRole.SHOP_STAFF },
        });
      }

      await this.audit.log(
        {
          actorId: ownerId,
          action: 'STAFF_ADDED',
          entityType: 'Store',
          entityId: store.id,
          newData: { staffId: staff.id, userId: user.id },
        },
        tx,
      );

      return staff;
    });
  }

  async findStaff(storeId: string, ownerId: string) {
    const store = await this.prisma.store.findUnique({
      where: { id: storeId },
      include: { business: true },
    });

    if (!store) throw new NotFoundException('Store not found');
    if (store.business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this store');
    }

    return this.prisma.storeStaff.findMany({
      where: { storeId },
      include: {
        user: {
          select: { id: true, name: true, email: true, phone: true },
        },
      },
    });
  }

  async removeStaff(storeId: string, staffId: string, ownerId: string) {
    const store = await this.prisma.store.findUnique({
      where: { id: storeId },
      include: { business: true },
    });

    if (!store) throw new NotFoundException('Store not found');
    if (store.business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this store');
    }

    const staff = await this.prisma.storeStaff.findUnique({
      where: { id: staffId },
    });

    if (!staff || staff.storeId !== storeId) {
      throw new NotFoundException('Staff record not found');
    }

    return this.prisma.$transaction(async (tx) => {
      await tx.storeStaff.delete({ where: { id: staffId } });

      await this.audit.log(
        {
          actorId: ownerId,
          action: 'STAFF_REMOVED',
          entityType: 'Store',
          entityId: store.id,
          previousData: { staffId: staff.id, userId: staff.userId },
        },
        tx,
      );

      return { success: true };
    });
  }

  // --- ADMIN ENDPOINTS ---

  async setVerificationStatus(
    id: string,
    adminId: string,
    status: VerificationStatus,
  ) {
    const store = await this.prisma.store.findUnique({ where: { id } });
    if (!store) throw new NotFoundException('Store not found');

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.store.update({
        where: { id },
        data: { verificationStatus: status },
      });

      await this.audit.log(
        {
          actorId: adminId,
          action: `STORE_${status}`,
          entityType: 'Store',
          entityId: id,
          previousData: { verificationStatus: store.verificationStatus },
          newData: { verificationStatus: status },
        },
        tx,
      );

      return updated;
    });
  }

  async setStatus(id: string, adminId: string, status: StoreStatus) {
    const store = await this.prisma.store.findUnique({ where: { id } });
    if (!store) throw new NotFoundException('Store not found');

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.store.update({
        where: { id },
        data: { status },
      });

      await this.audit.log(
        {
          actorId: adminId,
          action: `STORE_${status}`,
          entityType: 'Store',
          entityId: id,
          previousData: { status: store.status },
          newData: { status },
        },
        tx,
      );

      return updated;
    });
  }
}
