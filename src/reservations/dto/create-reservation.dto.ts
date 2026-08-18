// ============================================
// FreshSave — Create Reservation DTO
// ============================================

import {
  IsArray,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsUUID,
  Min,
  ValidateNested,
  ArrayMinSize,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class ReservationItemDto {
  @ApiProperty({
    description: 'The UUID of the inventory item to reserve',
    example: 'uuid-here',
  })
  @IsUUID()
  @IsNotEmpty()
  inventoryId!: string;

  @ApiProperty({
    description: 'The quantity to reserve',
    example: 2,
    minimum: 1,
  })
  @Type(() => Number)
  @Min(1)
  quantity!: number;
}

export class CreateReservationDto {
  @ApiProperty({
    description: 'The UUID of the store where the reservation is being made',
    example: 'uuid-here',
  })
  @IsUUID()
  @IsNotEmpty()
  storeId!: string;

  @ApiProperty({
    description: 'List of items to reserve',
    type: [ReservationItemDto],
  })
  @IsArray()
  @ArrayMinSize(1)
  @ValidateNested({ each: true })
  @Type(() => ReservationItemDto)
  items!: ReservationItemDto[];

  @ApiPropertyOptional({
    description: 'Optional notes for the store staff',
    example: 'I will pick this up around 5 PM.',
  })
  @IsString()
  @IsOptional()
  notes?: string;
}
