import {
  Controller,
  Post,
  Body,
  Get,
  Patch,
  Param,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { StoresService } from './stores.service';
import { CreateStoreDto } from './dto/create-store.dto';
import { UpdateStoreDto } from './dto/update-store.dto';
import { AddStoreStaffDto } from './dto/add-store-staff.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UserRole, VerificationStatus, StoreStatus } from '@prisma/client';

@ApiTags('Stores')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller()
export class StoresController {
  constructor(private readonly storesService: StoresService) {}

  @Roles(UserRole.SHOP_OWNER)
  @Post('businesses/:businessId/stores')
  @ApiOperation({ summary: 'Create a new store (SHOP_OWNER only)' })
  create(
    @Param('businessId') businessId: string,
    @CurrentUser('id') ownerId: string,
    @Body() dto: CreateStoreDto,
  ) {
    return this.storesService.create(businessId, ownerId, dto);
  }

  @Roles(UserRole.SHOP_OWNER)
  @Get('businesses/:businessId/stores')
  @ApiOperation({ summary: 'Get all stores for a business (SHOP_OWNER only)' })
  findBusinessStores(
    @Param('businessId') businessId: string,
    @CurrentUser('id') ownerId: string,
  ) {
    return this.storesService.findBusinessStores(businessId, ownerId);
  }

  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @Get('stores/:storeId')
  @ApiOperation({ summary: 'Get store by ID' })
  findOne(
    @Param('storeId') storeId: string,
    @CurrentUser('id') actorId: string,
    @CurrentUser('role') role: UserRole,
  ) {
    return this.storesService.findOne(storeId, actorId, role);
  }

  @Roles(UserRole.SHOP_OWNER)
  @Patch('stores/:storeId')
  @ApiOperation({ summary: 'Update store (SHOP_OWNER only)' })
  update(
    @Param('storeId') storeId: string,
    @CurrentUser('id') ownerId: string,
    @Body() dto: UpdateStoreDto,
  ) {
    return this.storesService.update(storeId, ownerId, dto);
  }
}

@ApiTags('Store Staff')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('stores/:storeId/staff')
export class StoreStaffController {
  constructor(private readonly storesService: StoresService) {}

  @Roles(UserRole.SHOP_OWNER)
  @Post()
  @ApiOperation({ summary: 'Add staff to store (SHOP_OWNER only)' })
  addStaff(
    @Param('storeId') storeId: string,
    @CurrentUser('id') ownerId: string,
    @Body() dto: AddStoreStaffDto,
  ) {
    return this.storesService.addStaff(storeId, ownerId, dto);
  }

  @Roles(UserRole.SHOP_OWNER, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Get()
  @ApiOperation({ summary: 'List staff for store' })
  findStaff(
    @Param('storeId') storeId: string,
    @CurrentUser('id') ownerId: string,
  ) {
    return this.storesService.findStaff(storeId, ownerId);
  }

  @Roles(UserRole.SHOP_OWNER)
  @Delete(':staffId')
  @ApiOperation({ summary: 'Remove staff from store (SHOP_OWNER only)' })
  removeStaff(
    @Param('storeId') storeId: string,
    @Param('staffId') staffId: string,
    @CurrentUser('id') ownerId: string,
  ) {
    return this.storesService.removeStaff(storeId, staffId, ownerId);
  }
}

@ApiTags('Admin Store Management')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
@Controller('admin/stores')
export class AdminStoresController {
  constructor(private readonly storesService: StoresService) {}

  @Post(':id/verify')
  @ApiOperation({ summary: 'Mark store as VERIFIED' })
  verify(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.storesService.setVerificationStatus(
      id,
      adminId,
      VerificationStatus.VERIFIED,
    );
  }

  @Post(':id/reject')
  @ApiOperation({ summary: 'Mark store as REJECTED' })
  reject(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.storesService.setVerificationStatus(
      id,
      adminId,
      VerificationStatus.REJECTED,
    );
  }

  @Post(':id/suspend')
  @ApiOperation({ summary: 'Mark store as SUSPENDED' })
  suspend(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.storesService.setStatus(id, adminId, StoreStatus.SUSPENDED);
  }

  @Post(':id/reactivate')
  @ApiOperation({ summary: 'Mark store as ACTIVE' })
  reactivate(@Param('id') id: string, @CurrentUser('id') adminId: string) {
    return this.storesService.setStatus(id, adminId, StoreStatus.ACTIVE);
  }
}
