// ============================================
// FreshSave — Nearby Stores Query DTO
// ============================================

import {
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  Min,
  Max,
  MaxLength,
  IsInt,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class NearbyStoresQueryDto {
  @ApiProperty({
    description: 'Customer latitude',
    example: 12.9165,
    minimum: -90,
    maximum: 90,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(-90)
  @Max(90)
  latitude!: number;

  @ApiProperty({
    description: 'Customer longitude',
    example: 79.1325,
    minimum: -180,
    maximum: 180,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(-180)
  @Max(180)
  longitude!: number;

  @ApiPropertyOptional({
    description: 'Search radius in kilometers',
    example: 5,
    minimum: 0.1,
    maximum: 50,
    default: 5,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(0.1)
  @Max(50)
  @IsOptional()
  radius?: number;

  @ApiPropertyOptional({
    description: 'Search by store name',
    example: 'FreshMart',
    maxLength: 100,
  })
  @IsString()
  @MaxLength(100)
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({
    description: 'Filter stores that have products in this category',
    example: 'uuid-here',
  })
  @IsUUID()
  @IsOptional()
  categoryId?: string;

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
