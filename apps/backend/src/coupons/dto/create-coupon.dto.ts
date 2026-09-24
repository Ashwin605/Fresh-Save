import { IsString, IsNotEmpty, IsOptional, IsEnum, IsNumber, Min, IsBoolean, IsDateString } from 'class-validator';
import { DiscountType } from '@prisma/client';

export class CreateCouponDto {
  @IsString()
  @IsNotEmpty()
  code!: string;

  @IsString()
  @IsNotEmpty()
  title!: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsEnum(DiscountType)
  discountType!: DiscountType;

  @IsNumber()
  @Min(0)
  discountValue!: number;

  @IsNumber()
  @Min(0)
  @IsOptional()
  minimumOrderAmount?: number;

  @IsNumber()
  @Min(0)
  @IsOptional()
  maximumDiscountAmount?: number;

  @IsNumber()
  @Min(1)
  @IsOptional()
  usageLimit?: number;

  @IsNumber()
  @Min(1)
  @IsOptional()
  perUserLimit?: number;

  @IsString()
  @IsOptional()
  shopId?: string;

  @IsDateString()
  startDate!: string;

  @IsDateString()
  expiryDate!: string;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}
