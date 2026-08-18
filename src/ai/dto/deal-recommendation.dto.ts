import { IsNumber, IsOptional, Min, Max } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';

export class DealRecommendationDto {
  @ApiProperty({ description: 'Customer latitude' })
  @IsNumber()
  @Type(() => Number)
  latitude!: number;

  @ApiProperty({ description: 'Customer longitude' })
  @IsNumber()
  @Type(() => Number)
  longitude!: number;

  @ApiPropertyOptional({
    description: 'Search radius in kilometers',
    default: 20,
  })
  @IsOptional()
  @IsNumber()
  @Type(() => Number)
  @Min(1)
  @Max(100)
  radiusKm?: number = 20;
}
