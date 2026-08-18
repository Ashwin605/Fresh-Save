// ============================================
// FreshSave — Deal Detail Query DTO
// ============================================

import { IsNumber, IsOptional, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class DealDetailQueryDto {
  @ApiPropertyOptional({
    description:
      'Customer latitude (optional — if provided with longitude, distance will be calculated)',
    example: 12.9165,
    minimum: -90,
    maximum: 90,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  @IsOptional()
  latitude?: number;

  @ApiPropertyOptional({
    description:
      'Customer longitude (optional — if provided with latitude, distance will be calculated)',
    example: 79.1325,
    minimum: -180,
    maximum: 180,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  @IsOptional()
  longitude?: number;
}
