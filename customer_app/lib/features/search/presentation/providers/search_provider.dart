import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/search_state.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../location/domain/models/location_models.dart';
import '../../../../core/network/result.dart';
import '../../../home/domain/models/home_models.dart';
import '../../../discovery/domain/models/discovery_state.dart';

class SearchNotifier extends Notifier<SearchState> {
  Timer? _debounceTimer;
  int _lastRequestId = 0;
  static const _recentSearchesKey = 'freshsave_recent_searches';

  @override
  SearchState build() {
    _loadRecentSearches();
    return const SearchState();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final recent = prefs.getStringList(_recentSearchesKey) ?? [];
    state = state.copyWith(recentSearches: recent);
  }

  Future<void> _saveRecentSearch(String query) async {
    if (query.trim().isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final recent = List<String>.from(state.recentSearches);
    recent.remove(query);
    recent.insert(0, query);
    if (recent.length > 10) recent.removeLast();
    await prefs.setStringList(_recentSearchesKey, recent);
    state = state.copyWith(recentSearches: recent);
  }

  void clearRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final recent = List<String>.from(state.recentSearches);
    recent.remove(query);
    await prefs.setStringList(_recentSearchesKey, recent);
    state = state.copyWith(recentSearches: recent);
  }

  void clearAllRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesKey);
    state = state.copyWith(recentSearches: []);
  }

  void updateQuery(String query) {
    if (state.query == query) return;

    state = state.copyWith(query: query);

    _debounceTimer?.cancel();

    if (query.length < 2) {
      state = state.copyWith(
        status: SearchStatus.initial,
        deals: [],
        stores: [],
        products: [],
      );
      return;
    }

    state = state.copyWith(status: SearchStatus.searching);

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _performSearch();
    });
  }

  void executeSearch(String query) {
    _debounceTimer?.cancel();
    state = state.copyWith(query: query, status: SearchStatus.searching);
    if (query.length >= 2) {
      _performSearch();
    }
  }

  void clearSearch() {
    _debounceTimer?.cancel();
    state = state.copyWith(
      query: '',
      status: SearchStatus.initial,
      deals: [],
      stores: [],
      products: [],
    );
  }

  Future<void> _performSearch() async {
    final locationState = ref.read(locationProvider);
    if (locationState.status != LocationStatus.available ||
        locationState.location == null) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Location required for search.',
      );
      return;
    }

    final requestId = ++_lastRequestId;
    final repo = ref.read(searchRepositoryProvider);
    final lat = locationState.location!.latitude;
    final lng = locationState.location!.longitude;
    final query = state.query;

    _saveRecentSearch(query);

    final dealsFuture = repo.searchDeals(
      lat: lat,
      lng: lng,
      query: query,
      filters: state.filters,
      sort: state.sort,
      limit: 10,
    );

    final storesFuture = repo.searchStores(
      lat: lat,
      lng: lng,
      query: query,
      limit: 10,
    );

    final productsFuture = repo.searchProducts(query: query, limit: 10);

    final results = await Future.wait([
      dealsFuture,
      storesFuture,
      productsFuture,
    ]);

    if (requestId != _lastRequestId) return; // Stale request

    final dealsResult = results[0] as Result<List<Deal>>;
    final storesResult = results[1] as Result<List<Store>>;
    final productsResult = results[2] as Result<List<Product>>;

    if (dealsResult is Failure &&
        storesResult is Failure &&
        productsResult is Failure) {
      state = state.copyWith(
        status: SearchStatus.error,
        errorMessage: 'Could not complete your search.',
      );
      return;
    }

    final deals = dealsResult is Success<List<Deal>>
        ? dealsResult.data
        : <Deal>[];
    final stores = storesResult is Success<List<Store>>
        ? storesResult.data
        : <Store>[];
    final products = productsResult is Success<List<Product>>
        ? productsResult.data
        : <Product>[];

    if (deals.isEmpty && stores.isEmpty && products.isEmpty) {
      state = state.copyWith(
        status: SearchStatus.empty,
        deals: [],
        stores: [],
        products: [],
        errorMessage: null,
      );
    } else {
      state = state.copyWith(
        status: SearchStatus.results,
        deals: deals,
        stores: stores,
        products: products,
        errorMessage: null,
      );
    }
  }

  Future<void> loadMore() async {
    if (state.status == SearchStatus.searching || state.query.length < 2) {
      return;
    }

    // Simplistic pagination for deals as example, real impl would track page per entity
    final locationState = ref.read(locationProvider);
    if (locationState.location == null) return;

    final repo = ref.read(searchRepositoryProvider);
    final dealsResult = await repo.searchDeals(
      lat: locationState.location!.latitude,
      lng: locationState.location!.longitude,
      query: state.query,
      filters: state.filters,
      sort: state.sort,
      limit: 10,
    );

    if (dealsResult is Success<List<Deal>>) {
      state = state.copyWith(deals: [...state.deals, ...dealsResult.data]);
    }
  }

  void applyFilters(DiscoveryFilters filters) {
    state = state.copyWith(filters: filters);
    if (state.query.length >= 2) {
      _performSearch();
    }
  }

  void applySort(DiscoverySort sort) {
    state = state.copyWith(sort: sort);
    if (state.query.length >= 2) {
      _performSearch();
    }
  }
}

final searchProvider = NotifierProvider<SearchNotifier, SearchState>(() {
  return SearchNotifier();
});
