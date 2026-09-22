import {
  IsNotEmpty,
  IsOptional,
  IsString,
  IsNumber,
  IsDateString,
  Min,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateInventoryDto {
  @ApiProperty({ example: 'uuid-product-id' })
  @IsString()
  @IsNotEmpty()
  productId!: string;

  @ApiPropertyOptional({ example: 'BATCH-2023-XYZ' })
  @IsString()
  @IsOptional()
  @MaxLength(100)
  batchNumber?: string;

  @ApiProperty({ example: 50 })
  @IsNumber()
  @Min(0)
  stockQuantity!: number;

  @ApiProperty({ example: 100.0 })
  @IsNumber()
  @Min(0)
  originalPrice!: number;

  @ApiProperty({ example: 80.0 })
  @IsNumber()
  @Min(0)
  sellingPrice!: number;

  @ApiPropertyOptional({ example: '2023-01-01T00:00:00Z' })
  @IsDateString()
  @IsOptional()
  manufacturingDate?: string;

  @ApiProperty({ example: '2026-08-10T00:00:00Z' })
  @IsDateString()
  @IsNotEmpty()
  expiryDate!: string;
}
