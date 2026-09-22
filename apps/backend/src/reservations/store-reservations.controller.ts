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
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { ReservationsService } from './reservations.service';
import { StoreReservationQueryDto } from './dto/reservation-query.dto';
import { RejectReservationDto } from './dto/action-reservation.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';
import type { User } from '@prisma/client';
import { CurrentUser } from '../auth/decorators/current-user.decorator';

@ApiTags('Store Reservations')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.SHOP_OWNER, UserRole.SHOP_STAFF)
@Controller('stores')
export class StoreReservationsController {
  constructor(private readonly reservationsService: ReservationsService) {}

  @Get(':storeId/reservations')
  @ApiOperation({ summary: 'List reservations for a store' })
  async findAll(
    @CurrentUser() user: User,
    @Param('storeId') storeId: string,
    @Query() query: StoreReservationQueryDto,
  ) {
    const result = await this.reservationsService.getStoreReservations(
      user.id,
      storeId,
      query,
    );
    return { success: true, data: result };
  }

  @Post('reservations/:id/confirm')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Confirm a reservation' })
  async confirm(@CurrentUser() user: User, @Param('id') id: string) {
    const reservation = await this.reservationsService.confirmReservation(
      user.id,
      id,
    );
    return { success: true, data: { reservation } };
  }

  @Post('reservations/:id/reject')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Reject a reservation' })
  async reject(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() dto: RejectReservationDto,
  ) {
    const reservation = await this.reservationsService.rejectReservation(
      user.id,
      id,
      dto.reason,
    );
    return { success: true, data: { reservation } };
  }

  @Post('reservations/:id/ready')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Mark reservation as ready for pickup' })
  async markReady(@CurrentUser() user: User, @Param('id') id: string) {
    const reservation = await this.reservationsService.markReady(user.id, id);
    return { success: true, data: { reservation } };
  }

  @Post('reservations/:id/complete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Complete a reservation (customer picked up)' })
  async complete(@CurrentUser() user: User, @Param('id') id: string) {
    const reservation = await this.reservationsService.completeReservation(
      user.id,
      id,
    );
    return { success: true, data: { reservation } };
  }
}
