import { Injectable, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { UpdatePreferenceDto } from '../dto/update-preference.dto';

@Injectable()
export class NotificationPreferencesService {
  constructor(private readonly prisma: PrismaService) {}

  async getPreferences(userId: string) {
    let prefs = await this.prisma.notificationPreference.findUnique({
      where: { userId },
    });

    if (!prefs) {
      // Create defaults
      prefs = await this.prisma.notificationPreference.create({
        data: { userId },
      });
    }

    return prefs;
  }

  async updatePreferences(userId: string, dto: UpdatePreferenceDto) {
    // Upsert ensures we have a record
    return this.prisma.notificationPreference.upsert({
      where: { userId },
      update: {
        ...(dto.pushEnabled !== undefined && { pushEnabled: dto.pushEnabled }),
        ...(dto.emailEnabled !== undefined && {
          emailEnabled: dto.emailEnabled,
        }),
        ...(dto.inAppEnabled !== undefined && {
          inAppEnabled: dto.inAppEnabled,
        }),
        ...(dto.reservationUpdates !== undefined && {
          reservationUpdates: dto.reservationUpdates,
        }),
        ...(dto.offerAlerts !== undefined && { offerAlerts: dto.offerAlerts }),
        ...(dto.inventoryAlerts !== undefined && {
          inventoryAlerts: dto.inventoryAlerts,
        }),
        ...(dto.marketingAlerts !== undefined && {
          marketingAlerts: dto.marketingAlerts,
        }),
      },
      create: {
        userId,
        pushEnabled: dto.pushEnabled ?? true,
        emailEnabled: dto.emailEnabled ?? true,
        inAppEnabled: dto.inAppEnabled ?? true,
        reservationUpdates: dto.reservationUpdates ?? true,
        offerAlerts: dto.offerAlerts ?? true,
        inventoryAlerts: dto.inventoryAlerts ?? true,
        marketingAlerts: dto.marketingAlerts ?? false,
      },
    });
  }
}
