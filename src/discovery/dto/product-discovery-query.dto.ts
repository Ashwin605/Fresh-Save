// ============================================
// FreshSave — Product Discovery Query DTO
// ============================================

import {
  IsOptional,
  IsString,
  IsUUID,
  IsIn,
  MaxLength,
  IsInt,
  Min,
  Max,
  IsNumber,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class ProductDiscoveryQueryDto {
  @ApiPropertyOptional({
    description: 'Customer latitude',
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
    description: 'Customer longitude',
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
    description: 'Search by product name or brand',
    example: 'milk',
    maxLength: 100,
  })
  @IsString()
  @MaxLength(100)
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({
    description: 'Filter by category ID',
    example: 'uuid-here',
  })
  @IsUUID()
  @IsOptional()
  categoryId?: string;

  @ApiPropertyOptional({
    description: 'Filter by brand name (case-insensitive)',
    example: 'Amul',
    maxLength: 100,
  })
  @IsString()
  @MaxLength(100)
  @IsOptional()
  brand?: string;

  @ApiPropertyOptional({
    description: 'Sort by field',
    enum: ['name', 'brand', 'newest'],
    default: 'newest',
  })
  @IsString()
  @IsIn(['name', 'brand', 'newest'])
  @IsOptional()
  sortBy?: string;

  @ApiPropertyOptional({
    description: 'Sort direction',
    enum: ['asc', 'desc'],
    default: 'desc',
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
