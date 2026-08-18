import { PartialType, PickType } from '@nestjs/swagger';
import { CreateInventoryDto } from './create-inventory.dto';

// Stock quantity is excluded from standard PATCH updates to force stock adjustment endpoints
export class UpdateInventoryDto extends PartialType(
  PickType(CreateInventoryDto, [
    'batchNumber',
    'originalPrice',
    'sellingPrice',
    'manufacturingDate',
    'expiryDate',
  ] as const),
) {}
