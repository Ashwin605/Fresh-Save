import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../features/details/domain/models/details_models.dart';
import '../../../../features/home/domain/models/home_models.dart';

part 'store_details_models.freezed.dart';

enum StoreDetailsStatus { initial, loading, loaded, loadingMore, error }

@freezed
abstract class StoreProfileState with _$StoreProfileState {
  const factory StoreProfileState({
    DealStore? storeMetadata,
    DealDistance? storeDistance,
    @Default([]) List<Deal> offers,
    @Default(1) int currentPage,
    @Default(true) bool hasMore,
    @Default(StoreDetailsStatus.initial) StoreDetailsStatus status,
    String? errorMessage,
  }) = _StoreProfileState;
}
