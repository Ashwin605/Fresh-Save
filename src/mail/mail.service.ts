import { Injectable, Logger } from '@nestjs/common';
import { MailerService } from '@nestjs/modules-mailer';
import * as nodemailer from 'nodemailer';

@Injectable()
export class MailService {
  private readonly logger = new Logger(MailService.name);

  constructor(private mailerService: MailerService) {}

  async sendPasswordResetEmail(email: string, otp: string) {
    try {
      const result = await this.mailerService.sendMail({
        to: email,
        subject: 'Password Reset Code - FreshSave',
        text: `Your password reset code is: ${otp}. It expires in 15 minutes.`,
        html: `
          <div style="font-family: Arial, sans-serif; padding: 20px; color: #333;">
            <h2 style="color: #4CAF50;">FreshSave Password Reset</h2>
            <p>You requested a password reset. Use the code below to reset your password:</p>
            <div style="font-size: 24px; font-weight: bold; padding: 10px; background: #f4f4f4; border-radius: 8px; display: inline-block;">
              ${otp}
            </div>
            <p>This code will expire in 15 minutes. If you did not request this, please ignore this email.</p>
          </div>
        `,
      });

      this.logger.log(`Password reset email sent to ${email}`);
      
      // Log Ethereal URL if using Ethereal
      const testUrl = nodemailer.getTestMessageUrl(result);
      if (testUrl) {
        this.logger.log(`Ethereal test URL: ${testUrl}`);
      }
    } catch (error) {
      this.logger.error(`Failed to send email to ${email}`, error);
    }
  }
}
