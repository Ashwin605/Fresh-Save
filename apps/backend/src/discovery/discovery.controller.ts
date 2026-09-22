// ============================================
// FreshSave — Discovery Controller
// ============================================

import { Controller, Get, Param, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiParam } from '@nestjs/swagger';
import { DiscoveryService } from './discovery.service';
import { NearbyDealsQueryDto } from './dto/nearby-deals-query.dto';
import { NearbyStoresQueryDto } from './dto/nearby-stores-query.dto';
import { ProductDiscoveryQueryDto } from './dto/product-discovery-query.dto';
import { DealDetailQueryDto } from './dto/deal-detail-query.dto';

/**
 * Public discovery controller.
 *
 * These endpoints are accessible WITHOUT authentication.
 * They are designed for customer-facing product and deal discovery.
 *
 * NO private management data (owner, staff, audit, internal IDs)
 * is exposed through these endpoints.
 */
@ApiTags('Discovery')
@Controller('discovery')
export class DiscoveryController {
  constructor(private readonly discoveryService: DiscoveryService) {}

  @Get('deals/nearby')
  @ApiOperation({
    summary: 'Find nearby deals',
    description:
      'Discover active discounted products near a location. ' +
      'Returns deals within the specified radius sorted by relevance, ' +
      'with distance calculated server-side. ' +
      'Supports filtering by category, search, discount, price, and expiry.',
  })
  findNearbyDeals(@Query() query: NearbyDealsQueryDto) {
    return this.discoveryService.findNearbyDeals(query);
  }

  @Get('stores/nearby')
  @ApiOperation({
    summary: 'Find nearby stores',
    description:
      'Discover verified stores near a location. ' +
      'Returns stores within the specified radius ordered by distance, ' +
      'with an active deal count indicator.',
  })
  findNearbyStores(@Query() query: NearbyStoresQueryDto) {
    return this.discoveryService.findNearbyStores(query);
  }

  @Get('products')
  @ApiOperation({
    summary: 'Browse products',
    description:
      'Public product catalog discovery. ' +
      'Supports search, category filtering, brand filtering, and pagination.',
  })
  findProducts(@Query() query: ProductDiscoveryQueryDto) {
    return this.discoveryService.findProducts(query);
  }

  @Get('categories')
  @ApiOperation({
    summary: 'Browse categories',
    description:
      'Returns active categories with their children for customer browsing.',
  })
  findCategories() {
    return this.discoveryService.findCategories();
  }

  @Get('deals/:offerId')
  @ApiOperation({
    summary: 'Get deal details',
    description:
      'Get full details of a specific deal. ' +
      'Optionally provide latitude/longitude to include distance calculation. ' +
      'Returns 404 if the deal is expired, out of stock, or otherwise unavailable.',
  })
  @ApiParam({
    name: 'offerId',
    description: 'The offer ID',
    type: String,
  })
  findDealDetail(
    @Param('offerId') offerId: string,
    @Query() query: DealDetailQueryDto,
  ) {
    return this.discoveryService.findDealDetail(offerId, query);
  }
}
