import 'package:dio/dio.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/reservation_models.dart';
import 'reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  final Dio _dio;

  ReservationRepositoryImpl(this._dio);

  @override
  Future<Result<Reservation>> createReservation(
    CreateReservationRequest request, {
    String? idempotencyKey,
  }) async {
    try {
      final headers = <String, dynamic>{};
      if (idempotencyKey != null) headers['Idempotency-Key'] = idempotencyKey;
      final options = Options(headers: headers);

      final response = await _dio.post(
        '/reservations',
        data: request.toJson(),
        options: options,
      );

      if (response.data != null && response.data['success'] == true) {
        final reservation = Reservation.fromJson(
          response.data['data']['reservation'],
        );
        return Result.success(reservation);
      }
      return const Result.failure(
        AppError.server(message: 'Invalid response from server'),
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to create reservation';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        final msg = e.response?.data['message'];
        errorMessage = msg is List ? msg.join(', ') : msg.toString();
      }
      return Result.failure(AppError.server(message: errorMessage));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Reservation>> getReservation(String id) async {
    try {
      final response = await _dio.get('/reservations/$id');

      if (response.data != null && response.data['success'] == true) {
        final reservation = Reservation.fromJson(
          response.data['data']['reservation'],
        );
        return Result.success(reservation);
      }
      return const Result.failure(
        AppError.server(message: 'Invalid response from server'),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.server(
          message:
              e.response?.data?['message']?.toString() ??
              'Failed to load reservation',
        ),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<ReservationListResult>> getCustomerReservations({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/reservations',
        queryParameters: {'page': page, 'limit': limit},
      );

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final rawItems = data['items'] as List<dynamic>? ?? [];
        final meta = data['meta'] as Map<String, dynamic>? ?? {};

        final items = rawItems
            .map((e) => Reservation.fromJson(e as Map<String, dynamic>))
            .toList();

        return Result.success(
          ReservationListResult(
            items: items,
            total: (meta['total'] as num?)?.toInt() ?? items.length,
            page: (meta['page'] as num?)?.toInt() ?? page,
            limit: (meta['limit'] as num?)?.toInt() ?? limit,
            totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
          ),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Invalid response from server'),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.server(
          message:
              e.response?.data?['message']?.toString() ??
              'Failed to load reservations',
        ),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
