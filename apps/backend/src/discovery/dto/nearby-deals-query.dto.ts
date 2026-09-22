// ============================================
// FreshSave — Nearby Deals Query DTO
// ============================================

import {
  IsNumber,
  IsOptional,
  IsString,
  IsUUID,
  IsIn,
  Min,
  Max,
  MaxLength,
  IsInt,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class NearbyDealsQueryDto {
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
    description: 'Filter by category ID (includes child categories)',
    example: 'uuid-here',
  })
  @IsUUID()
  @IsOptional()
  categoryId?: string;

  @ApiPropertyOptional({
    description: 'Search by product name or brand',
    example: 'milk',
    maxLength: 100,
  })
  @IsString()
  @MaxLength(100)
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({
    description: 'Filter by specific store ID',
    example: 'uuid-here',
  })
  @IsUUID()
  @IsOptional()
  storeId?: string;

  @ApiPropertyOptional({
    description: 'Minimum discount percentage (effective)',
    example: 30,
    minimum: 0,
    maximum: 100,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(100)
  @IsOptional()
  minDiscount?: number;

  @ApiPropertyOptional({
    description: 'Maximum discounted price in ₹',
    example: 100,
    minimum: 0,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @IsOptional()
  maxPrice?: number;

  @ApiPropertyOptional({
    description: 'Show items expiring within N hours',
    example: 24,
    minimum: 1,
  })
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  @IsOptional()
  expiryWithinHours?: number;

  @ApiPropertyOptional({
    description: 'Sort by field',
    enum: ['distance', 'discount', 'price', 'expiry', 'newest', 'relevance'],
    default: 'relevance',
  })
  @IsString()
  @IsIn(['distance', 'discount', 'price', 'expiry', 'newest', 'relevance'])
  @IsOptional()
  sortBy?: string;

  @ApiPropertyOptional({
    description: 'Sort direction',
    enum: ['asc', 'desc'],
    default: 'asc',
  })
  @IsString()
  @IsIn(['asc', 'desc'])
  @IsOptional()
  sortOrder?: 'asc' | 'desc';

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
