import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { PrismaService } from '../../database/prisma/prisma.service';
import { InjectQueue } from '@nestjs/bullmq';
import { Queue } from 'bullmq';

@Injectable()
export class OutboxProcessorService {
  private readonly logger = new Logger(OutboxProcessorService.name);
  private isProcessing = false;

  constructor(
    private readonly prisma: PrismaService,
    @InjectQueue('notifications') private readonly notificationsQueue: Queue,
  ) {}

  @Cron(CronExpression.EVERY_10_SECONDS)
  async processOutbox() {
    if (this.isProcessing) return;
    this.isProcessing = true;

    try {
      const events = await this.prisma.outboxEvent.findMany({
        where: { status: 'PENDING', availableAt: { lte: new Date() } },
        take: 50,
        orderBy: { createdAt: 'asc' },
      });

      if (events.length === 0) {
        this.isProcessing = false;
        return;
      }

      this.logger.log(`Processing ${events.length} outbox events...`);

      for (const event of events) {
        try {
          // Push to BullMQ queue
          await this.notificationsQueue.add(
            event.eventType,
            {
              outboxEventId: event.id,
              aggregateType: event.aggregateType,
              aggregateId: event.aggregateId,
              payload: event.payload,
            },
            {
              jobId: event.id, // Idempotency key for BullMQ
              attempts: 3,
              backoff: { type: 'exponential', delay: 1000 },
            },
          );

          // Mark outbox as PROCESSED
          await this.prisma.outboxEvent.update({
            where: { id: event.id },
            data: { status: 'PROCESSED', processedAt: new Date() },
          });
        } catch (error: any) {
          this.logger.error(
            `Failed to process outbox event ${event.id}`,
            error.stack,
          );
          // Increment attempts, and optionally delay next availability
          await this.prisma.outboxEvent.update({
            where: { id: event.id },
            data: {
              attempts: { increment: 1 },
              ...(event.attempts >= 3
                ? { status: 'FAILED', errorReason: error.message }
                : { availableAt: new Date(Date.now() + 5000) }),
            },
          });
        }
      }
    } catch (error: any) {
      this.logger.error('Failed to poll outbox events', error.stack);
    } finally {
      this.isProcessing = false;
    }
  }
}
