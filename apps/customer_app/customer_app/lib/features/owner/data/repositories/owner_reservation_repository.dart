import '../../../../core/network/result.dart';
import '../../domain/models/owner_reservation_models.dart';

abstract class OwnerReservationRepository {
  Future<Result<OwnerReservationPaginatedResponse>> getStoreReservations({
    required String storeId,
    ReservationStatus? status,
    String? reservationCode,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 20,
  });

  Future<Result<OwnerReservation>> confirmReservation(String reservationId);
  Future<Result<OwnerReservation>> rejectReservation(
    String reservationId, {
    required String reason,
  });
  Future<Result<OwnerReservation>> markReady(String reservationId);
  Future<Result<OwnerReservation>> completeReservation(String reservationId);
}
