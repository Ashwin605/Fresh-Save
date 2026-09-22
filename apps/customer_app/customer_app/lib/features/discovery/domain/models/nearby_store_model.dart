import 'package:freezed_annotation/freezed_annotation.dart';

part 'nearby_store_model.freezed.dart';
part 'nearby_store_model.g.dart';

@freezed
abstract class NearbyStore with _$NearbyStore {
  const factory NearbyStore({
    required String id,
    required String name,
    String? description,
    String? logo,
    String? coverImage,
    String? address,
    String? city,
    required StoreDistance distance,
    required int activeDealCount,
  }) = _NearbyStore;

  factory NearbyStore.fromJson(Map<String, dynamic> json) =>
      _$NearbyStoreFromJson(json);
}

@freezed
abstract class StoreDistance with _$StoreDistance {
  const factory StoreDistance({
    required double value,
    required String unit,
  }) = _StoreDistance;

  factory StoreDistance.fromJson(Map<String, dynamic> json) =>
      _$StoreDistanceFromJson(json);
}

