import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/recommendation_models.dart';
import 'recommendation_repository_impl.dart';

final recommendationRepositoryProvider = Provider<RecommendationRepository>((
  ref,
) {
  return ref.watch(recommendationRepositoryImplProvider);
});

abstract class RecommendationRepository {
  Future<Result<List<DealRecommendation>>> getDeals({
    required double latitude,
    required double longitude,
    double? radiusKm,
  });
}
