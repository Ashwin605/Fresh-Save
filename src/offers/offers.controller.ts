import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { OffersService } from './offers.service';
import { CreateOfferDto } from './dto/create-offer.dto';
import { UpdateOfferDto } from './dto/update-offer.dto';
import { OfferQueryDto } from './dto/offer-query.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { UserRole, OfferStatus } from '@prisma/client';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Offers')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Controller()
export class OffersController {
  constructor(private readonly offersService: OffersService) {}

  @Post('inventory/:inventoryId/offers')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Create a new offer for an inventory batch' })
  create(
    @Param('inventoryId') inventoryId: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Body() createOfferDto: CreateOfferDto,
  ) {
    return this.offersService.create(
      inventoryId,
      user.userId,
      user.role,
      createOfferDto,
    );
  }

  @Get('stores/:storeId/offers')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'List offers for a specific store' })
  findAllByStore(
    @Param('storeId') storeId: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Query() query: OfferQueryDto,
  ) {
    return this.offersService.findAll(storeId, user.userId, user.role, query);
  }

  @Get('admin/offers')
  @Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
  @ApiOperation({ summary: 'List all offers globally (Admin only)' })
  findAllAdmin(@Query() query: OfferQueryDto) {
    return this.offersService.findAllAdmin(query);
  }

  @Get('offers/:id')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Get details of an offer' })
  findOne(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
  ) {
    return this.offersService.findOne(id, user.userId, user.role);
  }

  @Patch('offers/:id')
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Update an offer' })
  update(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
    @Body() updateOfferDto: UpdateOfferDto,
  ) {
    return this.offersService.update(
      id,
      user.userId,
      user.role,
      updateOfferDto,
    );
  }

  @Post('offers/:id/activate')
  @HttpCode(HttpStatus.OK)
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Manually activate an offer' })
  activate(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
  ) {
    return this.offersService.updateStatus(
      id,
      OfferStatus.ACTIVE,
      'OFFER_ACTIVATED',
      user.userId,
      user.role,
    );
  }

  @Post('offers/:id/pause')
  @HttpCode(HttpStatus.OK)
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Manually pause an offer' })
  pause(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
  ) {
    return this.offersService.updateStatus(
      id,
      OfferStatus.PAUSED,
      'OFFER_PAUSED',
      user.userId,
      user.role,
    );
  }

  @Post('offers/:id/cancel')
  @HttpCode(HttpStatus.OK)
  @Roles(
    UserRole.SHOP_OWNER,
    UserRole.SHOP_STAFF,
    UserRole.ADMIN,
    UserRole.SUPER_ADMIN,
  )
  @ApiOperation({ summary: 'Manually cancel an offer' })
  cancel(
    @Param('id') id: string,
    @CurrentUser() user: { userId: string; role: UserRole },
  ) {
    return this.offersService.updateStatus(
      id,
      OfferStatus.CANCELLED,
      'OFFER_CANCELLED',
      user.userId,
      user.role,
    );
  }
}
