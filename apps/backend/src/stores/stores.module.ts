import { Module } from '@nestjs/common';
import { StoresService } from './stores.service';
import {
  StoresController,
  StoreStaffController,
  AdminStoresController,
} from './stores.controller';

@Module({
  controllers: [StoresController, StoreStaffController, AdminStoresController],
  providers: [StoresService],
  exports: [StoresService],
})
export class StoresModule {}
