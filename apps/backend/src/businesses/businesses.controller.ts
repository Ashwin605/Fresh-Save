import {
  Controller,
  Post,
  Body,
  Get,
  Patch,
  Param,
  UseGuards,
  Query,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { BusinessesService } from './businesses.service';
import { CreateBusinessDto } from './dto/create-business.dto';
import { UpdateBusinessDto } from './dto/update-business.dto';
import { PaginationDto } from '../common/dto/pagination.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UserRole, VerificationStatus, BusinessStatus } from '@prisma/client';

@ApiTags('Businesses')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('businesses')
export class BusinessesController {
  constructor(private readonly businessesService: BusinessesService) {}

  @Roles(UserRole.SHOP_OWNER)
  @Post()
  @ApiOperation({ summary: 'Create a new business (SHOP_OWNER only)' })
  create(@CurrentUser('id') ownerId: string, @Body() dto: CreateBusinessDto) {
    return this.businessesService.create(ownerId, dto);
  }

  @Roles(UserRole.SHOP_OWNER)
  @Get('my')
  @ApiOperation({ summary: 'Get my business (SHOP_OWNER only)' })
  findMyBusiness(@CurrentUser('id') ownerId: string) {
    return this.businessesService.findMyBusiness(ownerId);
  }

  @Roles(UserRole.SHOP_OWNER, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Get(':id')
  @ApiOperation({ summary: 'Get business by ID' })
  findOne(
    @Param('id') id: string,
    @CurrentUser('id') actorId: string,
    @CurrentUser('role') role: UserRole,
  ) {
    return this.businessesService.findOne(id, actorId, role);
  }

  @Roles(UserRole.SHOP_OWNER)
  @Patch(':id')
  @ApiOperation({ summary: 'Update business (SHOP_OWNER only)' })
  update(
    @Param('id') id: string,
    @CurrentUser('id') ownerId: string,
    @Body() dto: UpdateBusinessDto,
  ) {
    return this.businessesService.update(id, ownerId, dto);
  }
}

@ApiTags('Admin Business Management')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
@Controller('admin/businesses')
export class AdminBusinessesController {
  constructor(private readonly businessesService: BusinessesService) {}

  @Get()
  @ApiOperation({ summary: 'List all businesses' })
  findAll(@Query() paginationDto: PaginationDto) {
    return this.businessesService.findAll(paginationDto);
  }

  @Post(':id/verify')
  @ApiOperation({ summary: 'Mark business as VERIFIED' })
  verify(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.businessesService.setVerificationStatus(
      id,
      adminId,
      VerificationStatus.VERIFIED,
    );
  }

  @Post(':id/reject')
  @ApiOperation({ summary: 'Mark business as REJECTED' })
  reject(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.businessesService.setVerificationStatus(
      id,
      adminId,
      VerificationStatus.REJECTED,
    );
  }

  @Post(':id/suspend')
  @ApiOperation({ summary: 'Mark business as SUSPENDED' })
  suspend(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.businessesService.setStatus(
      id,
      adminId,
      BusinessStatus.SUSPENDED,
    );
  }

  @Post(':id/reactivate')
  @ApiOperation({ summary: 'Mark business as ACTIVE' })
  reactivate(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.businessesService.setStatus(id, adminId, BusinessStatus.ACTIVE);
  }
}
