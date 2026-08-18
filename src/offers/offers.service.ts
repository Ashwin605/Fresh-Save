/* eslint-disable */
import {
  Injectable,
  ForbiddenException,
  NotFoundException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { DiscountService } from './services/discount.service';
import { OfferValidationService } from './services/offer-validation.service';
import { CreateOfferDto } from './dto/create-offer.dto';
import { UpdateOfferDto } from './dto/update-offer.dto';
import { OfferQueryDto } from './dto/offer-query.dto';
import { UserRole, OfferStatus, Prisma } from '@prisma/client';
import { createPaginatedResponse } from '../common/dto/pagination.dto';

@Injectable()
export class OffersService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
    private readonly discountService: DiscountService,
    private readonly offerValidation: OfferValidationService,
  ) {}

  /**
   * Reusable authorization check for offers based on store ID
   */
  async verifyStoreAccess(
    storeId: string,
    actorId: string,
    role: UserRole,
  ): Promise<boolean> {
    if (role === UserRole.ADMIN || role === UserRole.SUPER_ADMIN) {
      return true;
    }

    if (role === UserRole.SHOP_OWNER) {
      const store = await this.prisma.store.findFirst({
        where: {
          id: storeId,
          business: { ownerId: actorId },
        },
      });
      if (!store) {
        throw new ForbiddenException('You do not have access to this store');
      }
      return true;
    }

    if (role === UserRole.SHOP_STAFF) {
      const staff = await this.prisma.storeStaff.findUnique({
        where: {
          storeId_userId: { storeId, userId: actorId },
        },
      });
      if (!staff || staff.status !== 'ACTIVE') {
        throw new ForbiddenException('You are not authorized for this store');
      }
      return true;
    }

    throw new ForbiddenException('Role not authorized for managing offers');
  }

  /**
   * Helper to fetch inventory with its product and store relationships
   */
  private async getInventoryWithRelations(inventoryId: string) {
    const inventory = await this.prisma.inventory.findUnique({
      where: { id: inventoryId },
      include: {
        store: true,
        product: true,
      },
    });

    if (!inventory) {
      throw new NotFoundException('Inventory batch not found');
    }

    return inventory;
  }

  async create(
    inventoryId: string,
    actorId: string,
    role: UserRole,
    dto: CreateOfferDto,
  ) {
    const inventory = await this.getInventoryWithRelations(inventoryId);

    // Verify ownership
    await this.verifyStoreAccess(inventory.storeId, actorId, role);

    const now = new Date();
    const startsAt = new Date(dto.startsAt);
    const endsAt = new Date(dto.endsAt);

    // Run business validations
    this.offerValidation.validateInventoryEligibility(inventory, now);
    this.offerValidation.validateOfferDates(
      startsAt,
      endsAt,
      inventory.expiryDate,
    );

    // Calculate discount
    const { discountedPrice, discountAmount } = this.discountService.calculateDiscount(
      inventory.sellingPrice,
      dto.discountType,
      dto.discountValue,
    );

    // Ensure we don't have overlapping active/scheduled offers for this exact inventory
    // To prevent race conditions, we can do this inside a transaction
    return this.prisma.$transaction(async (tx) => {
      const activeOffers = await tx.offer.findMany({
        where: {
          inventoryId,
          status: { in: [OfferStatus.ACTIVE, OfferStatus.SCHEDULED] },
        },
      });

      // Filter effective statuses in memory just in case the DB says ACTIVE but time passed
      const conflictingOffers = activeOffers.filter((offer) => {
        const effStatus = this.offerValidation.getEffectiveOfferStatus(
          offer,
          inventory.stockQuantity,
          inventory.expiryDate,
          now,
        );
        return (
          effStatus === OfferStatus.ACTIVE ||
          effStatus === OfferStatus.SCHEDULED
        );
      });

      if (conflictingOffers.length > 0) {
        throw new ConflictException(
          'An active or scheduled offer already exists for this inventory batch',
        );
      }

      // Determine initial state
      // If start time is in the future, it's SCHEDULED, else ACTIVE
      const initialStatus =
        startsAt > now ? OfferStatus.SCHEDULED : OfferStatus.ACTIVE;

      const offer = await tx.offer.create({
        data: {
          inventoryId,
          title: dto.title,
          description: dto.description,
          discountType: dto.discountType,
          discountValue: dto.discountValue,
          originalPriceSnapshot: inventory.sellingPrice,
          discountAmount,
          discountedPrice,
          startsAt,
          endsAt,
          status: initialStatus,
          createdById: actorId,
        },
      });

      await this.audit.log(
        {
          actorId,
          action: 'OFFER_CREATED',
          entityType: 'Offer',
          entityId: offer.id,
          newData: offer as any,
        },
        tx,
      );

      return offer;
    });
  }

  async findAll(
    storeId: string,
    actorId: string,
    role: UserRole,
    query: OfferQueryDto,
  ) {
    await this.verifyStoreAccess(storeId, actorId, role);

    const {
      status,
      productId,
      sortBy = 'createdAt',
      sortOrder = 'desc',
      page = 1,
      limit = 20,
    } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.OfferWhereInput = {
      inventory: { storeId },
    };

    if (productId) {
      where.inventory = { storeId, productId };
    }

    if (status) {
      where.status = status;
    }

    const [total, items] = await Promise.all([
      this.prisma.offer.count({ where }),
      this.prisma.offer.findMany({
        where,
        include: {
          inventory: {
            include: { product: true },
          },
        },
        orderBy: { [sortBy]: sortOrder },
        skip,
        take: limit,
      }),
    ]);

    // Compute effective statuses dynamically
    const now = new Date();
    const evaluatedItems = items.map((item) => ({
      ...item,
      effectiveStatus: this.offerValidation.getEffectiveOfferStatus(
        item,
        item.inventory.stockQuantity,
        item.inventory.expiryDate,
        now,
      ),
    }));

    // If client requested a specific status, they expect the effective status to match it.
    // If we only filter the DB query, a DB 'ACTIVE' that effectively became 'EXPIRED'
    // would falsely appear in '?status=ACTIVE' queries.
    // Thus, we filter the final returned set.
    // NOTE: This could mess up exact total counts if there is heavy drift between DB status and effective status.
    // In a high volume production app, we would run a cron to synchronize statuses to DB, or build more complex DB queries.
    // For this milestone, filtering the paginated results is acceptable.

    let finalItems = evaluatedItems;
    if (status) {
      finalItems = evaluatedItems.filter(
        (item) => item.effectiveStatus === status,
      );
    }

    return createPaginatedResponse(finalItems, total, page, limit);
  }

  async findOne(id: string, actorId: string, role: UserRole) {
    const offer = await this.prisma.offer.findUnique({
      where: { id },
      include: {
        inventory: {
          include: {
            store: true,
            product: true,
          },
        },
      },
    });

    if (!offer) {
      throw new NotFoundException('Offer not found');
    }

    await this.verifyStoreAccess(offer.inventory.storeId, actorId, role);

    const effectiveStatus = this.offerValidation.getEffectiveOfferStatus(
      offer,
      offer.inventory.stockQuantity,
      offer.inventory.expiryDate,
      new Date(),
    );

    return { ...offer, effectiveStatus };
  }

  async update(
    id: string,
    actorId: string,
    role: UserRole,
    dto: UpdateOfferDto,
  ) {
    const existing = await this.prisma.offer.findUnique({
      where: { id },
      include: {
        inventory: {
          include: { store: true, product: true },
        },
      },
    });

    if (!existing) throw new NotFoundException('Offer not found');
    await this.verifyStoreAccess(existing.inventory.storeId, actorId, role);

    const effStatus = this.offerValidation.getEffectiveOfferStatus(
      existing,
      existing.inventory.stockQuantity,
      existing.inventory.expiryDate,
      new Date(),
    );

    if (
      effStatus === OfferStatus.EXPIRED ||
      effStatus === OfferStatus.CANCELLED
    ) {
      throw new BadRequestException(
        'Cannot update an expired or cancelled offer',
      );
    }

    const startsAt = dto.startsAt
      ? new Date(dto.startsAt)
      : existing.startsAt;
    const endsAt = dto.endsAt ? new Date(dto.endsAt) : existing.endsAt;
    const discountType = dto.discountType ?? existing.discountType;
    const discountValue =
      dto.discountValue ?? existing.discountValue.toNumber();

    this.offerValidation.validateOfferDates(
      startsAt,
      endsAt,
      existing.inventory.expiryDate,
    );

    const { discountedPrice, discountAmount } = this.discountService.calculateDiscount(
      existing.inventory.sellingPrice, // Recalculate against original price snapshot
      discountType,
      discountValue,
    );

    const updated = await this.prisma.offer.update({
      where: { id },
      data: {
        title: dto.title ?? existing.title,
        description: dto.description ?? existing.description,
        discountType,
        discountValue,
        discountAmount,
        discountedPrice,
        startsAt,
        endsAt,
      },
    });

    // Async audit log
    await this.audit.log({
      actorId,
      action: 'OFFER_UPDATED',
      entityType: 'Offer',
      entityId: id,
      previousData: {
        discountType: existing.discountType,
        discountValue: existing.discountValue,
      },
      newData: { discountType, discountValue },
    });

    return updated;
  }

  async updateStatus(
    id: string,
    newStatus: OfferStatus,
    actionLabel: string,
    actorId: string,
    role: UserRole,
  ) {
    const existing = await this.prisma.offer.findUnique({
      where: { id },
      include: { inventory: { include: { store: true, product: true } } },
    });

    if (!existing) throw new NotFoundException('Offer not found');
    await this.verifyStoreAccess(existing.inventory.storeId, actorId, role);

    // If activating, re-validate inventory
    if (
      newStatus === OfferStatus.ACTIVE ||
      newStatus === OfferStatus.SCHEDULED
    ) {
      this.offerValidation.validateInventoryEligibility(
        existing.inventory,
        new Date(),
      );
      this.offerValidation.validateOfferDates(
        existing.startsAt,
        existing.endsAt,
        existing.inventory.expiryDate,
      );
    }

    const updated = await this.prisma.$transaction(async (tx) => {
      const result = await tx.offer.update({
        where: { id },
        data: { status: newStatus },
      });

      if (['ACTIVE', 'SOLD_OUT', 'EXPIRED'].includes(newStatus)) {
        await tx.outboxEvent.create({
          data: {
            eventType: `OFFER_${newStatus}`,
            aggregateType: 'Offer',
            aggregateId: id,
            payload: { offerId: id, inventoryId: existing.inventoryId, storeId: existing.inventory.storeId },
          },
        });
      }

      return result;
    });

    await this.audit.log({
      actorId,
      action: actionLabel,
      entityType: 'Offer',
      entityId: id,
      previousData: { status: existing.status },
      newData: { status: newStatus },
    });

    return updated;
  }

  // Admin global query
  async findAllAdmin(query: OfferQueryDto) {
    const {
      status,
      sortBy = 'createdAt',
      sortOrder = 'desc',
      page = 1,
      limit = 20,
    } = query;
    const skip = (page - 1) * limit;

    const where: Prisma.OfferWhereInput = {};
    if (status) {
      where.status = status;
    }

    const [total, items] = await Promise.all([
      this.prisma.offer.count({ where }),
      this.prisma.offer.findMany({
        where,
        include: { inventory: { include: { product: true, store: true } } },
        orderBy: { [sortBy]: sortOrder },
        skip,
        take: limit,
      }),
    ]);

    return createPaginatedResponse(items, total, page, limit);
  }
}
