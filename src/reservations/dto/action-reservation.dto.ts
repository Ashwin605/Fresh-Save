// ============================================
// FreshSave — Update/Action Reservation DTOs
// ============================================

import { IsOptional, IsString, MaxLength } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class CancelReservationDto {
  @ApiPropertyOptional({
    description: 'Optional reason for cancelling the reservation',
    example: 'Changed my mind',
    maxLength: 255,
  })
  @IsString()
  @MaxLength(255)
  @IsOptional()
  reason?: string;
}

export class RejectReservationDto {
  @ApiPropertyOptional({
    description: 'Optional reason for rejecting the reservation',
    example: 'Stock damaged',
    maxLength: 255,
  })
  @IsString()
  @MaxLength(255)
  @IsOptional()
  reason?: string;
}
