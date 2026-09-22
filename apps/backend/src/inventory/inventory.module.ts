import { Module } from '@nestjs/common';
import { InventoryService } from './inventory.service';
import { InventoryController } from './inventory.controller';
import { InventoryNotificationService } from './services/inventory-notification.service';
import { ExpiryService } from './services/expiry.service';
import { StockService } from './services/stock.service';

@Module({
  controllers: [InventoryController],
  providers: [
    InventoryService,
    ExpiryService,
    StockService,
    InventoryNotificationService,
  ],
  exports: [
    InventoryService,
    StockService,
    ExpiryService,
    InventoryNotificationService,
  ],
})
export class InventoryModule {}
