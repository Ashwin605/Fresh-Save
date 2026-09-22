import { Controller, Get, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole, PredictionType } from '@prisma/client';
import { PrismaService } from '../../database/prisma/prisma.service';

@ApiTags('AI - Admin Insights')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
@Controller('admin/ai')
export class AiAdminController {
  constructor(private readonly prisma: PrismaService) {}

  @Get('insights')
  @ApiOperation({ summary: 'Get aggregate platform AI insights' })
  async getInsights() {
    const totalPredictions = await this.prisma.aIPrediction.count();

    // Aggregations using group by
    const byType = await this.prisma.aIPrediction.groupBy({
      by: ['predictionType'],
      _count: { _all: true },
    });

    const averageConfidence = await this.prisma.aIPrediction.aggregate({
      _avg: { confidence: true },
    });

    return {
      success: true,
      data: {
        totalPredictions,
        breakdownByType: byType,
        averageConfidence: averageConfidence._avg.confidence,
        activeModelVersion: 'rules-v1', // hardcoded for this milestone
      },
    };
  }
}
