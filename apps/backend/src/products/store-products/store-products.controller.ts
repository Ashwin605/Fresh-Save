import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
  Query,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth, ApiResponse } from '@nestjs/swagger';
import { StoreProductsService } from './store-products.service';
import { CreateStoreProductDto } from './dto/create-store-product.dto';
import { UpdateStoreProductDto } from './dto/update-store-product.dto';
import { StoreProductQueryDto } from './dto/store-product-query.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import { UserRole } from '@prisma/client';

@ApiTags('Store Products')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller('stores/:storeId/products')
export class StoreProductsController {
  constructor(private readonly storeProductsService: StoreProductsService) {}

  @Roles(UserRole.SHOP_OWNER, UserRole.SHOP_STAFF, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Get()
  @ApiOperation({ summary: 'List products belonging to a store' })
  @ApiResponse({ status: 200, description: 'Paginated list of store products' })
  findAll(
    @Param('storeId') storeId: string,
    @CurrentUser() user: { id: string; userId: string; role: UserRole },
    @Query() query: StoreProductQueryDto,
  ) {
    const actorId = user.id || user.userId;
    return this.storeProductsService.findAll(storeId, actorId, user.role, query);
  }

  @Roles(UserRole.SHOP_OWNER, UserRole.SHOP_STAFF, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Get(':identifier')
  @ApiOperation({ summary: 'Get details of a specific store product' })
  findOne(
    @Param('storeId') storeId: string,
    @Param('identifier') identifier: string,
    @CurrentUser() user: { id: string; userId: string; role: UserRole },
  ) {
    const actorId = user.id || user.userId;
    return this.storeProductsService.findOne(storeId, identifier, actorId, user.role);
  }

  @Roles(UserRole.SHOP_OWNER, UserRole.SHOP_STAFF, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Post()
  @ApiOperation({ summary: 'Add a new product with stock and pricing to a store' })
  @ApiResponse({ status: 201, description: 'Store product created and stocked' })
  create(
    @Param('storeId') storeId: string,
    @CurrentUser() user: { id: string; userId: string; role: UserRole },
    @Body() dto: CreateStoreProductDto,
  ) {
    const actorId = user.id || user.userId;
    return this.storeProductsService.create(storeId, actorId, user.role, dto);
  }

  @Roles(UserRole.SHOP_OWNER, UserRole.SHOP_STAFF, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Patch(':identifier')
  @ApiOperation({ summary: 'Update store product pricing, inventory, or product attributes' })
  update(
    @Param('storeId') storeId: string,
    @Param('identifier') identifier: string,
    @CurrentUser() user: { id: string; userId: string; role: UserRole },
    @Body() dto: UpdateStoreProductDto,
  ) {
    const actorId = user.id || user.userId;
    return this.storeProductsService.update(storeId, identifier, actorId, user.role, dto);
  }

  @Roles(UserRole.SHOP_OWNER, UserRole.SHOP_STAFF, UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @Delete(':identifier')
  @ApiOperation({ summary: 'Remove/archive product from store catalog' })
  remove(
    @Param('storeId') storeId: string,
    @Param('identifier') identifier: string,
    @CurrentUser() user: { id: string; userId: string; role: UserRole },
  ) {
    const actorId = user.id || user.userId;
    return this.storeProductsService.remove(storeId, identifier, actorId, user.role);
  }
}
