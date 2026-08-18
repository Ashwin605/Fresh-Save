import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
  UseGuards,
  Patch,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { NotificationsService } from '../services/notifications.service';
import { NotificationPreferencesService } from '../services/notification-preferences.service';
import { NotificationQueryDto } from '../dto/notification-query.dto';
import { CreateDeviceDto } from '../dto/create-device.dto';
import { UpdatePreferenceDto } from '../dto/update-preference.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../auth/guards/roles.guard';
import { Roles } from '../../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';
import type { User } from '@prisma/client';
import { CurrentUser } from '../../auth/decorators/current-user.decorator';

@ApiTags('Notifications')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard, RolesGuard)
// Allow any authenticated user (customer, shop owner, staff, admin) to manage their notifications
@Roles(
  UserRole.CUSTOMER,
  UserRole.SHOP_OWNER,
  UserRole.SHOP_STAFF,
  UserRole.ADMIN,
  UserRole.SUPER_ADMIN,
)
@Controller('notifications')
export class NotificationsController {
  constructor(
    private readonly notificationsService: NotificationsService,
    private readonly preferencesService: NotificationPreferencesService,
  ) {}

  // ── IN-APP ENDPOINTS ──────────────────────────────────────────────

  @Get()
  @ApiOperation({ summary: 'Get current user notifications (paginated)' })
  async getNotifications(
    @CurrentUser() user: User,
    @Query() query: NotificationQueryDto,
  ) {
    const result = await this.notificationsService.getNotifications(
      user.id,
      query,
    );
    return { success: true, data: result };
  }

  @Get('unread-count')
  @ApiOperation({ summary: 'Get count of unread notifications' })
  async getUnreadCount(@CurrentUser() user: User) {
    const data = await this.notificationsService.getUnreadCount(user.id);
    return { success: true, data };
  }

  @Post(':id/read')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Mark a specific notification as read' })
  async markAsRead(@CurrentUser() user: User, @Param('id') id: string) {
    await this.notificationsService.markAsRead(user.id, id);
    return { success: true, message: 'Notification marked as read' };
  }

  @Post('read-all')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Mark all notifications as read for current user' })
  async markAllAsRead(@CurrentUser() user: User) {
    const data = await this.notificationsService.markAllAsRead(user.id);
    return { success: true, data };
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Delete a specific notification' })
  async deleteNotification(@CurrentUser() user: User, @Param('id') id: string) {
    await this.notificationsService.deleteNotification(user.id, id);
    return { success: true, message: 'Notification deleted' };
  }

  // ── DEVICE MANAGEMENT ──────────────────────────────────────────────

  @Post('devices')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Register a device for push notifications' })
  async registerDevice(
    @CurrentUser() user: User,
    @Body() dto: CreateDeviceDto,
  ) {
    const device = await this.notificationsService.registerDevice(user.id, dto);
    return { success: true, data: { device } };
  }

  @Delete('devices/:deviceId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Remove a registered device' })
  async removeDevice(
    @CurrentUser() user: User,
    @Param('deviceId') deviceId: string,
  ) {
    await this.notificationsService.removeDevice(user.id, deviceId);
    return { success: true, message: 'Device removed' };
  }

  // ── PREFERENCES ──────────────────────────────────────────────────

  @Get('preferences')
  @ApiOperation({ summary: 'Get current user notification preferences' })
  async getPreferences(@CurrentUser() user: User) {
    const preferences = await this.preferencesService.getPreferences(user.id);
    return { success: true, data: { preferences } };
  }

  @Patch('preferences')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Update current user notification preferences' })
  async updatePreferences(
    @CurrentUser() user: User,
    @Body() dto: UpdatePreferenceDto,
  ) {
    const preferences = await this.preferencesService.updatePreferences(
      user.id,
      dto,
    );
    return { success: true, data: { preferences } };
  }
}
