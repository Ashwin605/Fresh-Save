import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/discovery_state.dart';
import '../../data/repositories/discovery_repository_impl.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../location/domain/models/location_models.dart';
import '../../../../core/network/result.dart';
import '../../../home/domain/models/home_models.dart';

class DiscoveryNotifier extends Notifier<DiscoveryState> {
  // To track the latest request and avoid race conditions
  int _lastRequestId = 0;

  @override
  DiscoveryState build() {
    // We don't fetch immediately in build because we want to react to locationProvider.
    // Instead, we will expose a method to initialize/refresh, or we can listen to location here.

    ref.listen(locationProvider, (previous, next) {
      if (next.status == LocationStatus.available && next.location != null) {
        // Only fetch if location actually changed or if we were in initial state
        if (previous?.location?.latitude != next.location?.latitude ||
            previous?.location?.longitude != next.location?.longitude ||
            state.status == DiscoveryStatus.initial) {
          fetchInitial();
        }
      } else if (next.status != LocationStatus.available) {
        state = state.copyWith(
          status: DiscoveryStatus.error,
          errorMessage: 'Location required for discovery.',
        );
      }
    });

    return const DiscoveryState();
  }

  Future<void> fetchInitial() async {
    state = state.copyWith(
      status: DiscoveryStatus.loading,
      currentPage: 1,
      hasMore: true,
    );
    await _fetchPage(1);
  }

  Future<void> refresh() async {
    // Refresh keeps filters and sort but resets pagination
    state = state.copyWith(currentPage: 1, hasMore: true);
    await _fetchPage(1, isRefresh: true);
  }

  Future<void> loadMore() async {
    if (state.status == DiscoveryStatus.loading ||
        state.status == DiscoveryStatus.loadingMore ||
        !state.hasMore) {
      return;
    }

    state = state.copyWith(status: DiscoveryStatus.loadingMore);
    await _fetchPage(state.currentPage + 1);
  }

  void updateFilters(DiscoveryFilters newFilters) {
    state = state.copyWith(filters: newFilters);
    fetchInitial();
  }

  void updateSort(DiscoverySort newSort) {
    state = state.copyWith(sort: newSort);
    fetchInitial();
  }

  void clearFilters() {
    state = state.copyWith(filters: const DiscoveryFilters());
    fetchInitial();
  }

  Future<void> _fetchPage(int page, {bool isRefresh = false}) async {
    final locationState = ref.read(locationProvider);
    if (locationState.status != LocationStatus.available ||
        locationState.location == null) {
      state = state.copyWith(
        status: DiscoveryStatus.error,
        errorMessage: 'Location required to find nearby deals.',
      );
      return;
    }

    final requestId = ++_lastRequestId;
    final repo = ref.read(discoveryRepositoryProvider);

    final result = await repo.searchDeals(
      lat: locationState.location!.latitude,
      lng: locationState.location!.longitude,
      filters: state.filters,
      sort: state.sort,
      page: page,
    );

    // If another request was started, discard this result
    if (requestId != _lastRequestId) return;

    if (result is Success<List<Deal>>) {
      final newDeals = result.data;
      final hasMore = newDeals.length == 20; // limit is 20

      state = state.copyWith(
        deals: page == 1 ? newDeals : [...state.deals, ...newDeals],
        currentPage: page,
        hasMore: hasMore,
        status: DiscoveryStatus.loaded,
        errorMessage: null,
      );
    } else if (result is Failure<List<Deal>>) {
      state = state.copyWith(
        status: DiscoveryStatus.error,
        errorMessage: result.error.message,
      );
    }
  }
}

final discoveryProvider = NotifierProvider<DiscoveryNotifier, DiscoveryState>(
  () {
    return DiscoveryNotifier();
  },
);
