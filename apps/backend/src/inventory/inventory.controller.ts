import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
} from '@nestjs/common';
import { InventoryService } from './inventory.service';
import { CreateInventoryDto } from './dto/create-inventory.dto';
import { UpdateInventoryDto } from './dto/update-inventory.dto';
import { AdjustStockDto } from './dto/adjust-stock.dto';
import { InventoryQueryDto } from './dto/inventory-query.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiResponse,
} from '@nestjs/swagger';

@ApiTags('Inventory')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller()
export class InventoryController {
  constructor(private readonly inventoryService: InventoryService) {}

  @Post('stores/:storeId/inventory')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Create new inventory batch for a store' })
  @ApiResponse({
    status: 201,
    description: 'Inventory batch created successfully',
  })
  create(
    @Param('storeId') storeId: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Body() createInventoryDto: CreateInventoryDto,
  ) {
    return this.inventoryService.create(
      storeId,
      user.userId,
      user.role,
      createInventoryDto,
    );
  }

  @Get('stores/:storeId/inventory')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({
    summary: 'List inventory batches for a store with filtering',
  })
  findAll(
    @Param('storeId') storeId: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Query() query: InventoryQueryDto,
  ) {
    return this.inventoryService.findAll(
      storeId,
      user.userId,
      user.role,
      query,
    );
  }

  @Get('inventory/:id')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get details of a specific inventory batch' })
  findOne(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
  ) {
    return this.inventoryService.findOne(id, user.userId, user.role);
  }

  @Patch('inventory/:id')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({
    summary: 'Update pricing, batch number, or dates of an inventory batch',
  })
  update(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Body() updateInventoryDto: UpdateInventoryDto,
  ) {
    return this.inventoryService.update(
      id,
      user.userId,
      user.role,
      updateInventoryDto,
    );
  }

  @Post('inventory/:id/adjust-stock')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Adjust stock safely for an inventory batch' })
  adjustStock(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Body() adjustStockDto: AdjustStockDto,
  ) {
    return this.inventoryService.adjustStock(
      id,
      user.userId,
      user.role,
      adjustStockDto,
    );
  }

  @Delete('inventory/:id')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Archive (soft delete) an inventory batch' })
  remove(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
  ) {
    return this.inventoryService.remove(id, user.userId, user.role);
  }
}
