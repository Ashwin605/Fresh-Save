import { IsArray, IsNotEmpty, IsOptional, IsString, IsUUID, ValidateNested, ArrayMinSize, Min } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CalculateCartItemDto {
  @ApiProperty({ description: 'The UUID of the inventory item' })
  @IsUUID()
  @IsNotEmpty()
  inventoryId!: string;

  @ApiProperty({ description: 'The quantity to calculate for', minimum: 1 })
  @Type(() => Number)
  @Min(1)
  quantity!: number;
}

export class CalculateCartDto {
  @ApiProperty({ description: 'The UUID of the store' })
  @IsUUID()
  @IsNotEmpty()
  storeId!: string;

  @ApiProperty({ type: [CalculateCartItemDto] })
  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => CalculateCartItemDto)
  items!: CalculateCartItemDto[];

  @ApiPropertyOptional({ description: 'Coupon code to apply' })
  @IsString()
  @IsOptional()
  couponCode?: string;
}
