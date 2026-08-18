// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nearby_store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NearbyStore _$NearbyStoreFromJson(Map<String, dynamic> json) => _NearbyStore(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  logo: json['logo'] as String?,
  coverImage: json['coverImage'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
  distance: StoreDistance.fromJson(json['distance'] as Map<String, dynamic>),
  activeDealCount: (json['activeDealCount'] as num).toInt(),
);

Map<String, dynamic> _$NearbyStoreToJson(_NearbyStore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo': instance.logo,
      'coverImage': instance.coverImage,
      'address': instance.address,
      'city': instance.city,
      'distance': instance.distance,
      'activeDealCount': instance.activeDealCount,
    };

_StoreDistance _$StoreDistanceFromJson(Map<String, dynamic> json) =>
    _StoreDistance(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$StoreDistanceToJson(_StoreDistance instance) =>
    <String, dynamic>{'value': instance.value, 'unit': instance.unit};
