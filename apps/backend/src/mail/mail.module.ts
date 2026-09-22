import { Module } from '@nestjs/common';
import { MailerModule } from '@nestjs-modules/mailer';
import { ConfigService } from '@nestjs/config';
import { MailService } from './mail.service';

@Module({
  imports: [
    MailerModule.forRootAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        transport: {
          host: config.get('MAIL_HOST', 'smtp.ethereal.email'),
          port: config.get('MAIL_PORT', 587),
          auth: {
            user: config.get('MAIL_USER', 'ethereal.user@ethereal.email'),
            pass: config.get('MAIL_PASSWORD', 'etherealpass'),
          },
        },
        defaults: {
          from: config.get('MAIL_FROM', '"FreshSave Support" <noreply@freshsave.app>'),
        },
      }),
    }),
  ],
  providers: [MailService],
  exports: [MailService],
})
export class MailModule {}
