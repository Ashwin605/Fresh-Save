import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { ExpiryService } from './services/expiry.service';
import { StockService } from './services/stock.service';
import { CreateInventoryDto } from './dto/create-inventory.dto';
import { UpdateInventoryDto } from './dto/update-inventory.dto';
import { AdjustStockDto, AdjustStockAction } from './dto/adjust-stock.dto';
import { InventoryQueryDto } from './dto/inventory-query.dto';
import { createPaginatedResponse } from '../common/dto/pagination.dto';
import {
  EXPIRY_THRESHOLDS_DAYS,
  ExpiryStatus,
} from './constants/expiry.constants';
import {
  UserRole,
  ProductStatus,
  InventoryStatus,
  Prisma,
} from '@prisma/client';

@Injectable()
export class InventoryService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly expiryService: ExpiryService,
    private readonly stockService: StockService,
  ) {}

  /**
   * Verifies that the user has management access to the given store.
   */
  async verifyStoreAccess(storeId: string, userId: string, role: UserRole) {
    if (role === UserRole.ADMIN || role === UserRole.SUPER_ADMIN) {
      return true;
    }

    if (role === UserRole.SHOP_OWNER) {
      const store = await this.prisma.store.findFirst({
        where: { id: storeId, business: { ownerId: userId } },
      });
      if (!store) throw new ForbiddenException('You do not own this store');
      return true;
    }

    if (role === UserRole.SHOP_STAFF) {
      const staff = await this.prisma.storeStaff.findUnique({
        where: { storeId_userId: { storeId, userId } },
      });
      if (!staff)
        throw new ForbiddenException('You are not assigned to this store');
      return true;
    }

    throw new ForbiddenException('Unauthorized to access store inventory');
  }

  async create(
    storeId: string,
    actorId: string,
    role: UserRole,
    dto: CreateInventoryDto,
  ) {
    await this.verifyStoreAccess(storeId, actorId, role);

    const product = await this.prisma.product.findUnique({
      where: { id: dto.productId },
    });

    if (
      !product ||
      product.status !== ProductStatus.ACTIVE ||
      product.deletedAt
    ) {
      throw new BadRequestException(
        'Product is invalid, inactive, or archived',
      );
    }

    const mfgDate = dto.manufacturingDate
      ? new Date(dto.manufacturingDate)
      : null;
    const expDate = new Date(dto.expiryDate);

    if (mfgDate && expDate <= mfgDate) {
      throw new BadRequestException(
        'Expiry date must be after manufacturing date',
      );
    }

    return this.prisma.$transaction(async (tx) => {
      const inventory = await tx.inventory.create({
        data: {
          storeId,
          productId: dto.productId,
          batchNumber: dto.batchNumber,
          stockQuantity: dto.stockQuantity,
          originalPrice: dto.originalPrice,
          sellingPrice: dto.sellingPrice,
          manufacturingDate: mfgDate,
          expiryDate: expDate,
        },
      });

      // If initial stock is > 0, create a stock movement record
      if (inventory.stockQuantity > 0) {
        await this.stockService.adjustStock(
          inventory.id,
          actorId,
          {
            action: AdjustStockAction.ADD, // Mapped locally
            quantity: inventory.stockQuantity,
            movementType: 'PURCHASED',
            reason: 'Initial inventory creation',
          },
          tx,
        );
      }

      await this.audit.log(
        {
          actorId,
          action: 'INVENTORY_CREATED',
          entityType: 'Inventory',
          entityId: inventory.id,
          newData: inventory,
        },
        tx,
      );

      return inventory;
    });
  }

  async update(
    id: string,
    actorId: string,
    role: UserRole,
    dto: UpdateInventoryDto,
  ) {
    const inventory = await this.prisma.inventory.findUnique({
      where: { id },
      include: { store: true },
    });

    if (!inventory) throw new NotFoundException('Inventory not found');
    await this.verifyStoreAccess(inventory.storeId, actorId, role);

    let mfgDate = inventory.manufacturingDate;
    let expDate = inventory.expiryDate;

    if (dto.manufacturingDate) mfgDate = new Date(dto.manufacturingDate);
    if (dto.expiryDate) expDate = new Date(dto.expiryDate);

    if (mfgDate && expDate <= mfgDate) {
      throw new BadRequestException(
        'Expiry date must be after manufacturing date',
      );
    }

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.inventory.update({
        where: { id },
        data: {
          batchNumber: dto.batchNumber,
          originalPrice: dto.originalPrice,
          sellingPrice: dto.sellingPrice,
          manufacturingDate: mfgDate,
          expiryDate: expDate,
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'INVENTORY_UPDATED',
          entityType: 'Inventory',
          entityId: id,
          previousData: inventory,
          newData: updated,
        },
        tx,
      );

      return updated;
    });
  }

  async adjustStock(
    id: string,
    actorId: string,
    role: UserRole,
    dto: AdjustStockDto,
  ) {
    const inventory = await this.prisma.inventory.findUnique({
      where: { id },
    });

    if (!inventory) throw new NotFoundException('Inventory not found');
    await this.verifyStoreAccess(inventory.storeId, actorId, role);

    const result = await this.stockService.adjustStock(id, actorId, dto);

    // If stock changed, we log an audit action beyond just the movement record
    if (result.updated) {
      // Async background logging outside transaction is fine for simple audit trace

      await this.audit.log(
        {
          actorId,
          action: 'STOCK_ADJUSTED',
          entityType: 'Inventory',
          entityId: id,
          previousData: { stockQuantity: result.previousQuantity },
          newData: { stockQuantity: result.newQuantity },
        },
        this.prisma,
      );
    }

    return result;
  }

  async findOne(id: string, actorId: string, role: UserRole) {
    const inventory = await this.prisma.inventory.findUnique({
      where: { id },
      include: {
        product: {
          select: {
            name: true,
            brand: true,
            unit: true,
            sku: true,
            barcode: true,
          },
        },
      },
    });

    if (!inventory) throw new NotFoundException('Inventory not found');
    await this.verifyStoreAccess(inventory.storeId, actorId, role);

    const expiryStatus = this.expiryService.getExpiryStatus(
      inventory.expiryDate,
    );
    const timeRemaining = this.expiryService.getTimeUntilExpiry(
      inventory.expiryDate,
    );

    return {
      ...inventory,
      expiryStatus,
      timeRemaining,
    };
  }

  async findAll(
    storeId: string,
    actorId: string,
    role: UserRole,
    query: InventoryQueryDto,
  ) {
    await this.verifyStoreAccess(storeId, actorId, role);

    const {
      page = 1,
      limit = 20,
      expiryStatus,
      productId,
      categoryId,
      lowStock,
      sortBy,
      sortOrder,
    } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.InventoryWhereInput = {
      storeId,
      deletedAt: null,
      status: { not: InventoryStatus.INACTIVE },
    };

    if (productId) {
      where.productId = productId;
    }

    if (categoryId) {
      where.product = { categoryId };
    }

    if (lowStock) {
      // Hardcoded low stock threshold of 10 for now
      where.stockQuantity = { lte: 10 };
    }

    if (expiryStatus) {
      const now = new Date();
      if (expiryStatus === ExpiryStatus.EXPIRED) {
        where.expiryDate = { lte: now };
      } else {
        const lowerBound = new Date();
        const upperBound = new Date();

        switch (expiryStatus) {
          case ExpiryStatus.CRITICAL:
            upperBound.setDate(
              upperBound.getDate() + EXPIRY_THRESHOLDS_DAYS.CRITICAL,
            );
            where.expiryDate = { gt: now, lte: upperBound };
            break;
          case ExpiryStatus.URGENT:
            lowerBound.setDate(
              lowerBound.getDate() + EXPIRY_THRESHOLDS_DAYS.CRITICAL,
            );
            upperBound.setDate(
              upperBound.getDate() + EXPIRY_THRESHOLDS_DAYS.URGENT,
            );
            where.expiryDate = { gt: lowerBound, lte: upperBound };
            break;
          case ExpiryStatus.EXPIRING_SOON:
            lowerBound.setDate(
              lowerBound.getDate() + EXPIRY_THRESHOLDS_DAYS.URGENT,
            );
            upperBound.setDate(
              upperBound.getDate() + EXPIRY_THRESHOLDS_DAYS.EXPIRING_SOON,
            );
            where.expiryDate = { gt: lowerBound, lte: upperBound };
            break;
          case ExpiryStatus.FRESH:
            lowerBound.setDate(
              lowerBound.getDate() + EXPIRY_THRESHOLDS_DAYS.EXPIRING_SOON,
            );
            where.expiryDate = { gt: lowerBound };
            break;
        }
      }
    }

    const orderBy: Prisma.InventoryOrderByWithRelationInput = {};
    if (sortBy) {
      orderBy[sortBy as keyof Prisma.InventoryOrderByWithRelationInput] = sortOrder || 'asc';
    } else {
      orderBy.expiryDate = 'asc'; // Default sorting
    }

    const [items, total] = await Promise.all([
      this.prisma.inventory.findMany({
        where,
        include: {
          product: {
            select: { name: true, brand: true, unit: true, sku: true },
          },
        },
        skip,
        take: limit,
        orderBy,
      }),
      this.prisma.inventory.count({ where }),
    ]);

    // Enhance response with calculated fields
    const enhancedItems = items.map((item) => ({
      ...item,
      expiryStatus: this.expiryService.getExpiryStatus(item.expiryDate),
      timeRemaining: this.expiryService.getTimeUntilExpiry(item.expiryDate),
    }));

    return createPaginatedResponse(enhancedItems, total, page, limit);
  }

  async remove(id: string, actorId: string, role: UserRole) {
    const inventory = await this.prisma.inventory.findUnique({
      where: { id },
      include: { store: true },
    });

    if (!inventory) throw new NotFoundException('Inventory not found');
    await this.verifyStoreAccess(inventory.storeId, actorId, role);

    return this.prisma.$transaction(async (tx) => {
      const archived = await tx.inventory.update({
        where: { id },
        data: {
          status: InventoryStatus.INACTIVE,
          deletedAt: new Date(),
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'INVENTORY_ARCHIVED',
          entityType: 'Inventory',
          entityId: id,
          previousData: {
            status: inventory.status,
            deletedAt: inventory.deletedAt,
          },
          newData: { status: archived.status, deletedAt: archived.deletedAt },
        },
        tx,
      );

      return { success: true, message: 'Inventory archived successfully' };
    });
  }
}
