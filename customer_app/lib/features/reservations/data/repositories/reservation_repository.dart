import '../../../../core/network/result.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/reservation_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reservation_repository_impl.dart';

abstract class ReservationRepository {
  Future<Result<Reservation>> createReservation(
    CreateReservationRequest request, {
    String? idempotencyKey,
  });
  Future<Result<Reservation>> getReservation(String id);
  Future<Result<ReservationListResult>> getCustomerReservations({
    int page = 1,
    int limit = 20,
  });
}

class ReservationListResult {
  final List<Reservation> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const ReservationListResult({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });
}

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepositoryImpl(ref.watch(dioProvider));
});
