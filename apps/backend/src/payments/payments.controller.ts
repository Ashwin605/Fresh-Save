import { Controller, Post, Body, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { VerifyPaymentDto } from './dto/verify-payment.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole, User } from '@prisma/client';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('Payments')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.CUSTOMER)
@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('create')
  @ApiOperation({ summary: 'Create a new payment for an order' })
  async createPayment(@CurrentUser() user: User, @Body() dto: CreatePaymentDto) {
    const payment = await this.paymentsService.createPayment(user.id, dto.reservationId);
    return { success: true, data: { payment } };
  }

  @Post(':id/verify')
  @ApiOperation({ summary: 'Verify a payment' })
  async verifyPayment(
    @CurrentUser() user: User, 
    @Param('id') id: string,
    @Body() dto: VerifyPaymentDto
  ) {
    const payment = await this.paymentsService.verifyPayment(user.id, id, dto.simulateStatus);
    return { success: true, data: { payment } };
  }
}
