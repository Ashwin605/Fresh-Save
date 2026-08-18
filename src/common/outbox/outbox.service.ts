import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';

@Injectable()
export class OutboxService {
  /**
   * Appends an event to the Outbox table within an existing Prisma transaction.
   * This guarantees that if the business transaction commits, the event will eventually be delivered.
   *
   * @param tx The Prisma Transaction Client
   * @param eventType The type of the event (e.g. RESERVATION_CONFIRMED)
   * @param aggregateType The entity type (e.g. Reservation)
   * @param aggregateId The entity ID
   * @param payload The event payload
   */
  async createEvent(
    tx: Prisma.TransactionClient,
    eventType: string,
    aggregateType: string,
    aggregateId: string,
    payload: any,
  ): Promise<void> {
    await tx.outboxEvent.create({
      data: {
        eventType,
        aggregateType,
        aggregateId,
        payload,
        status: 'PENDING',
      },
    });
  }
}
