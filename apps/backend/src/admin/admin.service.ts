import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { UserRole, UserStatus } from '@prisma/client';
import * as crypto from 'crypto';
import * as argon2 from 'argon2';

@Injectable()
export class AdminService {
  constructor(private prisma: PrismaService) {}

  async getDashboardMetrics() {
    // 1. Orders
    const reservations = await this.prisma.reservation.groupBy({
      by: ['status'],
      _count: true,
    });
    
    let totalOrders = 0;
    let completedOrders = 0;
    let cancelledOrders = 0;
    let pendingOrders = 0;
    
    reservations.forEach(r => {
      totalOrders += r._count;
      if (r.status === 'COMPLETED') completedOrders += r._count;
      if (r.status === 'CANCELLED') cancelledOrders += r._count;
      if (r.status === 'PENDING') pendingOrders += r._count;
    });

    // 2. Revenue
    const revenueAgg = await this.prisma.reservation.aggregate({
      where: { status: 'COMPLETED' },
      _sum: {
        subtotal: true,
        totalDiscount: true,
        totalAmount: true,
      }
    });

    // 3. Coupons
    const activeCoupons = await this.prisma.coupon.count({ where: { isActive: true } });
    const couponUsages = await this.prisma.couponUsage.count();

    // 4. Offers
    const activeOffers = await this.prisma.offer.count({ where: { status: 'ACTIVE' } });
    const expiredOffers = await this.prisma.offer.count({ where: { status: 'EXPIRED' } });

    // 5. Ratings
    const ratingAgg = await this.prisma.shopRating.aggregate({
      where: { status: 'VISIBLE' },
      _avg: { rating: true },
      _count: true,
    });

    const fiveStar = await this.prisma.shopRating.count({ where: { status: 'VISIBLE', rating: 5 } });
    const oneStar = await this.prisma.shopRating.count({ where: { status: 'VISIBLE', rating: 1 } });

    return {
      orders: {
        total: totalOrders,
        completed: completedOrders,
        cancelled: cancelledOrders,
        pending: pendingOrders,
      },
      revenue: {
        gross: Number(revenueAgg._sum.subtotal || 0),
        discounts: Number(revenueAgg._sum.totalDiscount || 0),
        net: Number(revenueAgg._sum.totalAmount || 0),
      },
      coupons: {
        active: activeCoupons,
        usage: couponUsages,
      },
      offers: {
        active: activeOffers,
        expired: expiredOffers,
      },
      ratings: {
        average: Number((ratingAgg._avg.rating || 0).toFixed(1)),
        total: ratingAgg._count || 0,
        fiveStar,
        oneStar,
      }
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

    await this.prisma.user.update({
      where: { id: userId },
      data: { status: UserStatus.SUSPENDED },
    });

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
    return this.prisma.$transaction(async (tx) => {
      let tempPassword = null;

      // 1. Find user by email, or create them if they don't exist
      let owner = await tx.user.findUnique({
        where: { email: ownerEmail },
      });
      
      if (!owner) {
        tempPassword = crypto.randomBytes(6).toString('hex');
        const hashedPassword = await argon2.hash(tempPassword);
        const defaultName = ownerEmail.split('@')[0];
        owner = await tx.user.create({
          data: {
            email: ownerEmail,
            name: defaultName,
            password: hashedPassword,
            role: UserRole.SHOP_OWNER,
          },
        });
      }

      // Elevate to SHOP_OWNER if needed
      if (owner.role === UserRole.CUSTOMER) {
        await tx.user.update({
          where: { id: owner.id },
          data: { role: UserRole.SHOP_OWNER },
        });
      }

      // 2. Find or create Business
      let business = await tx.business.findFirst({
        where: { ownerId: owner.id },
      });

      if (!business) {
        business = await tx.business.create({
          data: {
            businessName: `${owner.name}'s Business`,
            ownerId: owner.id,
            verificationStatus: verifyInstantly ? 'VERIFIED' : 'PENDING',
          },
        });
      } else if (verifyInstantly && business.verificationStatus !== 'VERIFIED') {
        await tx.business.update({
          where: { id: business.id },
          data: { verificationStatus: 'VERIFIED' },
        });
      }

      // 3. Create Store
      const store = await tx.store.create({
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
      await tx.auditLog.create({
        data: {
          actorId: adminId,
          action: 'ADMIN_CREATE_STORE',
          entityType: 'Store',
          entityId: store.id,
        },
      });

      return {
        ...store,
        temporaryPassword: tempPassword,
      };
    });
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

  async getProducts(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.product.findMany({ skip, take: limit, orderBy: { createdAt: 'desc' }, include: { category: true } }),
      this.prisma.product.count(),
    ]);
    return { data, total, page, limit };
  }

  async updateProductStatus(productId: string, status: any, adminId: string) {
    const product = await this.prisma.product.update({
      where: { id: productId },
      data: { status },
    });
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: `UPDATE_PRODUCT_STATUS_${status}`, entityType: 'Product', entityId: productId },
    });
    return product;
  }

  async getInventory(page = 1, limit = 20, storeId?: string, search?: string) {
    const skip = (page - 1) * limit;
    const where: any = {};
    if (storeId) where.storeId = storeId;
    if (search) where.store = { name: { contains: search, mode: 'insensitive' } };

    const [data, total] = await Promise.all([
      this.prisma.inventory.findMany({
        where, skip, take: limit,
        include: { product: true, store: true },
        orderBy: { updatedAt: 'desc' },
      }),
      this.prisma.inventory.count({ where }),
    ]);
    return { data, total, page, limit };
  }

  async getInventoryMovements(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.inventoryStockMovement.findMany({
        skip, take: limit,
        include: { inventory: { include: { product: true, store: true } } },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.inventoryStockMovement.count(),
    ]);
    return { data, total, page, limit };
  }

  async getReservations(page = 1, limit = 20, status?: any) {
    const skip = (page - 1) * limit;
    const where = status ? { status } : {};
    const [data, total] = await Promise.all([
      this.prisma.reservation.findMany({
        where, skip, take: limit,
        include: { customer: { select: { name: true, email: true } }, store: { select: { name: true } } },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.reservation.count({ where }),
    ]);
    return { data, total, page, limit };
  }

  async getDailyLoginStats() {
    const sessions = await this.prisma.session.findMany({
      select: { createdAt: true },
      orderBy: { createdAt: 'desc' },
    });
    const stats: Record<string, number> = {};
    for (const session of sessions) {
      const date = session.createdAt.toISOString().split('T')[0];
      stats[date] = (stats[date] || 0) + 1;
    }
    return Object.entries(stats).map(([date, count]) => ({ date, count }));
  }

  async getShopkeepers(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.user.findMany({
        where: { role: UserRole.SHOP_OWNER },
        skip, take: limit,
        include: { businesses: { include: { stores: true } } },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.user.count({ where: { role: UserRole.SHOP_OWNER } }),
    ]);
    return { data, total, page, limit };
  }

  async getOffers(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.offer.findMany({ skip, take: limit, include: { inventory: { include: { store: true } } }, orderBy: { createdAt: 'desc' } }),
      this.prisma.offer.count(),
    ]);
    return { data, total, page, limit };
  }

  async getCoupons(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.coupon.findMany({ skip, take: limit, orderBy: { createdAt: 'desc' } }),
      this.prisma.coupon.count(),
    ]);
    return { data, total, page, limit };
  }

  async getContactRequests(page = 1, limit = 20) {
    const skip = (page - 1) * limit;
    const [data, total] = await Promise.all([
      this.prisma.contactRequest.findMany({ skip, take: limit, orderBy: { createdAt: 'desc' } }),
      this.prisma.contactRequest.count(),
    ]);
    return { data, total, page, limit };
  }

  async updateContactRequestStatus(id: string, status: any, adminId: string) {
    const request = await this.prisma.contactRequest.update({ where: { id }, data: { status } });
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: `UPDATE_CONTACT_STATUS_${status}`, entityType: 'ContactRequest', entityId: id },
    });
    return request;
  }

  // --- ANALYTICS ---

  private getDateFilter(startDate?: string, endDate?: string) {
    if (!startDate && !endDate) return {};
    const dateFilter: any = {};
    if (startDate) dateFilter.gte = new Date(startDate);
    if (endDate) dateFilter.lte = new Date(endDate);
    return dateFilter;
  }

  async getRevenueAnalytics(startDate?: string, endDate?: string) {
    const dateFilter = this.getDateFilter(startDate, endDate);
    const agg = await this.prisma.reservation.aggregate({
      where: { status: 'COMPLETED', createdAt: Object.keys(dateFilter).length > 0 ? dateFilter : undefined },
      _sum: {
        subtotal: true,
        totalDiscount: true,
        totalAmount: true,
      }
    });

    return {
      grossSales: Number(agg._sum.subtotal || 0),
      discounts: Number(agg._sum.totalDiscount || 0),
      netRevenue: Number(agg._sum.totalAmount || 0),
    };
  }

  async getOrderAnalytics(startDate?: string, endDate?: string) {
    const dateFilter = this.getDateFilter(startDate, endDate);
    const where = Object.keys(dateFilter).length > 0 ? { createdAt: dateFilter } : {};

    const reservations = await this.prisma.reservation.groupBy({
      by: ['status'],
      where,
      _count: true,
    });
    
    let total = 0, completed = 0, pending = 0, cancelled = 0;
    reservations.forEach(r => {
      total += r._count;
      if (r.status === 'COMPLETED') completed += r._count;
      if (r.status === 'PENDING') pending += r._count;
      if (r.status === 'CANCELLED') cancelled += r._count;
    });

    return { total, completed, pending, cancelled };
  }

  async getDiscountAnalytics(startDate?: string, endDate?: string) {
    const dateFilter = this.getDateFilter(startDate, endDate);
    const where = { status: 'COMPLETED' as any, ...(Object.keys(dateFilter).length > 0 ? { createdAt: dateFilter } : {}) };

    const agg = await this.prisma.reservation.aggregate({
      where,
      _sum: { totalDiscount: true },
      _count: true,
    });
    
    const discountedOrders = await this.prisma.reservation.count({
      where: { ...where, totalDiscount: { gt: 0 } }
    });

    // To get Coupon vs Offer splits reliably, we look at the items vs coupon usage.
    // For simplicity, total offer discount can be approximated by reservation items discount Amount.
    const itemsAgg = await this.prisma.reservationItem.aggregate({
      where: { reservation: where },
      _sum: { discountAmount: true }
    });
    
    const offerDiscounts = Number(itemsAgg._sum.discountAmount || 0);
    const totalDiscounts = Number(agg._sum.totalDiscount || 0);
    const couponDiscounts = Math.max(0, totalDiscounts - offerDiscounts);
    const avgDiscount = discountedOrders > 0 ? totalDiscounts / discountedOrders : 0;

    return {
      totalDiscounts,
      couponDiscounts,
      offerDiscounts,
      discountedOrders,
      totalOrders: agg._count,
      avgDiscount,
    };
  }

  async getCouponAnalytics(startDate?: string, endDate?: string) {
    const dateFilter = this.getDateFilter(startDate, endDate);
    
    // Most used coupons
    const usages = await this.prisma.couponUsage.groupBy({
      by: ['couponId'],
      _count: true,
      orderBy: { _count: { couponId: 'desc' } },
      take: 10,
      where: Object.keys(dateFilter).length > 0 ? { usedAt: dateFilter } : undefined
    });

    const couponIds = usages.map(u => u.couponId);
    const coupons = await this.prisma.coupon.findMany({
      where: { id: { in: couponIds } },
      select: { id: true, code: true, isActive: true, usageLimit: true }
    });

    const topCoupons = usages.map(u => {
      const c = coupons.find(c => c.id === u.couponId);
      return {
        id: u.couponId,
        code: c?.code || 'Unknown',
        usage: u._count,
        usageLimit: c?.usageLimit,
        status: c?.isActive ? 'Active' : 'Inactive'
      };
    });

    return { topCoupons };
  }

  async getRatingAnalytics(shopId?: string) {
    const where = { status: 'VISIBLE' as any, ...(shopId ? { shopId } : {}) };
    
    const agg = await this.prisma.shopRating.aggregate({
      where,
      _avg: { rating: true },
      _count: true,
    });
    
    const distribution = await this.prisma.shopRating.groupBy({
      by: ['rating'],
      where,
      _count: true,
    });
    
    const distMap = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
    distribution.forEach(d => { distMap[d.rating as keyof typeof distMap] = d._count; });

    return {
      average: Number((agg._avg.rating || 0).toFixed(1)),
      total: agg._count,
      distribution: distMap,
    };
  }

  async getReviews(page = 1, limit = 20, rating?: number, shopId?: string) {
    const skip = (page - 1) * limit;
    const where: any = {};
    if (rating) where.rating = rating;
    if (shopId) where.shopId = shopId;
    
    const [data, total] = await Promise.all([
      this.prisma.shopRating.findMany({
        where, skip, take: limit,
        include: { customer: { select: { name: true, email: true } }, shop: { select: { name: true } } },
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.shopRating.count({ where }),
    ]);
    return { data, total, page, limit };
  }

  async moderateReview(reviewId: string, status: any, adminId: string) {
    const review = await this.prisma.shopRating.update({
      where: { id: reviewId },
      data: { status },
    });
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: `MODERATE_REVIEW_${status}`, entityType: 'ShopRating', entityId: reviewId },
    });
    return review;
  }

  // --- COUPONS ---

  async getCouponDetails(id: string) {
    const coupon = await this.prisma.coupon.findUnique({
      where: { id },
      include: { shop: { select: { name: true } } }
    });
    if (!coupon) throw new NotFoundException('Coupon not found');
    
    const usages = await this.prisma.couponUsage.findMany({
      where: { couponId: id },
      include: { customer: { select: { name: true, email: true } }, order: { select: { reservationCode: true, totalDiscount: true } } },
      orderBy: { usedAt: 'desc' },
      take: 50,
    });
    
    return { coupon, usages };
  }

  async createCoupon(data: any, adminId: string) {
    const coupon = await this.prisma.coupon.create({
      data: {
        code: data.code,
        title: data.title,
        description: data.description,
        discountType: data.discountType,
        discountValue: data.discountValue,
        minimumOrderAmount: data.minimumOrderAmount,
        maximumDiscountAmount: data.maximumDiscountAmount,
        startDate: new Date(data.startDate),
        expiryDate: new Date(data.expiryDate),
        usageLimit: data.usageLimit,
        perUserLimit: data.perUserLimit,
        shopId: data.shopId,
        isActive: data.isActive ?? true,
      }
    });
    
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: 'CREATE_COUPON', entityType: 'Coupon', entityId: coupon.id },
    });
    return coupon;
  }

  async updateCoupon(id: string, data: any, adminId: string) {
    const coupon = await this.prisma.coupon.update({
      where: { id },
      data: {
        title: data.title,
        description: data.description,
        isActive: data.isActive,
        // For safety, do not update code/discount if it has been used.
        // Frontend should prevent these changes if usage > 0.
        // Even if updated here, historical orders use 'Reservation' snapshot, so they won't break.
      }
    });
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: 'UPDATE_COUPON', entityType: 'Coupon', entityId: id, newData: data },
    });
    return coupon;
  }

  // --- OFFERS ---

  async createOffer(data: any, adminId: string) {
    const offer = await this.prisma.offer.create({
      data: {
        inventoryId: data.inventoryId,
        title: data.title,
        description: data.description,
        discountType: data.discountType,
        discountValue: data.discountValue,
        originalPriceSnapshot: data.originalPriceSnapshot,
        discountAmount: data.discountAmount,
        discountedPrice: data.discountedPrice,
        startsAt: new Date(data.startsAt),
        endsAt: new Date(data.endsAt),
        status: data.status,
        createdById: adminId,
      }
    });
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: 'CREATE_OFFER', entityType: 'Offer', entityId: offer.id },
    });
    return offer;
  }

  async updateOffer(id: string, data: any, adminId: string) {
    const offer = await this.prisma.offer.update({
      where: { id },
      data: {
        status: data.status,
        title: data.title,
        description: data.description,
      }
    });
    await this.prisma.auditLog.create({
      data: { actorId: adminId, action: `UPDATE_OFFER_${data.status}`, entityType: 'Offer', entityId: id, newData: data },
    });
    return offer;
  }
}
