import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../location/domain/models/location_models.dart';
import '../../../../core/providers/preferences_provider.dart';
import '../../domain/models/recommendation_models.dart';
import '../../data/repositories/recommendation_repository.dart';

class RecommendationNotifier extends AsyncNotifier<List<DealRecommendation>> {
  @override
  Future<List<DealRecommendation>> build() async {
    return _fetchRecommendations();
  }

  Future<List<DealRecommendation>> _fetchRecommendations() async {
    final locationState = ref.watch(locationProvider);
    final preferences = ref.watch(appPreferencesProvider);

    // If location is not available or detecting, wait or throw
    if (locationState.location == null) {
      if (locationState.status == LocationStatus.error ||
          locationState.status == LocationStatus.deniedForever) {
        throw Exception('Location is required for recommendations.');
      }
      // Return empty or wait if still detecting. For now, empty list until location is acquired.
      return [];
    }

    final repo = ref.read(recommendationRepositoryProvider);
    final result = await repo.getDeals(
      latitude: locationState.location!.latitude,
      longitude: locationState.location!.longitude,
      radiusKm: preferences.searchRadius,
    );

    if (result is Success<List<DealRecommendation>>) {
      return result.data;
    } else {
      throw Exception('Failed to load AI recommendations.');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchRecommendations());
  }
}

final recommendationProvider =
    AsyncNotifierProvider<RecommendationNotifier, List<DealRecommendation>>(() {
      return RecommendationNotifier();
    });
