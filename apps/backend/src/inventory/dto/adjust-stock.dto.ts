import {
  IsNotEmpty,
  IsOptional,
  IsString,
  IsNumber,
  IsEnum,
  Min,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { StockMovementType } from '@prisma/client';

export enum AdjustStockAction {
  ADD = 'ADD',
  REMOVE = 'REMOVE',
  SET = 'SET',
}

export class AdjustStockDto {
  @ApiProperty({ enum: AdjustStockAction, example: AdjustStockAction.ADD })
  @IsEnum(AdjustStockAction)
  @IsNotEmpty()
  action!: AdjustStockAction;

  @ApiProperty({ example: 10 })
  @IsNumber()
  @Min(0)
  @IsNotEmpty()
  quantity!: number;

  @ApiPropertyOptional({ example: 'Restocking arrived' })
  @IsString()
  @IsOptional()
  @MaxLength(255)
  reason?: string;

  @ApiPropertyOptional({
    enum: StockMovementType,
    example: StockMovementType.ADJUSTMENT,
  })
  @IsEnum(StockMovementType)
  @IsOptional()
  movementType?: StockMovementType;
}
