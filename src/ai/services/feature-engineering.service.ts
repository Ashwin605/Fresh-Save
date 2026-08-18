import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';

@Injectable()
export class FeatureEngineeringService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Fetches and aggregates all necessary features for an inventory item.
   */
  async getInventoryFeatures(inventoryId: string) {
    const inventory = await this.prisma.inventory.findUnique({
      where: { id: inventoryId },
      include: {
        product: true,
        offers: {
          where: { status: 'ACTIVE' },
          take: 1,
        },
      },
    });

    if (!inventory) {
      throw new NotFoundException('Inventory not found');
    }

    const now = new Date();
    const hoursUntilExpiry =
      (inventory.expiryDate.getTime() - now.getTime()) / (1000 * 60 * 60);

    // Calculate velocity (reservations over the last 7 days)
    const sevenDaysAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    // Total quantity reserved in the last 7 days
    const recentReservations = await this.prisma.reservationItem.aggregate({
      where: {
        inventoryId: inventoryId,
        createdAt: { gte: sevenDaysAgo },
      },
      _sum: {
        quantity: true,
      },
    });

    const quantityReserved = recentReservations._sum.quantity || 0;

    // Estimate daily velocity
    const daysSinceCreated =
      (now.getTime() - inventory.createdAt.getTime()) / (1000 * 60 * 60 * 24);
    const observationDays = Math.min(daysSinceCreated, 7);

    const dailyVelocity =
      observationDays >= 1
        ? quantityReserved / observationDays
        : quantityReserved;

    // We consider "sufficient history" if the item has been listed for at least 3 days
    const hasSufficientHistory = daysSinceCreated >= 3;

    return {
      inventoryId: inventory.id,
      storeId: inventory.storeId,
      productId: inventory.productId,
      availableQuantity: inventory.stockQuantity,
      hoursUntilExpiry,
      dailyVelocity,
      hasSufficientHistory,
      originalPrice: Number(inventory.originalPrice),
      currentDiscount:
        inventory.offers.length > 0
          ? Number(inventory.offers[0].discountValue)
          : null,
    };
  }
}
