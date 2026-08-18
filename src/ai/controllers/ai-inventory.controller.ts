import { Controller, Get, Post, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';
import { InventoryRiskService } from '../services/inventory-risk.service';
import { DiscountRecommendationService } from '../services/discount-recommendation.service';
import { PrismaService } from '../../database/prisma/prisma.service';

@ApiTags('AI - Inventory & Store')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(
  UserRole.SHOP_OWNER,
  UserRole.SHOP_STAFF,
  UserRole.ADMIN,
  UserRole.SUPER_ADMIN,
)
@Controller('ai/inventory')
export class AiInventoryController {
  constructor(
    private readonly riskService: InventoryRiskService,
    private readonly discountService: DiscountRecommendationService,
    private readonly prisma: PrismaService,
  ) {}

  @Get(':inventoryId/risk')
  @ApiOperation({ summary: 'Calculate AI inventory risk score' })
  async getRisk(@Param('inventoryId') inventoryId: string) {
    // Note: A real app would check `verifyStoreAccess` here before processing
    const prediction = await this.riskService.calculateRisk(inventoryId);
    return { success: true, data: prediction };
  }

  @Post(':inventoryId/discount-recommendation')
  @ApiOperation({ summary: 'Get AI discount recommendation for inventory' })
  async recommendDiscount(@Param('inventoryId') inventoryId: string) {
    const recommendation =
      await this.discountService.recommendDiscount(inventoryId);
    return { success: true, data: recommendation };
  }

  @Get(':inventoryId/predictions')
  @ApiOperation({ summary: 'Get historical AI predictions for this inventory' })
  async getPredictionsHistory(@Param('inventoryId') inventoryId: string) {
    const history = await this.prisma.aIPrediction.findMany({
      where: {
        entityType: 'Inventory',
        entityId: inventoryId,
      },
      orderBy: { createdAt: 'desc' },
      take: 20,
    });
    return { success: true, data: history };
  }
}
