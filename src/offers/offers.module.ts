import { Module } from '@nestjs/common';
import { OffersService } from './offers.service';
import { OffersController } from './offers.controller';
import { DiscountService } from './services/discount.service';
import { OfferValidationService } from './services/offer-validation.service';
import { InventoryModule } from '../inventory/inventory.module';

@Module({
  imports: [InventoryModule],
  controllers: [OffersController],
  providers: [OffersService, DiscountService, OfferValidationService],
  exports: [OffersService],
})
export class OffersModule {}
