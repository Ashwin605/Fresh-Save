import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';

class AdminPaymentRepository {
  final Dio _dio;

  AdminPaymentRepository(this._dio);

  Future<Result<Map<String, dynamic>>> getPayments({int page = 1, int limit = 20, String? status, String? search}) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (status != null && status != 'ALL') queryParams['status'] = status;
      if (search != null && search.isNotEmpty) queryParams['search'] = search;

      final response = await _dio.get('/admin/payments', queryParameters: queryParams);

      if (response.data != null && response.data['success'] == true) {
        return Result.success(response.data['data']);
      }
      return const Result.failure(AppError.server(message: 'Invalid response from server'));
    } on DioException catch (e) {
      return Result.failure(AppError.server(message: e.response?.data?['message']?.toString() ?? 'Failed to load payments'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> getPaymentStats() async {
    try {
      final response = await _dio.get('/admin/payments/stats');

      if (response.data != null && response.data['success'] == true) {
        return Result.success(response.data['data']);
      }
      return const Result.failure(AppError.server(message: 'Invalid response from server'));
    } on DioException catch (e) {
      return Result.failure(AppError.server(message: e.response?.data?['message']?.toString() ?? 'Failed to load stats'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  Future<Result<Map<String, dynamic>>> getPaymentDetails(String id) async {
    try {
      final response = await _dio.get('/admin/payments/$id');

      if (response.data != null && response.data['success'] == true) {
        return Result.success(response.data['data']['payment']);
      }
      return const Result.failure(AppError.server(message: 'Invalid response from server'));
    } on DioException catch (e) {
      return Result.failure(AppError.server(message: e.response?.data?['message']?.toString() ?? 'Failed to load payment'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}

final adminPaymentRepositoryProvider = Provider<AdminPaymentRepository>((ref) {
  return AdminPaymentRepository(ref.watch(dioProvider));
});
