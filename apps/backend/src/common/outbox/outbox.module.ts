import { Module, Global } from '@nestjs/common';
import { OutboxService } from './outbox.service';
import { OutboxProcessorService } from './outbox-processor.service';
import { ScheduleModule } from '@nestjs/schedule';
import { BullModule } from '@nestjs/bullmq';

@Global()
@Module({
  imports: [
    ScheduleModule.forRoot(),
    BullModule.registerQueue({ name: 'notifications' }),
  ],
  providers: [OutboxService, OutboxProcessorService],
  exports: [OutboxService],
})
export class OutboxModule {}
