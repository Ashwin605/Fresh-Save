import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';

class PaymentRepository {
  final Dio _dio;

  PaymentRepository(this._dio);

  Future<Result<Map<String, dynamic>>> createPayment(String reservationId) async {
    try {
      final response = await _dio.post('/payments/create', data: {
        'reservationId': reservationId,
      });

      if (response.data != null && response.data['success'] == true) {
        return Result.success(response.data['data']['payment']);
      }
      return const Result.failure(
        AppError.server(message: 'Invalid response from server'),
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to create payment';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        final msg = e.response?.data['message'];
        errorMessage = msg is List ? msg.join(', ') : msg.toString();
      }
      return Result.failure(AppError.server(message: errorMessage));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> verifyPayment(String paymentId, {String? simulateStatus}) async {
    try {
      final response = await _dio.post('/payments/$paymentId/verify', data: {
        if (simulateStatus != null) 'simulateStatus': simulateStatus,
      });

      if (response.data != null && response.data['success'] == true) {
        return Result.success(response.data['data']['payment']);
      }
      return const Result.failure(
        AppError.server(message: 'Invalid response from server'),
      );
    } on DioException catch (e) {
      String errorMessage = 'Failed to verify payment';
      if (e.response?.data != null && e.response?.data['message'] != null) {
        final msg = e.response?.data['message'];
        errorMessage = msg is List ? msg.join(', ') : msg.toString();
      }
      return Result.failure(AppError.server(message: errorMessage));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  return PaymentRepository(ref.watch(dioProvider));
});
