import { IsOptional, IsString, IsEnum } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';
import { PaginationDto } from '../../../common/dto/pagination.dto';
import { InventoryStatus } from '@prisma/client';

export class StoreProductQueryDto extends PaginationDto {
  @ApiPropertyOptional({ description: 'Search by product name, brand, SKU or barcode' })
  @IsString()
  @IsOptional()
  search?: string;

  @ApiPropertyOptional({ description: 'Filter by category ID' })
  @IsString()
  @IsOptional()
  categoryId?: string;

  @ApiPropertyOptional({ enum: InventoryStatus, description: 'Filter by inventory status' })
  @IsEnum(InventoryStatus)
  @IsOptional()
  status?: InventoryStatus;
}
