import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../home/domain/models/home_models.dart'; // Reusing Deal

part 'discovery_state.freezed.dart';

enum DiscoverySort { relevance, distance, discount, price, expiry, newest }

@freezed
abstract class DiscoveryFilters with _$DiscoveryFilters {
  const factory DiscoveryFilters({
    double? radius,
    String? categoryId,
    String? categoryName, // For displaying the chip
    double? minDiscount,
    int? expiryWithinHours,
  }) = _DiscoveryFilters;

  const DiscoveryFilters._();

  bool get hasActiveFilters =>
      radius != null ||
      categoryId != null ||
      minDiscount != null ||
      expiryWithinHours != null;
}

enum DiscoveryStatus { initial, loading, loaded, loadingMore, error }

@freezed
abstract class DiscoveryState with _$DiscoveryState {
  const factory DiscoveryState({
    @Default([]) List<Deal> deals,
    @Default(1) int currentPage,
    @Default(true) bool hasMore,
    @Default(DiscoveryStatus.initial) DiscoveryStatus status,
    @Default(DiscoveryFilters()) DiscoveryFilters filters,
    @Default(DiscoverySort.relevance) DiscoverySort sort,
    String? errorMessage,
  }) = _DiscoveryState;
}
