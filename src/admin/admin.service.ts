import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { UserRole } from '@prisma/client';

@Injectable()
export class AdminService {
  constructor(private prisma: PrismaService) {}

  async getDashboardMetrics() {
    const totalUsers = await this.prisma.user.count();
    const activeCustomers = await this.prisma.user.count({
      where: { role: UserRole.CUSTOMER },
    });
    const registeredStores = await this.prisma.store.count();
    const activeOffers = await this.prisma.offer.count({
      where: { status: 'ACTIVE' },
    });
    const totalReservations = await this.prisma.reservation.count();

    return {
      totalUsers,
      activeCustomers,
      registeredStores,
      activeOffers,
      totalReservations,
    };
  }

  async getUsers(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        skip,
        take: limit,
        select: {
          id: true,
          email: true,
          name: true,
          role: true,
          phone: true,
          createdAt: true,
        },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.user.count(),
    ]);

    return { data: users, total, page, limit };
  }

  async suspendUser(userId: string, adminId: string, reason: string) {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) throw new NotFoundException('User not found');
    if (user.role === UserRole.SUPER_ADMIN)
      throw new ForbiddenException('Cannot suspend SUPER_ADMIN');

    // In a real system, you might have an 'isActive' or 'status' field on User.
    // For now we just log to AuditLog.

    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: 'SUSPEND_USER',
        entityType: 'User',
        entityId: userId,
      },
    });

    return { success: true, message: 'User suspended' };
  }

  async getStores(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [stores, total] = await Promise.all([
      this.prisma.store.findMany({
        skip,
        take: limit,
        include: {
          business: { include: { owner: { select: { id: true, name: true, email: true } } } },
        },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.store.count(),
    ]);

    return { data: stores, total, page, limit };
  }

  async updateStoreStatus(storeId: string, status: string, adminId: string) {
    const store = await this.prisma.store.update({
      where: { id: storeId },
      data: { status: status as any },
    });

    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: `UPDATE_STORE_STATUS_${status}`,
        entityType: 'Store',
        entityId: storeId,
      },
    });

    return store;
  }

  async createStore(
    adminId: string,
    ownerEmail: string,
    storeData: any,
    verifyInstantly: boolean,
  ) {
    // 1. Find user by email, or create them if they don't exist
    let owner = await this.prisma.user.findUnique({
      where: { email: ownerEmail },
    });
    
    if (!owner) {
      const defaultName = ownerEmail.split('@')[0];
      owner = await this.prisma.user.create({
        data: {
          email: ownerEmail,
          name: defaultName,
          role: UserRole.SHOP_OWNER,
        },
      });
    }

    // Elevate to SHOP_OWNER if needed
    if (owner.role === UserRole.CUSTOMER) {
      await this.prisma.user.update({
        where: { id: owner.id },
        data: { role: UserRole.SHOP_OWNER },
      });
    }

    // 2. Find or create Business
    let business = await this.prisma.business.findFirst({
      where: { ownerId: owner.id },
    });

    if (!business) {
      business = await this.prisma.business.create({
        data: {
          businessName: `${owner.name}'s Business`,
          ownerId: owner.id,
          verificationStatus: verifyInstantly ? 'VERIFIED' : 'PENDING',
        },
      });
    } else if (verifyInstantly && business.verificationStatus !== 'VERIFIED') {
      await this.prisma.business.update({
        where: { id: business.id },
        data: { verificationStatus: 'VERIFIED' },
      });
    }

    // 3. Create Store
    const store = await this.prisma.store.create({
      data: {
        businessId: business.id,
        name: storeData.name,
        address: storeData.address,
        phone: storeData.phone,
        email: storeData.email,
        description: storeData.description,
        verificationStatus: verifyInstantly ? 'VERIFIED' : 'PENDING',
      },
    });

    // 4. Log audit action
    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: 'ADMIN_CREATE_STORE',
        entityType: 'Store',
        entityId: store.id,
      },
    });

    return store;
  }

  async updateStore(adminId: string, storeId: string, storeData: any) {
    const store = await this.prisma.store.update({
      where: { id: storeId },
      data: {
        name: storeData.name,
        address: storeData.address,
        phone: storeData.phone,
        email: storeData.email,
      },
    });

    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: 'ADMIN_UPDATE_STORE',
        entityType: 'Store',
        entityId: storeId,
      },
    });

    return store;
  }

  async deleteStore(adminId: string, storeId: string) {
    const store = await this.prisma.store.update({
      where: { id: storeId },
      data: {
        deletedAt: new Date(),
        status: 'SUSPENDED',
      },
    });

    await this.prisma.auditLog.create({
      data: {
        actorId: adminId,
        action: 'ADMIN_DELETE_STORE',
        entityType: 'Store',
        entityId: storeId,
      },
    });

    return store;
  }

  async getAuditLogs(page = 1, limit = 50) {
    const skip = (page - 1) * limit;
    const [logs, total] = await Promise.all([
      this.prisma.auditLog.findMany({
        skip,
        take: limit,
        orderBy: { id: 'desc' },
      }),
      this.prisma.auditLog.count(),
    ]);

    return { data: logs, total, page, limit };
  }
}
