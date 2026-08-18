import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { AdjustStockDto, AdjustStockAction } from '../dto/adjust-stock.dto';
import { StockMovementType, Prisma } from '@prisma/client';

@Injectable()
export class StockService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Safely adjusts stock using an atomic database operation to prevent race conditions.
   * Records the stock movement in the same transaction.
   */
  async adjustStock(
    inventoryId: string,
    actorId: string,
    dto: AdjustStockDto,
    txClient?: Prisma.TransactionClient,
  ) {
    const prisma = txClient || this.prisma;

    return prisma.$transaction(async (tx) => {
      // 1. Fetch current inventory state with a row lock to prevent concurrent modifications
      const currentInventory = await tx.$queryRaw<{ stockQuantity: number }[]>`
        SELECT "stockQuantity" FROM "Inventory"
        WHERE id = ${inventoryId}
        FOR UPDATE
      `;

      if (!currentInventory || currentInventory.length === 0) {
        throw new BadRequestException('Inventory batch not found');
      }

      const previousQuantity = currentInventory[0].stockQuantity;
      let newQuantity = previousQuantity;

      switch (dto.action) {
        case AdjustStockAction.ADD:
          newQuantity = previousQuantity + dto.quantity;
          break;
        case AdjustStockAction.REMOVE:
          newQuantity = previousQuantity - dto.quantity;
          break;
        case AdjustStockAction.SET:
          newQuantity = dto.quantity;
          break;
      }

      if (newQuantity < 0) {
        throw new BadRequestException('Stock quantity cannot become negative');
      }

      const quantityDelta = Math.abs(newQuantity - previousQuantity);

      // Prevent useless updates
      if (quantityDelta === 0) {
        return { previousQuantity, newQuantity, updated: false };
      }

      // 2. Perform the stock update safely
      await tx.inventory.update({
        where: { id: inventoryId },
        data: { stockQuantity: newQuantity },
      });

      // 3. Record the stock movement history
      await tx.inventoryStockMovement.create({
        data: {
          inventoryId,
          type: dto.movementType || StockMovementType.ADJUSTMENT,
          quantity: quantityDelta, // Absolute change amount
          previousQuantity,
          newQuantity,
          reason: dto.reason,
          actorId,
        },
      });

      return { previousQuantity, newQuantity, updated: true };
    });
  }
}
