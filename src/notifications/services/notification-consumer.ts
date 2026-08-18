import { Processor, WorkerHost } from '@nestjs/bullmq';
import { Job } from 'bullmq';
import { Logger } from '@nestjs/common';
import { PushNotificationProvider } from '../providers/push-notification.provider';
import { EmailNotificationProvider } from '../providers/email-notification.provider';
import { PrismaService } from '../../database/prisma/prisma.service';
import { NotificationPreferencesService } from './notification-preferences.service';
import { NotificationType, NotificationChannel } from '@prisma/client';

export interface NotificationJobData {
  outboxEventId: string;
  aggregateType: string;
  aggregateId: string;
  payload: any;
}

@Processor('notifications')
export class NotificationConsumer extends WorkerHost {
  private readonly logger = new Logger(NotificationConsumer.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly pushProvider: PushNotificationProvider,
    private readonly emailProvider: EmailNotificationProvider,
    private readonly preferencesService: NotificationPreferencesService,
  ) {
    super();
  }

  async process(job: Job<NotificationJobData>) {
    this.logger.log(
      `Processing notification event ${job.name} (Job ID: ${job.id})`,
    );

    const { aggregateId, payload } = job.data;
    const eventType = job.name as NotificationType;

    // In our payload, we expect userId or customerId to know who to send to
    const targetUserId = payload.userId || payload.customerId;
    if (!targetUserId) {
      this.logger.warn(
        `No targetUserId provided for event ${eventType}. Skipping.`,
      );
      return;
    }

    // Load preferences
    const prefs = await this.preferencesService.getPreferences(targetUserId);

    // Check if category is enabled
    if (!this.isEventCategoryEnabled(eventType, prefs)) {
      this.logger.log(
        `User ${targetUserId} has disabled notifications for event ${eventType}. Skipping.`,
      );
      return;
    }

    // Build standard content
    const content = this.buildNotificationContent(eventType, payload);

    // IN-APP NOTIFICATION
    if (prefs.inAppEnabled) {
      await this.prisma.notification.create({
        data: {
          userId: targetUserId,
          type: eventType,
          channel: NotificationChannel.IN_APP,
          title: content.title,
          body: content.body,
          data: payload,
          deliveryStatus: 'SENT',
          sentAt: new Date(),
        },
      });
    }

    // PUSH NOTIFICATION
    if (prefs.pushEnabled) {
      const devices = await this.prisma.userDevice.findMany({
        where: { userId: targetUserId, isActive: true },
      });

      for (const device of devices) {
        const success = await this.pushProvider.send({
          token: device.deviceToken,
          title: content.title,
          body: content.body,
          data: payload,
        });

        // Log push delivery record
        await this.prisma.notification.create({
          data: {
            userId: targetUserId,
            type: eventType,
            channel: NotificationChannel.PUSH,
            title: content.title,
            body: content.body,
            data: payload,
            deliveryStatus: success ? 'SENT' : 'FAILED',
            sentAt: success ? new Date() : null,
            failedAt: success ? null : new Date(),
          },
        });
      }
    }

    // EMAIL NOTIFICATION
    if (prefs.emailEnabled) {
      const user = await this.prisma.user.findUnique({
        where: { id: targetUserId },
      });
      if (user && user.email) {
        const success = await this.emailProvider.send({
          to: user.email,
          subject: content.title,
          text: content.body,
        });

        await this.prisma.notification.create({
          data: {
            userId: targetUserId,
            type: eventType,
            channel: NotificationChannel.EMAIL,
            title: content.title,
            body: content.body,
            data: payload,
            deliveryStatus: success ? 'SENT' : 'FAILED',
            sentAt: success ? new Date() : null,
            failedAt: success ? null : new Date(),
          },
        });
      }
    }
  }

  private isEventCategoryEnabled(
    eventType: NotificationType,
    prefs: any,
  ): boolean {
    if (eventType.startsWith('RESERVATION_')) return prefs.reservationUpdates;
    if (eventType.startsWith('OFFER_')) return prefs.offerAlerts;
    if (eventType.startsWith('INVENTORY_')) return prefs.inventoryAlerts;
    return true; // Default to true if unmapped
  }

  private buildNotificationContent(
    eventType: NotificationType,
    payload: any,
  ): { title: string; body: string } {
    switch (eventType) {
      case 'RESERVATION_CREATED':
        return {
          title: 'Reservation received',
          body: `Your reservation ${payload.reservationCode || ''} has been received.`,
        };
      case 'RESERVATION_CONFIRMED':
        return {
          title: 'Reservation confirmed',
          body: `Your reservation ${payload.reservationCode || ''} has been confirmed.`,
        };
      case 'RESERVATION_REJECTED':
        return {
          title: 'Reservation rejected',
          body: `Your reservation ${payload.reservationCode || ''} was rejected. ${payload.reason || ''}`,
        };
      case 'RESERVATION_CANCELLED':
        return {
          title: 'Reservation cancelled',
          body: `Your reservation ${payload.reservationCode || ''} was cancelled.`,
        };
      case 'RESERVATION_READY':
        return {
          title: 'Ready for pickup',
          body: `Your reservation ${payload.reservationCode || ''} is ready for pickup!`,
        };
      case 'RESERVATION_COMPLETED':
        return {
          title: 'Reservation completed',
          body: `Your reservation ${payload.reservationCode || ''} is completed. Thank you!`,
        };
      case 'RESERVATION_EXPIRED':
        return {
          title: 'Reservation expired',
          body: `Your reservation ${payload.reservationCode || ''} has expired.`,
        };

      case 'OFFER_ACTIVATED':
        return {
          title: 'Offer Activated',
          body: `Offer is now active for inventory ${payload.inventoryId || ''}.`,
        };
      case 'OFFER_SOLD_OUT':
        return {
          title: 'Offer Sold Out',
          body: `Offer for inventory ${payload.inventoryId || ''} is sold out.`,
        };
      case 'OFFER_EXPIRED':
        return {
          title: 'Offer Expired',
          body: `Offer for inventory ${payload.inventoryId || ''} has expired.`,
        };

      case 'INVENTORY_EXPIRING_SOON':
        return {
          title: 'Inventory Expiring Soon',
          body: `Inventory ${payload.inventoryId || ''} is expiring soon.`,
        };
      case 'INVENTORY_CRITICAL':
        return {
          title: 'Inventory Critical',
          body: `Inventory ${payload.inventoryId || ''} requires immediate attention.`,
        };
      case 'INVENTORY_EXPIRED':
        return {
          title: 'Inventory Expired',
          body: `Inventory ${payload.inventoryId || ''} has expired.`,
        };

      default:
        return { title: 'New Notification', body: 'You have a new update.' };
    }
  }
}
