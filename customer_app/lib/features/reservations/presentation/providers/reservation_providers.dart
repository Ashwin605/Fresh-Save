import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/reservation_models.dart';
import '../../data/repositories/reservation_repository.dart';

final reservationDetailsProvider = FutureProvider.family<Reservation, String>((
  ref,
  id,
) async {
  final repo = ref.watch(reservationRepositoryProvider);
  final result = await repo.getReservation(id);

  if (result is Success<Reservation>) {
    return result.data;
  } else if (result is Failure<Reservation>) {
    throw Exception(
      result.error.message ?? 'Failed to load reservation details',
    );
  }
  throw Exception('Unknown error');
});

final customerReservationsProvider =
    FutureProvider<ReservationListResult>((ref) async {
  final repo = ref.watch(reservationRepositoryProvider);
  final result = await repo.getCustomerReservations();

  if (result is Success<ReservationListResult>) {
    return result.data;
  } else if (result is Failure<ReservationListResult>) {
    throw Exception(
      result.error.message ?? 'Failed to load reservations',
    );
  }
  throw Exception('Unknown error');
});
