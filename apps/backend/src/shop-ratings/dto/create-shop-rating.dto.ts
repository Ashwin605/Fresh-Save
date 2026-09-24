import { IsInt, Min, Max, IsOptional, IsString, IsUUID, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateShopRatingDto {
  @ApiProperty({ description: 'The ID of the order/reservation being rated' })
  @IsUUID()
  orderId!: string;

  @ApiProperty({ description: 'Rating from 1 to 5', minimum: 1, maximum: 5 })
  @IsInt()
  @Min(1)
  @Max(5)
  rating!: number;

  @ApiPropertyOptional({ description: 'Optional written review', maxLength: 1000 })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  review?: string;
}
