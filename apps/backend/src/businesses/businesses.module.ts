import { Module } from '@nestjs/common';
import { BusinessesService } from './businesses.service';
import {
  BusinessesController,
  AdminBusinessesController,
} from './businesses.controller';

@Module({
  controllers: [BusinessesController, AdminBusinessesController],
  providers: [BusinessesService],
  exports: [BusinessesService],
})
export class BusinessesModule {}
