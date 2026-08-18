import { IsOptional, IsString, IsBoolean } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { PaginationDto } from '../../common/dto/pagination.dto';
import { ExpiryStatus } from '../constants/expiry.constants';
import { Transform } from 'class-transformer';

export class InventoryQueryDto extends PaginationDto {
  @ApiPropertyOptional({ enum: ExpiryStatus, example: ExpiryStatus.URGENT })
  @IsString()
  @IsOptional()
  expiryStatus?: ExpiryStatus;

  @ApiPropertyOptional({ example: 'uuid-product' })
  @IsString()
  @IsOptional()
  productId?: string;

  @ApiPropertyOptional({ example: 'uuid-category' })
  @IsString()
  @IsOptional()
  categoryId?: string;

  @ApiPropertyOptional({ example: true })
  @Transform(({ value }) => value === 'true' || value === true)
  @IsBoolean()
  @IsOptional()
  lowStock?: boolean;

  @ApiPropertyOptional({ example: 'expiryDate' })
  @IsString()
  @IsOptional()
  sortBy?: string;

  @ApiPropertyOptional({ example: 'asc' })
  @IsString()
  @IsOptional()
  sortOrder?: 'asc' | 'desc';
}
