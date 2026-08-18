import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';
import { CustomerRecommendationService } from '../services/customer-recommendation.service';
import { DealRecommendationDto } from '../dto/deal-recommendation.dto';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';
import type { User } from '@prisma/client';

@ApiTags('AI - Customer Recommendations')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.CUSTOMER, UserRole.ADMIN, UserRole.SUPER_ADMIN)
@Controller('ai/recommendations')
export class AiCustomerController {
  constructor(
    private readonly recommendationService: CustomerRecommendationService,
  ) {}

  @Get('deals')
  @ApiOperation({ summary: 'Get personalized AI ranked deals' })
  async getDeals(
    @CurrentUser() user: User,
    @Query() query: DealRecommendationDto,
  ) {
    const deals = await this.recommendationService.recommendDeals(
      user.id,
      query,
    );
    return { success: true, data: deals };
  }
}
