import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../../database/prisma/prisma.service';
import { CreateDeviceDto } from '../dto/create-device.dto';
import { NotificationQueryDto } from '../dto/notification-query.dto';
import { Prisma, NotificationChannel, NotificationType } from '@prisma/client';

@Injectable()
export class NotificationsService {
  constructor(private readonly prisma: PrismaService) {}

  // ── IN-APP NOTIFICATIONS ──────────────────────────────────────────

  async getNotifications(userId: string, query: NotificationQueryDto) {
    const { unread, type, page = 1, limit = 20 } = query;
    const where: Prisma.NotificationWhereInput = {
      userId,
      channel: NotificationChannel.IN_APP,
    };

    if (unread !== undefined) {
      if (unread) where.readAt = null;
      else where.readAt = { not: null };
    }

    if (type) {
      where.type = type;
    }

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.prisma.notification.findMany({
        where,
        skip,
        take: limit,
        orderBy: { createdAt: 'desc' },
      }),
      this.prisma.notification.count({ where }),
    ]);

    return {
      items,
      meta: { total, page, limit, totalPages: Math.ceil(total / limit) },
    };
  }

  async getUnreadCount(userId: string) {
    const count = await this.prisma.notification.count({
      where: {
        userId,
        channel: NotificationChannel.IN_APP,
        readAt: null,
      },
    });
    return { count };
  }

  async markAsRead(userId: string, notificationId: string) {
    const notification = await this.prisma.notification.findUnique({
      where: { id: notificationId },
    });

    if (!notification) {
      throw new NotFoundException('Notification not found');
    }
    if (notification.userId !== userId) {
      throw new ForbiddenException("Cannot modify another user's notification");
    }

    return this.prisma.notification.update({
      where: { id: notificationId },
      data: { readAt: new Date() },
    });
  }

  async markAllAsRead(userId: string) {
    const result = await this.prisma.notification.updateMany({
      where: {
        userId,
        channel: NotificationChannel.IN_APP,
        readAt: null,
      },
      data: { readAt: new Date() },
    });
    return { count: result.count };
  }

  async deleteNotification(userId: string, notificationId: string) {
    const notification = await this.prisma.notification.findUnique({
      where: { id: notificationId },
    });

    if (!notification) {
      throw new NotFoundException('Notification not found');
    }
    if (notification.userId !== userId) {
      throw new ForbiddenException("Cannot delete another user's notification");
    }

    // We do a hard delete for simplicity here, but a soft-delete could be implemented via a deletedAt field.
    return this.prisma.notification.delete({
      where: { id: notificationId },
    });
  }

  // ── DEVICE MANAGEMENT ──────────────────────────────────────────────

  async registerDevice(userId: string, dto: CreateDeviceDto) {
    return this.prisma.userDevice.upsert({
      where: {
        userId_deviceToken: {
          userId,
          deviceToken: dto.deviceToken,
        },
      },
      update: {
        platform: dto.platform,
        appVersion: dto.appVersion,
        isActive: true,
        lastSeenAt: new Date(),
      },
      create: {
        userId,
        deviceToken: dto.deviceToken,
        platform: dto.platform,
        appVersion: dto.appVersion,
        isActive: true,
      },
    });
  }

  async removeDevice(userId: string, deviceId: string) {
    const device = await this.prisma.userDevice.findUnique({
      where: { id: deviceId },
    });

    if (!device) {
      throw new NotFoundException('Device not found');
    }
    if (device.userId !== userId) {
      throw new ForbiddenException("Cannot remove another user's device");
    }

    return this.prisma.userDevice.delete({
      where: { id: deviceId },
    });
  }
}
