import { Module } from '@nestjs/common';
import { ShopRatingsController } from './shop-ratings.controller';
import { ShopRatingsService } from './shop-ratings.service';
import { DatabaseModule } from '../database/database.module';

@Module({
  imports: [DatabaseModule],
  controllers: [ShopRatingsController],
  providers: [ShopRatingsService],
})
export class ShopRatingsModule {}
