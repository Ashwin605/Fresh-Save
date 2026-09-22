import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { NotificationsController } from './controllers/notifications.controller';
import { NotificationsService } from './services/notifications.service';
import { NotificationPreferencesService } from './services/notification-preferences.service';
import { NotificationConsumer } from './services/notification-consumer';
import { PushNotificationProvider } from './providers/push-notification.provider';
import { FcmPushProvider } from './providers/fcm-push.provider';
import { EmailNotificationProvider } from './providers/email-notification.provider';
import { SmtpEmailProvider } from './providers/smtp-email.provider';
import { BullModule } from '@nestjs/bullmq';

@Module({
  imports: [
    DatabaseModule,
    BullModule.registerQueue({ name: 'notifications' }),
  ],
  controllers: [NotificationsController],
  providers: [
    NotificationsService,
    NotificationPreferencesService,
    NotificationConsumer,
    {
      provide: PushNotificationProvider,
      useClass: FcmPushProvider,
    },
    {
      provide: EmailNotificationProvider,
      useClass: SmtpEmailProvider,
    },
  ],
  exports: [NotificationsService, NotificationPreferencesService],
})
export class NotificationsModule {}
