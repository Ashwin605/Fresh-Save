import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/recommendation_models.dart';
import 'recommendation_repository.dart';

final recommendationRepositoryImplProvider = Provider<RecommendationRepository>(
  (ref) {
    return RecommendationRepositoryImpl(dio: ref.watch(dioProvider));
  },
);

class RecommendationRepositoryImpl implements RecommendationRepository {
  final Dio dio;

  RecommendationRepositoryImpl({required this.dio});

  @override
  Future<Result<List<DealRecommendation>>> getDeals({
    required double latitude,
    required double longitude,
    double? radiusKm,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
      };
      if (radiusKm != null) queryParams['radiusKm'] = radiusKm;

      final response = await dio.get(
        '/ai/recommendations/deals',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List<dynamic>;
      final deals = data
          .map((json) => DealRecommendation.fromJson(json))
          .toList();

      return Result.success(deals);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
