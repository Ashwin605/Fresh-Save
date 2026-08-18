import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { CreateProductDto } from './dto/create-product.dto';
import { UpdateProductDto } from './dto/update-product.dto';
import { ProductQueryDto } from './dto/product-query.dto';
import { createPaginatedResponse } from '../../common/dto/pagination.dto';
import { CategoryStatus, ProductStatus, Prisma } from '@prisma/client';

@Injectable()
export class ProductsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

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
    currentId?: string,
  ) {
    if (sku) {
      const existing = await this.prisma.product.findFirst({ where: { sku } });
      if (existing && existing.id !== currentId) {
        throw new ConflictException('SKU already exists');
      }
    }
    if (barcode) {
      const existing = await this.prisma.product.findFirst({
        where: { barcode },
      });
      if (existing && existing.id !== currentId) {
        throw new ConflictException('Barcode already exists');
      }
    }
  }

  async create(actorId: string, dto: CreateProductDto) {
    const category = await this.prisma.category.findUnique({
      where: { id: dto.categoryId },
    });

    if (!category) {
      throw new NotFoundException('Category not found');
    }
    if (category.status !== CategoryStatus.ACTIVE || category.deletedAt) {
      throw new BadRequestException('Category is inactive or archived');
    }

    await this.checkUniqueness(dto.sku, dto.barcode);
    const slug = await this.generateSlug(dto.name);

    return this.prisma.$transaction(async (tx) => {
      const product = await tx.product.create({
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
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'PRODUCT_CREATED',
          entityType: 'Product',
          entityId: product.id,
          newData: product,
        },
        tx,
      );

      return product;
    });
  }

  async findAll(query: ProductQueryDto) {
    const { page = 1, limit = 20, search, categoryId, brand, status } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.ProductWhereInput = {
      deletedAt: null,
    };

    if (status) {
      where.status = status as ProductStatus;
    } else {
      where.status = ProductStatus.ACTIVE;
    }

    if (categoryId) {
      where.categoryId = categoryId;
    }

    if (brand) {
      where.brand = { equals: brand, mode: 'insensitive' };
    }

    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { brand: { contains: search, mode: 'insensitive' } },
        { sku: { equals: search } },
        { barcode: { equals: search } },
      ];
    }

    const [items, total] = await Promise.all([
      this.prisma.product.findMany({
        where,
        include: { category: { select: { id: true, name: true, slug: true } } },
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.product.count({ where }),
    ]);

    return createPaginatedResponse(items, total, page, limit);
  }

  async findOne(id: string) {
    const product = await this.prisma.product.findUnique({
      where: { id },
      include: {
        category: {
          select: { id: true, name: true, slug: true, status: true },
        },
      },
    });

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    return product;
  }

  async update(id: string, actorId: string, dto: UpdateProductDto) {
    const product = await this.prisma.product.findUnique({ where: { id } });

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    if (dto.categoryId) {
      const category = await this.prisma.category.findUnique({
        where: { id: dto.categoryId },
      });
      if (!category) {
        throw new NotFoundException('Category not found');
      }
      if (category.status !== CategoryStatus.ACTIVE || category.deletedAt) {
        throw new BadRequestException('Category is inactive or archived');
      }
    }

    await this.checkUniqueness(dto.sku, dto.barcode, id);

    let slug = product.slug;
    if (dto.name && dto.name !== product.name) {
      slug = await this.generateSlug(dto.name);
    }

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.product.update({
        where: { id },
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
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'PRODUCT_UPDATED',
          entityType: 'Product',
          entityId: id,
          previousData: product,
          newData: updated,
        },
        tx,
      );

      return updated;
    });
  }

  async remove(id: string, actorId: string) {
    const product = await this.prisma.product.findUnique({ where: { id } });

    if (!product) {
      throw new NotFoundException('Product not found');
    }

    // Archiving instead of hard-deleting to preserve historical inventory data
    return this.prisma.$transaction(async (tx) => {
      const archived = await tx.product.update({
        where: { id },
        data: {
          status: ProductStatus.INACTIVE,
          deletedAt: new Date(),
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'PRODUCT_ARCHIVED',
          entityType: 'Product',
          entityId: id,
          previousData: {
            status: product.status,
            deletedAt: product.deletedAt,
          },
          newData: { status: archived.status, deletedAt: archived.deletedAt },
        },
        tx,
      );

      return { success: true, message: 'Product archived successfully' };
    });
  }
}
