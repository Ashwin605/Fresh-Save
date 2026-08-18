import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Body,
  Query,
  UseGuards,
  Request,
} from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { UserRole } from '@prisma/client';

@Controller('admin')
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPER_ADMIN)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('dashboard')
  getDashboard() {
    return this.adminService.getDashboardMetrics();
  }

  @Get('users')
  getUsers(@Query('page') page: string, @Query('limit') limit: string) {
    return this.adminService.getUsers(Number(page) || 1, Number(limit) || 20);
  }

  @Patch('users/:id/suspend')
  suspendUser(
    @Param('id') id: string,
    @Body('reason') reason: string,
    @Request() req: any,
  ) {
    return this.adminService.suspendUser(id, req.user.userId, reason);
  }

  @Get('stores')
  getStores(@Query('page') page: string, @Query('limit') limit: string) {
    return this.adminService.getStores(Number(page) || 1, Number(limit) || 20);
  }

  @Post('stores')
  createStore(
    @Request() req: any,
    @Body('ownerEmail') ownerEmail: string,
    @Body('storeData') storeData: any,
    @Body('verifyInstantly') verifyInstantly: boolean,
  ) {
    return this.adminService.createStore(
      req.user.userId,
      ownerEmail,
      storeData,
      verifyInstantly ?? false,
    );
  }

  @Patch('stores/:id')
  updateStore(
    @Param('id') id: string,
    @Body() storeData: any,
    @Request() req: any,
  ) {
    return this.adminService.updateStore(req.user.userId, id, storeData);
  }

  @Delete('stores/:id')
  deleteStore(@Param('id') id: string, @Request() req: any) {
    return this.adminService.deleteStore(req.user.userId, id);
  }

  @Patch('stores/:id/status')
  updateStoreStatus(
    @Param('id') id: string,
    @Body('status') status: string,
    @Request() req: any,
  ) {
    return this.adminService.updateStoreStatus(id, status, req.user.userId);
  }

  @Get('audit-logs')
  getAuditLogs(@Query('page') page: string, @Query('limit') limit: string) {
    return this.adminService.getAuditLogs(
      Number(page) || 1,
      Number(limit) || 50,
    );
  }
}
