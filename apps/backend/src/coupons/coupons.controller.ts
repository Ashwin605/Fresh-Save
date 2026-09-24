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
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { CouponsService } from './coupons.service';
import { CreateCouponDto } from './dto/create-coupon.dto';
import { UpdateCouponDto } from './dto/update-coupon.dto';
import { ValidateCouponDto } from './dto/validate-coupon.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UserRole } from '@prisma/client';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Coupons')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller()
export class CouponsController {
  constructor(private readonly couponsService: CouponsService) {}

  // --------------------------------------------------
  // ADMIN ENDPOINTS
  // --------------------------------------------------
  @Post('admin/coupons')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Create a new coupon (Admin)' })
  create(@Body() createCouponDto: CreateCouponDto) {
    return this.couponsService.create(createCouponDto);
  }

  @Get('admin/coupons')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'List all coupons (Admin)' })
  findAllAdmin(
    @Query('page') page: string,
    @Query('limit') limit: string,
  ) {
    return this.couponsService.findAllAdmin(
      page ? parseInt(page, 10) : 1,
      limit ? parseInt(limit, 10) : 20
    );
  }

  @Patch('admin/coupons/:id')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Update a coupon (Admin)' })
  update(
    @Param('id') id: string,
    @Body() updateCouponDto: UpdateCouponDto
  ) {
    return this.couponsService.update(id, updateCouponDto);
  }

  @Delete('admin/coupons/:id')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'Deactivate a coupon (Admin)' })
  remove(@Param('id') id: string) {
    return this.couponsService.remove(id);
  }

  // --------------------------------------------------
  // CUSTOMER ENDPOINTS
  // --------------------------------------------------
  @Get('coupons')
  @ApiOperation({ summary: 'Get available coupons for customer' })
  findAllAvailable(@CurrentUser() user: { userId: string; role: UserRole }) {
    return this.couponsService.findAllAvailable(user.userId);
  }

  @Post('coupons/validate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Validate a coupon' })
  validateCoupon(
    @Body() validateCouponDto: ValidateCouponDto,
    @CurrentUser() user: { userId: string; role: UserRole }
  ) {
    return this.couponsService.validateCoupon(
      validateCouponDto.code,
      validateCouponDto.storeId,
      validateCouponDto.subtotal,
      user.userId
    );
  }
}
