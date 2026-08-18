import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/home_models.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../location/domain/models/location_models.dart';
import '../../../../core/network/result.dart';

// --- Categories ---
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  final result = await repo.getCategories();

  if (result is Success<List<Category>>) {
    return result.data;
  } else if (result is Failure<List<Category>>) {
    throw result.error;
  }
  return [];
});

// --- Featured Deal ---
final featuredDealProvider = FutureProvider<Deal?>((ref) async {
  final locationState = ref.watch(locationProvider);

  if (locationState.status != LocationStatus.available ||
      locationState.location == null) {
    return null; // Return null gracefully if no location
  }

  final repo = ref.watch(homeRepositoryProvider);
  final result = await repo.getFeaturedDeal(
    lat: locationState.location!.latitude,
    lng: locationState.location!.longitude,
  );

  if (result is Success<Deal?>) {
    return result.data;
  } else if (result is Failure<Deal?>) {
    throw result.error;
  }
  return null;
});

// --- Nearby Deals ---
final nearbyDealsProvider = FutureProvider<List<Deal>>((ref) async {
  final locationState = ref.watch(locationProvider);

  if (locationState.status != LocationStatus.available ||
      locationState.location == null) {
    return []; // Empty list if no location
  }

  final repo = ref.watch(homeRepositoryProvider);
  final result = await repo.getNearbyDeals(
    lat: locationState.location!.latitude,
    lng: locationState.location!.longitude,
  );

  if (result is Success<List<Deal>>) {
    return result.data;
  } else if (result is Failure<List<Deal>>) {
    throw result.error;
  }
  return [];
});

// --- Nearby Stores ---
final nearbyStoresProvider = FutureProvider<List<Store>>((ref) async {
  final locationState = ref.watch(locationProvider);

  if (locationState.status != LocationStatus.available ||
      locationState.location == null) {
    return []; // Empty list if no location
  }

  final repo = ref.watch(homeRepositoryProvider);
  final result = await repo.getNearbyStores(
    lat: locationState.location!.latitude,
    lng: locationState.location!.longitude,
  );

  if (result is Success<List<Store>>) {
    return result.data;
  } else if (result is Failure<List<Store>>) {
    throw result.error;
  }
  return [];
});
