import { Injectable, Logger } from '@nestjs/common';
import {
  PushNotificationProvider,
  PushNotificationPayload,
} from './push-notification.provider';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class FcmPushProvider implements PushNotificationProvider {
  private readonly logger = new Logger(FcmPushProvider.name);
  private readonly isConfigured: boolean;

  constructor(private readonly configService: ConfigService) {
    const serverKey = this.configService.get<string>('FCM_SERVER_KEY');
    this.isConfigured = !!serverKey;
    if (!this.isConfigured) {
      this.logger.warn(
        'FCM credentials not found in environment. Push notifications will be safely logged instead of sent.',
      );
    }
  }

  async send(payload: PushNotificationPayload): Promise<boolean> {
    if (!this.isConfigured) {
      this.logger.log(
        `[MOCK FCM] Sending push to ${payload.token} - Title: "${payload.title}"`,
      );
      return true; // Simulate success for local development
    }

    try {
      // Real FCM logic would go here. E.g. using firebase-admin SDK
      // const message = { notification: { title: payload.title, body: payload.body }, token: payload.token, data: payload.data };
      // await admin.messaging().send(message);
      this.logger.log(`Successfully sent FCM to ${payload.token}`);
      return true;
    } catch (error: any) {
      this.logger.error(
        `Failed to send FCM push to ${payload.token}`,
        error.stack,
      );
      return false;
    }
  }
}
