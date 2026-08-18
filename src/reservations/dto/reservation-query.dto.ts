// ============================================
// FreshSave — Reservation Query DTOs
// ============================================

import {
  IsEnum,
  IsInt,
  IsOptional,
  IsString,
  Min,
  Max,
  IsDateString,
  IsUUID,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { ReservationStatus } from '@prisma/client';

export class BaseReservationQueryDto {
  @ApiPropertyOptional({ enum: ReservationStatus })
  @IsEnum(ReservationStatus)
  @IsOptional()
  status?: ReservationStatus;

  @ApiPropertyOptional({ description: 'Filter by start date (ISO string)' })
  @IsDateString()
  @IsOptional()
  startDate?: string;

  @ApiPropertyOptional({ description: 'Filter by end date (ISO string)' })
  @IsDateString()
  @IsOptional()
  endDate?: string;

  @ApiPropertyOptional({ minimum: 1, default: 1 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @IsOptional()
  page?: number;

  @ApiPropertyOptional({ minimum: 1, maximum: 50, default: 20 })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  @IsOptional()
  limit?: number;
}

export class CustomerReservationQueryDto extends BaseReservationQueryDto {}

export class StoreReservationQueryDto extends BaseReservationQueryDto {
  @ApiPropertyOptional({
    description: 'Filter by reservation code',
    example: 'FS-A1B2C3',
  })
  @IsString()
  @IsOptional()
  reservationCode?: string;
}

export class AdminReservationQueryDto extends BaseReservationQueryDto {
  @ApiPropertyOptional({ description: 'Filter by store ID' })
  @IsUUID()
  @IsOptional()
  storeId?: string;

  @ApiPropertyOptional({ description: 'Filter by business ID' })
  @IsUUID()
  @IsOptional()
  businessId?: string;

  @ApiPropertyOptional({ description: 'Filter by customer ID' })
  @IsUUID()
  @IsOptional()
  customerId?: string;
}
