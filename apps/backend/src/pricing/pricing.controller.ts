import { Controller, Post, Body, HttpCode, HttpStatus, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PricingService } from './pricing.service';
import { CalculateCartDto } from './dto/calculate-cart.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('Cart & Pricing')
@Controller('cart')
export class PricingController {
  constructor(private readonly pricingService: PricingService) {}

  @Post('calculate')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Calculate final cart price server-side' })
  async calculateCartPrice(
    @Body() calculateCartDto: CalculateCartDto,
    @CurrentUser() user: { userId: string }
  ) {
    const result = await this.pricingService.calculateCartPrice({
      customerId: user.userId,
      storeId: calculateCartDto.storeId,
      items: calculateCartDto.items,
      couponCode: calculateCartDto.couponCode,
    });
    
    // Omit the _raw internals from the public API response
    const { _raw, ...publicData } = result;
    
    return {
      success: true,
      data: publicData
    };
  }
}
