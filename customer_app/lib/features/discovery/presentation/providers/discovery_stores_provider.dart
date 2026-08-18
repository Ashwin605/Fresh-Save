import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../data/repositories/discovery_repository_impl.dart';
import '../../domain/models/nearby_store_model.dart';

enum DiscoveryStoresStatus { initial, loading, loaded, error }

class DiscoveryStoresState {
  final DiscoveryStoresStatus status;
  final List<NearbyStore> stores;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;
  final double radius;
  final String? categoryId;
  final String? searchQuery;

  const DiscoveryStoresState({
    this.status = DiscoveryStoresStatus.initial,
    this.stores = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
    this.radius = 5.0,
    this.categoryId,
    this.searchQuery,
  });

  DiscoveryStoresState copyWith({
    DiscoveryStoresStatus? status,
    List<NearbyStore>? stores,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
    double? radius,
    String? categoryId,
    String? searchQuery,
  }) {
    return DiscoveryStoresState(
      status: status ?? this.status,
      stores: stores ?? this.stores,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      radius: radius ?? this.radius,
      categoryId: categoryId ?? this.categoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class DiscoveryStoresNotifier extends Notifier<DiscoveryStoresState> {
  @override
  DiscoveryStoresState build() {
    return const DiscoveryStoresState();
  }

  void updateRadius(double radius) {
    state = state.copyWith(radius: radius);
    refresh();
  }

  Future<void> fetchInitial() async {
    if (state.status == DiscoveryStoresStatus.loading) return;
    
    final locationState = ref.read(locationProvider);
    if (locationState.location == null) {
      state = state.copyWith(
        status: DiscoveryStoresStatus.error,
        errorMessage: 'Location is required to find nearby stores.',
      );
      return;
    }

    state = state.copyWith(status: DiscoveryStoresStatus.loading, errorMessage: null);

    final result = await ref.read(discoveryRepositoryProvider).searchStores(
      lat: locationState.location!.latitude,
      lng: locationState.location!.longitude,
      page: 1,
      radius: state.radius,
      categoryId: state.categoryId,
      search: state.searchQuery,
    );

    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          status: DiscoveryStoresStatus.loaded,
          stores: data,
          currentPage: 1,
          hasMore: data.length == 20, // assuming limit is 20
        );
      case Failure(:final error):
        state = state.copyWith(
          status: DiscoveryStoresStatus.error,
          errorMessage: error.message,
        );
    }
  }

  Future<void> loadMore() async {
    if (state.status == DiscoveryStoresStatus.loading || !state.hasMore) return;

    final locationState = ref.read(locationProvider);
    if (locationState.location == null) return;

    final nextPage = state.currentPage + 1;
    final result = await ref.read(discoveryRepositoryProvider).searchStores(
      lat: locationState.location!.latitude,
      lng: locationState.location!.longitude,
      page: nextPage,
      radius: state.radius,
      categoryId: state.categoryId,
      search: state.searchQuery,
    );

    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          status: DiscoveryStoresStatus.loaded,
          stores: [...state.stores, ...data],
          currentPage: nextPage,
          hasMore: data.length == 20,
        );
      case Failure():
        // Keep current state on pagination error
        break;
    }
  }

  Future<void> refresh() async {
    await fetchInitial();
  }
}

final discoveryStoresProvider =
    NotifierProvider<DiscoveryStoresNotifier, DiscoveryStoresState>(
  DiscoveryStoresNotifier.new,
);
