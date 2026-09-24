import { Controller, Post, Get, Body, Param, Query, UseGuards, ParseIntPipe, DefaultValuePipe } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ShopRatingsService } from './shop-ratings.service';
import { CreateShopRatingDto } from './dto/create-shop-rating.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('Shop Ratings')
@Controller('shops/:shopId')
export class ShopRatingsController {
  constructor(private readonly shopRatingsService: ShopRatingsService) {}

  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @Post('ratings')
  @ApiOperation({ summary: 'Rate a shop' })
  createRating(
    @Param('shopId') shopId: string,
    @CurrentUser('id') customerId: string,
    @Body() dto: CreateShopRatingDto,
  ) {
    return this.shopRatingsService.createRating(shopId, customerId, dto);
  }

  @Get('ratings')
  @ApiOperation({ summary: 'Get shop ratings' })
  getRatings(
    @Param('shopId') shopId: string,
    @Query('page', new DefaultValuePipe(1), ParseIntPipe) page: number,
    @Query('limit', new DefaultValuePipe(10), ParseIntPipe) limit: number,
  ) {
    return this.shopRatingsService.getRatings(shopId, page, limit);
  }

  @Get('rating-summary')
  @ApiOperation({ summary: 'Get shop rating summary' })
  getRatingSummary(@Param('shopId') shopId: string) {
    return this.shopRatingsService.getRatingSummary(shopId);
  }
}
