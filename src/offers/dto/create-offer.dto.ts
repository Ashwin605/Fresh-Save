import {
  IsNotEmpty,
  IsOptional,
  IsString,
  IsEnum,
  IsNumber,
  Min,
  IsDateString,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { DiscountType } from '@prisma/client';

export class CreateOfferDto {
  @ApiPropertyOptional({ description: 'Title of the offer' })
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional({ description: 'Description of the offer' })
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({
    enum: DiscountType,
    description: 'Percentage or fixed amount',
  })
  @IsNotEmpty()
  @IsEnum(DiscountType)
  discountType!: DiscountType;

  @ApiProperty({ description: 'The value of the discount', example: 25 })
  @IsNotEmpty()
  @IsNumber()
  @Min(0.01)
  discountValue!: number;

  @ApiProperty({ description: 'Offer start time in ISO-8601 format' })
  @IsNotEmpty()
  @IsDateString()
  startsAt!: string;

  @ApiProperty({
    description:
      'Offer end time in ISO-8601 format (must be <= inventory expiry)',
  })
  @IsNotEmpty()
  @IsDateString()
  endsAt!: string;
}
