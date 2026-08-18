import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/analytics_models.dart';
import 'analytics_repository.dart';

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepositoryImpl(ref.watch(dioProvider));
});

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final Dio _dio;

  AnalyticsRepositoryImpl(this._dio);

  @override
  Future<Result<AnalyticsDashboardResponse>> getAnalyticsDashboard(
    String storeId, {
    String range = '30d',
  }) async {
    try {
      // NOTE: This endpoint does not currently exist on the backend.
      // We will make the request, and gracefully handle the 404 response.
      final response = await _dio.get(
        '/stores/$storeId/analytics',
        queryParameters: {'range': range},
      );

      if (response.data != null && response.data['success'] == true) {
        return Result.success(
          AnalyticsDashboardResponse.fromJson(response.data['data']),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to load analytics'),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Return 404 to explicitly trigger the "Data Unavailable" empty state
        return const Result.failure(
          AppError.notFound(
            message: 'Analytics data is not yet available for this store.',
          ),
        );
      }
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
