import {
  Injectable,
  NotFoundException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AuditService } from '../../database/audit.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { CategoryStatus } from '@prisma/client';

@Injectable()
export class CategoriesService {
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

    while (await this.prisma.category.findUnique({ where: { slug } })) {
      slug = `${baseSlug}-${counter}`;
      counter++;
    }

    return slug;
  }

  private async checkCircularDependency(categoryId: string, parentId: string) {
    if (categoryId === parentId) {
      throw new BadRequestException('A category cannot be its own parent');
    }

    let currentParent = await this.prisma.category.findUnique({
      where: { id: parentId },
      select: { parentId: true },
    });

    while (currentParent?.parentId) {
      if (currentParent.parentId === categoryId) {
        throw new BadRequestException('Circular category dependency detected');
      }
      currentParent = await this.prisma.category.findUnique({
        where: { id: currentParent.parentId },
        select: { parentId: true },
      });
    }
  }

  async create(actorId: string, dto: CreateCategoryDto) {
    if (dto.parentId) {
      const parent = await this.prisma.category.findUnique({
        where: { id: dto.parentId },
      });
      if (!parent) {
        throw new NotFoundException('Parent category not found');
      }
      if (parent.status !== CategoryStatus.ACTIVE || parent.deletedAt) {
        throw new BadRequestException(
          'Parent category is inactive or archived',
        );
      }
    }

    const slug = await this.generateSlug(dto.name);

    return this.prisma.$transaction(async (tx) => {
      const category = await tx.category.create({
        data: {
          name: dto.name,
          slug,
          description: dto.description,
          icon: dto.icon,
          image: dto.image,
          parentId: dto.parentId,
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'CATEGORY_CREATED',
          entityType: 'Category',
          entityId: category.id,
          newData: category,
        },
        tx,
      );

      return category;
    });
  }

  async findAll() {
    return this.prisma.category.findMany({
      where: {
        status: CategoryStatus.ACTIVE,
        deletedAt: null,
      },
      include: {
        children: {
          where: { status: CategoryStatus.ACTIVE, deletedAt: null },
        },
      },
    });
  }

  async findOne(id: string) {
    const category = await this.prisma.category.findUnique({
      where: { id },
      include: {
        children: {
          where: { status: CategoryStatus.ACTIVE, deletedAt: null },
        },
      },
    });

    if (!category) {
      throw new NotFoundException('Category not found');
    }

    return category;
  }

  async update(id: string, actorId: string, dto: UpdateCategoryDto) {
    const category = await this.prisma.category.findUnique({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Category not found');
    }

    if (dto.parentId) {
      const parent = await this.prisma.category.findUnique({
        where: { id: dto.parentId },
      });
      if (!parent) {
        throw new NotFoundException('Parent category not found');
      }
      if (parent.status !== CategoryStatus.ACTIVE || parent.deletedAt) {
        throw new BadRequestException(
          'Parent category is inactive or archived',
        );
      }

      await this.checkCircularDependency(id, dto.parentId);
    }

    let slug = category.slug;
    if (dto.name && dto.name !== category.name) {
      slug = await this.generateSlug(dto.name);
    }

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.category.update({
        where: { id },
        data: {
          name: dto.name,
          slug,
          description: dto.description,
          icon: dto.icon,
          image: dto.image,
          parentId: dto.parentId,
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'CATEGORY_UPDATED',
          entityType: 'Category',
          entityId: id,
          previousData: category,
          newData: updated,
        },
        tx,
      );

      return updated;
    });
  }

  async remove(id: string, actorId: string) {
    const category = await this.prisma.category.findUnique({
      where: { id },
    });

    if (!category) {
      throw new NotFoundException('Category not found');
    }

    // We do not hard delete. Instead, we archive it.
    return this.prisma.$transaction(async (tx) => {
      const archived = await tx.category.update({
        where: { id },
        data: {
          status: CategoryStatus.INACTIVE,
          deletedAt: new Date(),
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'CATEGORY_ARCHIVED',
          entityType: 'Category',
          entityId: id,
          previousData: {
            status: category.status,
            deletedAt: category.deletedAt,
          },
          newData: { status: archived.status, deletedAt: archived.deletedAt },
        },
        tx,
      );

      return { success: true, message: 'Category archived successfully' };
    });
  }
}
