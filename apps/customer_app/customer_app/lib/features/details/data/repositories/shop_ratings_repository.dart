import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../domain/models/rating_models.dart';

abstract class ShopRatingsRepository {
  Future<Result<void>> createRating(String shopId, String orderId, int rating, String? review);
  Future<Result<List<ShopRating>>> getRatings(String shopId, {int page = 1, int limit = 10});
  Future<Result<ShopRatingSummary>> getRatingSummary(String shopId);
}

class ShopRatingsRepositoryImpl implements ShopRatingsRepository {
  final Dio _dio;

  ShopRatingsRepositoryImpl(this._dio);

  @override
  Future<Result<void>> createRating(String shopId, String orderId, int rating, String? review) async {
    try {
      await _dio.post('/shops/$shopId/ratings', data: {
        'orderId': orderId,
        'rating': rating,
        if (review != null && review.isNotEmpty) 'review': review,
      });
      return const Success(null);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<ShopRating>>> getRatings(String shopId, {int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        '/shops/$shopId/ratings',
        queryParameters: {'page': page, 'limit': limit},
      );
      final data = response.data['data'] as Map<String, dynamic>?;
      final items = data?['ratings'] as List?;
      if (items == null || items.isEmpty) return const Success([]);
      final ratings = items.map((json) => ShopRating.fromJson(json)).toList();
      return Success(ratings);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<ShopRatingSummary>> getRatingSummary(String shopId) async {
    try {
      final response = await _dio.get('/shops/$shopId/rating-summary');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return Success(ShopRatingSummary.fromJson(data));
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }
}

final shopRatingsRepositoryProvider = Provider<ShopRatingsRepository>((ref) {
  return ShopRatingsRepositoryImpl(ref.watch(dioProvider));
});
