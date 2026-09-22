import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
  UseGuards,
  Headers,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiHeader,
} from '@nestjs/swagger';
import { ReservationsService } from './reservations.service';
import { CreateReservationDto } from './dto/create-reservation.dto';
import { CancelReservationDto } from './dto/action-reservation.dto';
import { CustomerReservationQueryDto } from './dto/reservation-query.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';
import type { User } from '@prisma/client';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('Customer Reservations')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.CUSTOMER)
@Controller('reservations')
export class ReservationsController {
  constructor(private readonly reservationsService: ReservationsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({ summary: 'Create a new reservation' })
  @ApiHeader({
    name: 'Idempotency-Key',
    required: false,
    description: 'Client-generated key for safe retries',
  })
  async create(
    @CurrentUser() user: User,
    @Body() dto: CreateReservationDto,
    @Headers('Idempotency-Key') idempotencyKey?: string,
  ) {
    const reservation = await this.reservationsService.createReservation(
      user.id,
      dto,
      idempotencyKey,
    );
    return { success: true, data: { reservation } };
  }

  @Get()
  @ApiOperation({ summary: 'Get customer reservations history' })
  async findAll(
    @CurrentUser() user: User,
    @Query() query: CustomerReservationQueryDto,
  ) {
    const result = await this.reservationsService.getCustomerReservations(
      user.id,
      query,
    );
    return { success: true, data: result };
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get customer reservation details' })
  async findOne(@CurrentUser() user: User, @Param('id') id: string) {
    const reservation =
      await this.reservationsService.getCustomerReservationById(user.id, id);
    return { success: true, data: { reservation } };
  }

  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Cancel a pending or confirmed reservation' })
  async cancel(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() dto: CancelReservationDto,
  ) {
    const reservation = await this.reservationsService.cancelReservation(
      user.id,
      id,
      dto.reason,
    );
    return { success: true, data: { reservation } };
  }
}
