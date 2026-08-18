import { Injectable, BadRequestException } from '@nestjs/common';
import {
  Inventory,
  Offer,
  OfferStatus,
  StoreStatus,
  ProductStatus,
  InventoryStatus,
} from '@prisma/client';
import { ExpiryService } from '../../inventory/services/expiry.service';
import { ExpiryStatus } from '../../inventory/constants/expiry.constants';

export interface ExpiryAwareInventory extends Inventory {
  store: { status: StoreStatus };
  product: { status: ProductStatus };
}

@Injectable()
export class OfferValidationService {
  constructor(private readonly expiryService: ExpiryService) {}

  /**
   * Validates if the given start/end times are logically sound for the specific inventory batch.
   */
  validateOfferDates(
    startTime: Date,
    endTime: Date,
    inventoryExpiryDate: Date,
  ): void {
    if (startTime >= endTime) {
      throw new BadRequestException('Offer start time must be before end time');
    }

    if (endTime > inventoryExpiryDate) {
      throw new BadRequestException(
        'Offer end time cannot exceed inventory expiry date',
      );
    }
  }

  /**
   * Validates if the inventory batch itself is eligible to have an active offer created or updated.
   */
  validateInventoryEligibility(
    inventory: ExpiryAwareInventory,
    now: Date = new Date(),
  ): void {
    if (inventory.status === InventoryStatus.INACTIVE) {
      throw new BadRequestException(
        'Cannot create offer for archived inventory',
      );
    }

    if (inventory.store.status !== StoreStatus.ACTIVE) {
      throw new BadRequestException('Cannot create offer: Store is not active');
    }

    if (inventory.product.status !== ProductStatus.ACTIVE) {
      throw new BadRequestException(
        'Cannot create offer: Product is not active',
      );
    }

    if (inventory.stockQuantity <= 0) {
      throw new BadRequestException(
        'Cannot create offer for out-of-stock inventory',
      );
    }

    const expiryStatus = this.expiryService.getExpiryStatus(
      inventory.expiryDate,
      now,
    );
    if (expiryStatus === ExpiryStatus.EXPIRED) {
      throw new BadRequestException(
        'Cannot create offer for already expired inventory',
      );
    }
  }

  /**
   * Determines the effective current status of an offer based on the current time and inventory stock.
   */
  getEffectiveOfferStatus(
    offer: Offer,
    inventoryStockQuantity: number,
    inventoryExpiryDate: Date,
    now: Date = new Date(),
  ): OfferStatus {
    if (
      offer.status === OfferStatus.CANCELLED ||
      offer.status === OfferStatus.PAUSED
    ) {
      return offer.status;
    }

    if (inventoryStockQuantity <= 0) {
      return OfferStatus.SOLD_OUT;
    }

    const expiryStatus = this.expiryService.getExpiryStatus(
      inventoryExpiryDate,
      now,
    );
    if (now >= offer.endsAt || expiryStatus === ExpiryStatus.EXPIRED) {
      return OfferStatus.EXPIRED;
    }

    if (now < offer.startsAt) {
      return OfferStatus.SCHEDULED;
    }

    return OfferStatus.ACTIVE;
  }
}
