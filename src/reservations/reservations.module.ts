import { Module } from '@nestjs/common';
import { DatabaseModule } from '../database/database.module';
import { OffersModule } from '../offers/offers.module';
import { ReservationsService } from './reservations.service';
import { ReservationTransactionService } from './services/reservation-transaction.service';
import { ReservationLifecycleService } from './services/reservation-lifecycle.service';
import { ReservationExpirationService } from './services/reservation-expiration.service';
import { ReservationsController } from './reservations.controller';
import { StoreReservationsController } from './store-reservations.controller';
import { AdminReservationsController } from './admin-reservations.controller';

@Module({
  imports: [DatabaseModule, OffersModule],
  controllers: [
    ReservationsController,
    StoreReservationsController,
    AdminReservationsController,
  ],
  providers: [
    ReservationsService,
    ReservationTransactionService,
    ReservationLifecycleService,
    ReservationExpirationService,
  ],
  exports: [ReservationsService, ReservationExpirationService],
})
export class ReservationsModule {}
