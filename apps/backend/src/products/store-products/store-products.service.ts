import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { ExpiryService } from '../../inventory/services/expiry.service';
import { StockService } from '../../inventory/services/stock.service';
import { CreateStoreProductDto } from './dto/create-store-product.dto';
import { UpdateStoreProductDto } from './dto/update-store-product.dto';
import { StoreProductQueryDto } from './dto/store-product-query.dto';
import { createPaginatedResponse } from '../../common/dto/pagination.dto';
import {
  UserRole,
  ProductStatus,
  InventoryStatus,
  CategoryStatus,
  StockMovementType,
  Prisma,
} from '@prisma/client';

@Injectable()
export class StoreProductsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly expiryService: ExpiryService,
    private readonly stockService: StockService,
  ) {}

  /**
   * Verifies that the authenticated actor has authorization for this specific store.
   */
  async verifyStoreAccess(storeId: string, userId: string, role: UserRole) {
    if (role === UserRole.ADMIN || role === UserRole.SUPER_ADMIN) {
      return true;
    }

    if (role === UserRole.SHOP_OWNER) {
      const store = await this.prisma.store.findFirst({
        where: { id: storeId, business: { ownerId: userId } },
      });
      if (!store) {
        throw new ForbiddenException('You do not own this store');
      }
      return true;
    }

    if (role === UserRole.SHOP_STAFF) {
      const staff = await this.prisma.storeStaff.findUnique({
        where: { storeId_userId: { storeId, userId } },
      });
      if (!staff) {
        throw new ForbiddenException('You are not assigned to this store');
      }
      return true;
    }

    throw new ForbiddenException('Unauthorized to access store products');
  }

  private async generateSlug(name: string): Promise<string> {
    const baseSlug = name
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/(^-|-$)+/g, '');

    let slug = baseSlug;
    let counter = 1;

    while (await this.prisma.product.findUnique({ where: { slug } })) {
      slug = `${baseSlug}-${counter}`;
      counter++;
    }

    return slug;
  }

  private async checkUniqueness(
    sku?: string,
    barcode?: string,
    currentProductId?: string,
  ) {
    if (sku) {
      const existing = await this.prisma.product.findFirst({
        where: { sku, deletedAt: null },
      });
      if (existing && existing.id !== currentProductId) {
        throw new ConflictException(`SKU "${sku}" is already in use by another product`);
      }
    }
    if (barcode) {
      const existing = await this.prisma.product.findFirst({
        where: { barcode, deletedAt: null },
      });
      if (existing && existing.id !== currentProductId) {
        throw new ConflictException(`Barcode "${barcode}" is already in use by another product`);
      }
    }
  }

  private mapStoreProduct(inventory: any) {
    const availableQty = Math.max(0, inventory.stockQuantity - (inventory.reservedQuantity || 0));
    return {
      id: inventory.product.id,
      productId: inventory.product.id,
      inventoryId: inventory.id,
      storeId: inventory.storeId,
      name: inventory.product.name,
      slug: inventory.product.slug,
      description: inventory.product.description,
      brand: inventory.product.brand,
      sku: inventory.product.sku,
      barcode: inventory.product.barcode,
      image: inventory.product.image,
      unit: inventory.product.unit,
      category: inventory.product.category,
      categoryId: inventory.product.categoryId,
      sellingPrice: Number(inventory.sellingPrice),
      originalPrice: Number(inventory.originalPrice),
      stockQuantity: inventory.stockQuantity,
      reservedQuantity: inventory.reservedQuantity || 0,
      availableQuantity: availableQty,
      status: inventory.product.status,
      inventoryStatus: inventory.status,
      expiryDate: inventory.expiryDate,
      manufacturingDate: inventory.manufacturingDate,
      batchNumber: inventory.batchNumber,
      expiryStatus: this.expiryService.getExpiryStatus(inventory.expiryDate),
      timeRemaining: this.expiryService.getTimeUntilExpiry(inventory.expiryDate),
      createdAt: inventory.createdAt,
      updatedAt: inventory.updatedAt,
    };
  }

  /**
   * List products belonging to a specific store with filtering and pagination.
   */
  async findAll(
    storeId: string,
    userId: string,
    role: UserRole,
    query: StoreProductQueryDto,
  ) {
    await this.verifyStoreAccess(storeId, userId, role);

    const { page = 1, limit = 20, search, categoryId, status } = query;
    const skip = (page - 1) * limit;

    const productWhere: Prisma.ProductWhereInput = {
      deletedAt: null,
    };

    const andConditions: Prisma.ProductWhereInput[] = [];

    if (categoryId) {
      andConditions.push({
        OR: [
          { categoryId },
          { category: { parentId: categoryId } },
        ],
      });
    }

    if (search) {
      andConditions.push({
        OR: [
          { name: { contains: search, mode: 'insensitive' } },
          { brand: { contains: search, mode: 'insensitive' } },
          { sku: { contains: search, mode: 'insensitive' } },
          { barcode: { contains: search, mode: 'insensitive' } },
        ],
      });
    }

    if (andConditions.length > 0) {
      productWhere.AND = andConditions;
    }

    const where: Prisma.InventoryWhereInput = {
      storeId,
      deletedAt: null,
      product: productWhere,
    };

    if (status) {
      where.status = status;
    }

    const [items, total] = await Promise.all([
      this.prisma.inventory.findMany({
        where,
        include: {
          product: {
            include: {
              category: {
                select: { id: true, name: true, slug: true, parentId: true },
              },
            },
          },
        },
        skip,
        take: limit,
        orderBy: { updatedAt: 'desc' },
      }),
      this.prisma.inventory.count({ where }),
    ]);

    const mappedItems = items.map((inv) => this.mapStoreProduct(inv));
    return createPaginatedResponse(mappedItems, total, page, limit);
  }

  /**
   * Find a single store product by either Product ID or Inventory ID.
   */
  async findOne(
    storeId: string,
    identifier: string,
    userId: string,
    role: UserRole,
  ) {
    await this.verifyStoreAccess(storeId, userId, role);

    const inventory = await this.prisma.inventory.findFirst({
      where: {
        storeId,
        deletedAt: null,
        OR: [{ id: identifier }, { productId: identifier }],
      },
      include: {
        product: {
          include: {
            category: {
              select: { id: true, name: true, slug: true, parentId: true },
            },
          },
        },
      },
    });

    if (!inventory) {
      throw new NotFoundException('Store product not found');
    }

    return this.mapStoreProduct(inventory);
  }

  /**
   * Create a new product and add it to the store's inventory in a single atomic transaction.
   */
  async create(
    storeId: string,
    userId: string,
    role: UserRole,
    dto: CreateStoreProductDto,
  ) {
    await this.verifyStoreAccess(storeId, userId, role);

    // 1. Validate pricing logic
    if (dto.sellingPrice > dto.originalPrice) {
      throw new BadRequestException('Selling price cannot exceed original price');
    }

    // 2. Validate dates
    const expDate = new Date(dto.expiryDate);
    const mfgDate = dto.manufacturingDate ? new Date(dto.manufacturingDate) : null;
    if (mfgDate && expDate <= mfgDate) {
      throw new BadRequestException('Expiry date must be after manufacturing date');
    }

    // 3. Validate category
    const category = await this.prisma.category.findUnique({
      where: { id: dto.categoryId },
    });
    if (!category || category.deletedAt || category.status !== CategoryStatus.ACTIVE) {
      throw new BadRequestException('Category is invalid, inactive, or archived');
    }

    return this.prisma.$transaction(async (tx) => {
      let product: any;

      if (dto.productId) {
        // Link to existing product
        product = await tx.product.findUnique({
          where: { id: dto.productId },
          include: { category: true },
        });
        if (!product || product.deletedAt || product.status !== ProductStatus.ACTIVE) {
          throw new BadRequestException('Referenced catalog product is inactive or not found');
        }
      } else {
        // Check uniqueness of SKU / Barcode
        await this.checkUniqueness(dto.sku, dto.barcode);

        const slug = await this.generateSlug(dto.name);
        product = await tx.product.create({
          data: {
            name: dto.name,
            slug,
            categoryId: dto.categoryId,
            description: dto.description,
            brand: dto.brand,
            sku: dto.sku,
            barcode: dto.barcode,
            image: dto.image,
            unit: dto.unit,
            status: ProductStatus.ACTIVE,
          },
          include: { category: true },
        });

        await this.audit.log(
          {
            actorId: userId,
            action: 'PRODUCT_CREATED',
            entityType: 'Product',
            entityId: product.id,
            newData: product,
          },
          tx,
        );
      }

      // Check if store already stocks this product
      const existingInventory = await tx.inventory.findFirst({
        where: {
          storeId,
          productId: product.id,
          deletedAt: null,
        },
      });

      let inventoryRecord: any;
      const initialStatus =
        dto.initialStockQuantity > 0
          ? InventoryStatus.ACTIVE
          : InventoryStatus.OUT_OF_STOCK;

      if (existingInventory) {
        // Update the existing inventory batch
        inventoryRecord = await tx.inventory.update({
          where: { id: existingInventory.id },
          data: {
            stockQuantity: existingInventory.stockQuantity + dto.initialStockQuantity,
            sellingPrice: dto.sellingPrice,
            originalPrice: dto.originalPrice,
            expiryDate: expDate,
            manufacturingDate: mfgDate,
            batchNumber: dto.batchNumber || existingInventory.batchNumber,
            status:
              existingInventory.stockQuantity + dto.initialStockQuantity > 0
                ? InventoryStatus.ACTIVE
                : InventoryStatus.OUT_OF_STOCK,
          },
        });
      } else {
        inventoryRecord = await tx.inventory.create({
          data: {
            storeId,
            productId: product.id,
            stockQuantity: dto.initialStockQuantity,
            sellingPrice: dto.sellingPrice,
            originalPrice: dto.originalPrice,
            expiryDate: expDate,
            manufacturingDate: mfgDate,
            batchNumber: dto.batchNumber,
            status: initialStatus,
          },
        });
      }

      // Record stock movement if initial stock > 0
      if (dto.initialStockQuantity > 0) {
        await tx.inventoryStockMovement.create({
          data: {
            inventoryId: inventoryRecord.id,
            type: StockMovementType.PURCHASED,
            quantity: dto.initialStockQuantity,
            previousQuantity: existingInventory ? existingInventory.stockQuantity : 0,
            newQuantity: inventoryRecord.stockQuantity,
            reason: 'Initial stock intake for store product',
            actorId: userId,
          },
        });
      }

      await this.audit.log(
        {
          actorId: userId,
          action: 'STORE_PRODUCT_CREATED',
          entityType: 'Inventory',
          entityId: inventoryRecord.id,
          newData: {
            productId: product.id,
            storeId,
            stockQuantity: inventoryRecord.stockQuantity,
            sellingPrice: dto.sellingPrice,
            originalPrice: dto.originalPrice,
          },
        },
        tx,
      );

      return this.mapStoreProduct({
        ...inventoryRecord,
        product,
      });
    });
  }

  /**
   * Update an existing store product's metadata, pricing, inventory quantity, or status.
   */
  async update(
    storeId: string,
    identifier: string,
    userId: string,
    role: UserRole,
    dto: UpdateStoreProductDto,
  ) {
    await this.verifyStoreAccess(storeId, userId, role);

    const inventory = await this.prisma.inventory.findFirst({
      where: {
        storeId,
        deletedAt: null,
        OR: [{ id: identifier }, { productId: identifier }],
      },
      include: {
        product: true,
      },
    });

    if (!inventory) {
      throw new NotFoundException('Store product not found');
    }

    const currentProduct = inventory.product;

    // Validate category if updating
    if (dto.categoryId && dto.categoryId !== currentProduct.categoryId) {
      const category = await this.prisma.category.findUnique({
        where: { id: dto.categoryId },
      });
      if (!category || category.deletedAt || category.status !== CategoryStatus.ACTIVE) {
        throw new BadRequestException('Category is invalid, inactive, or archived');
      }
    }

    // Validate pricing
    const effSelling = dto.sellingPrice !== undefined ? dto.sellingPrice : Number(inventory.sellingPrice);
    const effOriginal = dto.originalPrice !== undefined ? dto.originalPrice : Number(inventory.originalPrice);
    if (effSelling > effOriginal) {
      throw new BadRequestException('Selling price cannot exceed original price');
    }

    // Validate dates
    const effExp = dto.expiryDate ? new Date(dto.expiryDate) : inventory.expiryDate;
    const effMfg = dto.manufacturingDate
      ? new Date(dto.manufacturingDate)
      : inventory.manufacturingDate;
    if (effMfg && effExp <= effMfg) {
      throw new BadRequestException('Expiry date must be after manufacturing date');
    }

    // Check SKU/Barcode uniqueness
    await this.checkUniqueness(dto.sku, dto.barcode, currentProduct.id);

    return this.prisma.$transaction(async (tx) => {
      // 1. Update Product metadata if changed
      let newSlug = currentProduct.slug;
      if (dto.name && dto.name !== currentProduct.name) {
        newSlug = await this.generateSlug(dto.name);
      }

      const updatedProduct = await tx.product.update({
        where: { id: currentProduct.id },
        data: {
          name: dto.name,
          slug: newSlug,
          categoryId: dto.categoryId,
          description: dto.description,
          brand: dto.brand,
          sku: dto.sku,
          barcode: dto.barcode,
          image: dto.image,
          unit: dto.unit,
        },
        include: {
          category: {
            select: { id: true, name: true, slug: true, parentId: true },
          },
        },
      });

      // 2. Handle stock quantity changes and record movements
      let newStockQuantity = inventory.stockQuantity;
      if (dto.stockQuantity !== undefined && dto.stockQuantity !== inventory.stockQuantity) {
        const diff = dto.stockQuantity - inventory.stockQuantity;
        newStockQuantity = dto.stockQuantity;

        await tx.inventoryStockMovement.create({
          data: {
            inventoryId: inventory.id,
            type: diff > 0 ? StockMovementType.ADJUSTMENT : StockMovementType.OTHER,
            quantity: Math.abs(diff),
            previousQuantity: inventory.stockQuantity,
            newQuantity: newStockQuantity,
            reason: 'Manual adjustment during product editing',
            actorId: userId,
          },
        });
      }

      // Determine inventory status
      let newStatus = dto.inventoryStatus || inventory.status;
      if (newStockQuantity <= 0 && newStatus === InventoryStatus.ACTIVE) {
        newStatus = InventoryStatus.OUT_OF_STOCK;
      } else if (newStockQuantity > 0 && newStatus === InventoryStatus.OUT_OF_STOCK) {
        newStatus = InventoryStatus.ACTIVE;
      }

      // 3. Update Inventory record
      const updatedInventory = await tx.inventory.update({
        where: { id: inventory.id },
        data: {
          sellingPrice: dto.sellingPrice !== undefined ? dto.sellingPrice : inventory.sellingPrice,
          originalPrice: dto.originalPrice !== undefined ? dto.originalPrice : inventory.originalPrice,
          stockQuantity: newStockQuantity,
          expiryDate: effExp,
          manufacturingDate: effMfg,
          batchNumber: dto.batchNumber !== undefined ? dto.batchNumber : inventory.batchNumber,
          status: newStatus,
        },
      });

      await this.audit.log(
        {
          actorId: userId,
          action: 'STORE_PRODUCT_UPDATED',
          entityType: 'Inventory',
          entityId: inventory.id,
          previousData: {
            sellingPrice: inventory.sellingPrice,
            originalPrice: inventory.originalPrice,
            stockQuantity: inventory.stockQuantity,
          },
          newData: {
            sellingPrice: updatedInventory.sellingPrice,
            originalPrice: updatedInventory.originalPrice,
            stockQuantity: updatedInventory.stockQuantity,
          },
        },
        tx,
      );

      return this.mapStoreProduct({
        ...updatedInventory,
        product: updatedProduct,
      });
    });
  }

  /**
   * Archive / soft-delete a product from a store's active inventory.
   */
  async remove(
    storeId: string,
    identifier: string,
    userId: string,
    role: UserRole,
  ) {
    await this.verifyStoreAccess(storeId, userId, role);

    const inventory = await this.prisma.inventory.findFirst({
      where: {
        storeId,
        deletedAt: null,
        OR: [{ id: identifier }, { productId: identifier }],
      },
    });

    if (!inventory) {
      throw new NotFoundException('Store product not found');
    }

    return this.prisma.$transaction(async (tx) => {
      const archived = await tx.inventory.update({
        where: { id: inventory.id },
        data: {
          status: InventoryStatus.INACTIVE,
          deletedAt: new Date(),
        },
      });

      await this.audit.log(
        {
          actorId: userId,
          action: 'STORE_PRODUCT_ARCHIVED',
          entityType: 'Inventory',
          entityId: inventory.id,
          previousData: { status: inventory.status },
          newData: { status: archived.status, deletedAt: archived.deletedAt },
        },
        tx,
      );

      return {
        success: true,
        message: 'Product removed from store catalog successfully',
      };
    });
  }
}
