import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../home/domain/models/home_models.dart';
import '../../../discovery/domain/models/discovery_state.dart'; // Reusing DiscoveryFilters and Sort

part 'search_state.freezed.dart';

enum SearchStatus { initial, searching, results, empty, error }

@freezed
abstract class SearchState with _$SearchState {
  const factory SearchState({
    @Default('') String query,
    @Default([]) List<String> recentSearches,
    @Default([]) List<Deal> deals,
    @Default([]) List<Store> stores,
    @Default([]) List<Product> products,
    @Default(SearchStatus.initial) SearchStatus status,
    @Default(DiscoveryFilters()) DiscoveryFilters filters,
    @Default(DiscoverySort.relevance) DiscoverySort sort,
    String? errorMessage,
  }) = _SearchState;
}
