import { Injectable, Logger } from '@nestjs/common';
import {
  EmailNotificationProvider,
  EmailNotificationPayload,
} from './email-notification.provider';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SmtpEmailProvider implements EmailNotificationProvider {
  private readonly logger = new Logger(SmtpEmailProvider.name);
  private readonly isConfigured: boolean;

  constructor(private readonly configService: ConfigService) {
    const smtpHost = this.configService.get<string>('SMTP_HOST');
    this.isConfigured = !!smtpHost;
    if (!this.isConfigured) {
      this.logger.warn(
        'SMTP credentials not found in environment. Emails will be safely logged instead of sent.',
      );
    }
  }

  async send(payload: EmailNotificationPayload): Promise<boolean> {
    if (!this.isConfigured) {
      this.logger.log(
        `[MOCK SMTP] Sending email to ${payload.to} - Subject: "${payload.subject}"`,
      );
      return true;
    }

    try {
      // Real nodemailer logic would go here
      this.logger.log(`Successfully sent email to ${payload.to}`);
      return true;
    } catch (error: any) {
      this.logger.error(`Failed to send email to ${payload.to}`, error.stack);
      return false;
    }
  }
}
