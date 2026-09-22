import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  ConflictException,
} from '@nestjs/common';
import { PrismaService } from '../database/prisma/prisma.service';
import { AuditService } from '../database/audit.service';
import { CreateBusinessDto } from './dto/create-business.dto';
import { UpdateBusinessDto } from './dto/update-business.dto';
import {
  PaginationDto,
  createPaginatedResponse,
} from '../common/dto/pagination.dto';
import { UserRole, BusinessStatus, VerificationStatus } from '@prisma/client';

@Injectable()
export class BusinessesService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly audit: AuditService,
  ) {}

  async create(ownerId: string, dto: CreateBusinessDto) {
    // Only allow one business per owner as a common SaaS rule
    const existingBusiness = await this.prisma.business.findFirst({
      where: { ownerId },
    });

    if (existingBusiness) {
      throw new ConflictException('You already own a business');
    }

    return this.prisma.$transaction(async (tx) => {
      const business = await tx.business.create({
        data: {
          ownerId,
          businessName: dto.businessName,
          legalName: dto.legalName,
          businessType: dto.businessType,
          contactEmail: dto.contactEmail,
          contactPhone: dto.contactPhone,
        },
      });

      await this.audit.log(
        {
          actorId: ownerId,
          action: 'BUSINESS_CREATED',
          entityType: 'Business',
          entityId: business.id,
          newData: business,
        },
        tx,
      );

      return business;
    });
  }

  async findMyBusiness(ownerId: string) {
    const business = await this.prisma.business.findFirst({
      where: { ownerId },
    });

    if (!business) {
      throw new NotFoundException('Business not found');
    }

    return business;
  }

  async findOne(id: string, actorId: string, actorRole: UserRole) {
    const business = await this.prisma.business.findUnique({
      where: { id },
    });

    if (!business) {
      throw new NotFoundException('Business not found');
    }

    // Role-based access check
    if (actorRole === UserRole.SHOP_OWNER && business.ownerId !== actorId) {
      throw new ForbiddenException('You do not have access to this business');
    }
    // CUSTOMER and SHOP_STAFF are blocked by guards at the controller level from hitting this specific route,
    // or they can be checked here. ADMIN and SUPER_ADMIN have full access.

    return business;
  }

  async update(id: string, ownerId: string, dto: UpdateBusinessDto) {
    const business = await this.prisma.business.findUnique({ where: { id } });

    if (!business) {
      throw new NotFoundException('Business not found');
    }

    if (business.ownerId !== ownerId) {
      throw new ForbiddenException('You do not own this business');
    }

    return this.prisma.$transaction(async (tx) => {
      const updatedBusiness = await tx.business.update({
        where: { id },
        data: {
          businessName: dto.businessName,
          legalName: dto.legalName,
          businessType: dto.businessType,
          contactEmail: dto.contactEmail,
          contactPhone: dto.contactPhone,
        },
      });

      await this.audit.log(
        {
          actorId: ownerId,
          action: 'BUSINESS_UPDATED',
          entityType: 'Business',
          entityId: id,
          previousData: business,
          newData: updatedBusiness,
        },
        tx,
      );

      return updatedBusiness;
    });
  }

  // --- ADMIN ENDPOINTS ---

  async findAll(paginationDto: PaginationDto) {
    const { page = 1, limit = 20 } = paginationDto;
    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.business.findMany({ skip, take: limit }),
      this.prisma.business.count(),
    ]);

    return createPaginatedResponse(items, total, page, limit);
  }

  async setVerificationStatus(
    id: string,
    adminId: string,
    status: VerificationStatus,
  ) {
    const business = await this.prisma.business.findUnique({ where: { id } });
    if (!business) throw new NotFoundException('Business not found');

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.business.update({
        where: { id },
        data: { verificationStatus: status },
      });

      await this.audit.log(
        {
          actorId: adminId,
          action: `BUSINESS_${status}`,
          entityType: 'Business',
          entityId: id,
          previousData: { verificationStatus: business.verificationStatus },
          newData: { verificationStatus: status },
        },
        tx,
      );

      return updated;
    });
  }

  async setStatus(id: string, adminId: string, status: BusinessStatus) {
    const business = await this.prisma.business.findUnique({ where: { id } });
    if (!business) throw new NotFoundException('Business not found');

    return this.prisma.$transaction(async (tx) => {
      const updated = await tx.business.update({
        where: { id },
        data: { status },
      });

      await this.audit.log(
        {
          actorId: adminId,
          action: `BUSINESS_${status}`,
          entityType: 'Business',
          entityId: id,
          previousData: { status: business.status },
          newData: { status },
        },
        tx,
      );

      return updated;
    });
  }
}
