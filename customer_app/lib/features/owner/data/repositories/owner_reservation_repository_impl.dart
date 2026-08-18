import 'package:dio/dio.dart';
import '../../../../core/network/app_error.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_reservation_models.dart';
import 'owner_reservation_repository.dart';

class OwnerReservationRepositoryImpl implements OwnerReservationRepository {
  final Dio _dioClient;

  OwnerReservationRepositoryImpl(this._dioClient);

  @override
  Future<Result<OwnerReservationPaginatedResponse>> getStoreReservations({
    required String storeId,
    ReservationStatus? status,
    String? reservationCode,
    String? startDate,
    String? endDate,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (status != null) {
        // Find the string value of the enum based on JsonValue, or fallback
        queryParams['status'] = status.name.toUpperCase();
      }
      if (reservationCode != null && reservationCode.isNotEmpty) {
        queryParams['reservationCode'] = reservationCode;
      }
      if (startDate != null && startDate.isNotEmpty) {
        queryParams['startDate'] = startDate;
      }
      if (endDate != null && endDate.isNotEmpty) {
        queryParams['endDate'] = endDate;
      }

      final response = await _dioClient.get(
        '/stores/$storeId/reservations',
        queryParameters: queryParams,
      );

      return Result.success(
        OwnerReservationPaginatedResponse.fromJson(response.data),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerReservation>> confirmReservation(
    String reservationId,
  ) async {
    try {
      final response = await _dioClient.patch(
        '/stores/reservations/$reservationId/confirm',
      );
      return Result.success(
        OwnerReservation.fromJson(response.data['data']['reservation']),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerReservation>> rejectReservation(
    String reservationId, {
    required String reason,
  }) async {
    try {
      final response = await _dioClient.patch(
        '/stores/reservations/$reservationId/reject',
        data: {'reason': reason},
      );
      return Result.success(
        OwnerReservation.fromJson(response.data['data']['reservation']),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerReservation>> markReady(String reservationId) async {
    try {
      final response = await _dioClient.patch(
        '/stores/reservations/$reservationId/ready',
      );
      return Result.success(
        OwnerReservation.fromJson(response.data['data']['reservation']),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerReservation>> completeReservation(
    String reservationId,
  ) async {
    try {
      final response = await _dioClient.patch(
        '/stores/reservations/$reservationId/complete',
      );
      return Result.success(
        OwnerReservation.fromJson(response.data['reservation'] ?? response.data),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
