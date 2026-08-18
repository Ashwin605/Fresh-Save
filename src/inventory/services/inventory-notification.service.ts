import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { OutboxService } from '../../common/outbox/outbox.service';
import { Inventory } from '@prisma/client';

@Injectable()
export class InventoryNotificationService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly outboxService: OutboxService,
  ) {}

  /**
   * Generates inventory alerts and places them into the outbox for background delivery.
   * This would typically be called by a cron job sweeping the inventory.
   */
  async notifyExpiringSoon(inventory: Inventory) {
    await this.createOutboxEvent('INVENTORY_EXPIRING_SOON', inventory);
  }

  async notifyCritical(inventory: Inventory) {
    await this.createOutboxEvent('INVENTORY_CRITICAL', inventory);
  }

  async notifyExpired(inventory: Inventory) {
    await this.createOutboxEvent('INVENTORY_EXPIRED', inventory);
  }

  private async createOutboxEvent(eventType: string, inventory: Inventory) {
    // In a real scenario, we might want to aggregate these per-store or per-user.
    // For now, we dispatch the domain event, and the NotificationConsumer handles it.
    await this.prisma.outboxEvent.create({
      data: {
        eventType,
        aggregateType: 'Inventory',
        aggregateId: inventory.id,
        payload: {
          inventoryId: inventory.id,
          productId: inventory.productId,
          storeId: inventory.storeId,
        },
      },
    });
  }
}
