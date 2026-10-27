import {
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
  IsNumber,
  IsPositive,
  IsInt,
  Min,
  IsDateString,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateStoreProductDto {
  @ApiProperty({ example: 'Amul Gold Full Cream Milk 1L' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  name!: string;

  @ApiProperty({ example: 'uuid-of-dairy-category' })
  @IsString()
  @IsNotEmpty()
  categoryId!: string;

  @ApiPropertyOptional({ example: 'Pasteurized homogenized full cream milk' })
  @IsString()
  @IsOptional()
  @MaxLength(1000)
  description?: string;

  @ApiPropertyOptional({ example: 'Amul' })
  @IsString()
  @IsOptional()
  @MaxLength(100)
  brand?: string;

  @ApiPropertyOptional({ example: 'SKU-AMUL-GOLD-1L' })
  @IsString()
  @IsOptional()
  @MaxLength(100)
  sku?: string;

  @ApiPropertyOptional({ example: '8901262010053' })
  @IsString()
  @IsOptional()
  @MaxLength(50)
  barcode?: string;

  @ApiPropertyOptional({ example: '/public/uploads/products/amul-milk.jpg' })
  @IsString()
  @IsOptional()
  image?: string;

  @ApiPropertyOptional({ example: '1 L' })
  @IsString()
  @IsOptional()
  @MaxLength(50)
  unit?: string;

  @ApiProperty({ example: 64.0 })
  @Type(() => Number)
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  sellingPrice!: number;

  @ApiProperty({ example: 68.0 })
  @Type(() => Number)
  @IsNumber({ maxDecimalPlaces: 2 })
  @IsPositive()
  originalPrice!: number;

  @ApiProperty({ example: 30 })
  @Type(() => Number)
  @IsInt()
  @Min(0)
  initialStockQuantity!: number;

  @ApiProperty({ example: '2026-11-01T00:00:00.000Z' })
  @IsDateString()
  expiryDate!: string;

  @ApiPropertyOptional({ example: '2026-10-20T00:00:00.000Z' })
  @IsDateString()
  @IsOptional()
  manufacturingDate?: string;

  @ApiPropertyOptional({ example: 'BATCH-2026-10A' })
  @IsString()
  @IsOptional()
  @MaxLength(100)
  batchNumber?: string;

  @ApiPropertyOptional({ description: 'Existing master product ID if linking catalog' })
  @IsString()
  @IsOptional()
  productId?: string;
}
