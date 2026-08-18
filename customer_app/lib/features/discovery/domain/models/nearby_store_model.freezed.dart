// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nearby_store_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NearbyStore {

 String get id; String get name; String? get description; String? get logo; String? get coverImage; String? get address; String? get city; StoreDistance get distance; int get activeDealCount;
/// Create a copy of NearbyStore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NearbyStoreCopyWith<NearbyStore> get copyWith => _$NearbyStoreCopyWithImpl<NearbyStore>(this as NearbyStore, _$identity);

  /// Serializes this NearbyStore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NearbyStore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.activeDealCount, activeDealCount) || other.activeDealCount == activeDealCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,logo,coverImage,address,city,distance,activeDealCount);

@override
String toString() {
  return 'NearbyStore(id: $id, name: $name, description: $description, logo: $logo, coverImage: $coverImage, address: $address, city: $city, distance: $distance, activeDealCount: $activeDealCount)';
}


}

/// @nodoc
abstract mixin class $NearbyStoreCopyWith<$Res>  {
  factory $NearbyStoreCopyWith(NearbyStore value, $Res Function(NearbyStore) _then) = _$NearbyStoreCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String? logo, String? coverImage, String? address, String? city, StoreDistance distance, int activeDealCount
});


$StoreDistanceCopyWith<$Res> get distance;

}
/// @nodoc
class _$NearbyStoreCopyWithImpl<$Res>
    implements $NearbyStoreCopyWith<$Res> {
  _$NearbyStoreCopyWithImpl(this._self, this._then);

  final NearbyStore _self;
  final $Res Function(NearbyStore) _then;

/// Create a copy of NearbyStore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? logo = freezed,Object? coverImage = freezed,Object? address = freezed,Object? city = freezed,Object? distance = null,Object? activeDealCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as StoreDistance,activeDealCount: null == activeDealCount ? _self.activeDealCount : activeDealCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of NearbyStore
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreDistanceCopyWith<$Res> get distance {
  
  return $StoreDistanceCopyWith<$Res>(_self.distance, (value) {
    return _then(_self.copyWith(distance: value));
  });
}
}


/// Adds pattern-matching-related methods to [NearbyStore].
extension NearbyStorePatterns on NearbyStore {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NearbyStore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NearbyStore() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NearbyStore value)  $default,){
final _that = this;
switch (_that) {
case _NearbyStore():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NearbyStore value)?  $default,){
final _that = this;
switch (_that) {
case _NearbyStore() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? logo,  String? coverImage,  String? address,  String? city,  StoreDistance distance,  int activeDealCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NearbyStore() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.logo,_that.coverImage,_that.address,_that.city,_that.distance,_that.activeDealCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String? logo,  String? coverImage,  String? address,  String? city,  StoreDistance distance,  int activeDealCount)  $default,) {final _that = this;
switch (_that) {
case _NearbyStore():
return $default(_that.id,_that.name,_that.description,_that.logo,_that.coverImage,_that.address,_that.city,_that.distance,_that.activeDealCount);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String? logo,  String? coverImage,  String? address,  String? city,  StoreDistance distance,  int activeDealCount)?  $default,) {final _that = this;
switch (_that) {
case _NearbyStore() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.logo,_that.coverImage,_that.address,_that.city,_that.distance,_that.activeDealCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NearbyStore implements NearbyStore {
  const _NearbyStore({required this.id, required this.name, this.description, this.logo, this.coverImage, this.address, this.city, required this.distance, required this.activeDealCount});
  factory _NearbyStore.fromJson(Map<String, dynamic> json) => _$NearbyStoreFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String? logo;
@override final  String? coverImage;
@override final  String? address;
@override final  String? city;
@override final  StoreDistance distance;
@override final  int activeDealCount;

/// Create a copy of NearbyStore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NearbyStoreCopyWith<_NearbyStore> get copyWith => __$NearbyStoreCopyWithImpl<_NearbyStore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NearbyStoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NearbyStore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.coverImage, coverImage) || other.coverImage == coverImage)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.activeDealCount, activeDealCount) || other.activeDealCount == activeDealCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,logo,coverImage,address,city,distance,activeDealCount);

@override
String toString() {
  return 'NearbyStore(id: $id, name: $name, description: $description, logo: $logo, coverImage: $coverImage, address: $address, city: $city, distance: $distance, activeDealCount: $activeDealCount)';
}


}

/// @nodoc
abstract mixin class _$NearbyStoreCopyWith<$Res> implements $NearbyStoreCopyWith<$Res> {
  factory _$NearbyStoreCopyWith(_NearbyStore value, $Res Function(_NearbyStore) _then) = __$NearbyStoreCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String? logo, String? coverImage, String? address, String? city, StoreDistance distance, int activeDealCount
});


@override $StoreDistanceCopyWith<$Res> get distance;

}
/// @nodoc
class __$NearbyStoreCopyWithImpl<$Res>
    implements _$NearbyStoreCopyWith<$Res> {
  __$NearbyStoreCopyWithImpl(this._self, this._then);

  final _NearbyStore _self;
  final $Res Function(_NearbyStore) _then;

/// Create a copy of NearbyStore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? logo = freezed,Object? coverImage = freezed,Object? address = freezed,Object? city = freezed,Object? distance = null,Object? activeDealCount = null,}) {
  return _then(_NearbyStore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,coverImage: freezed == coverImage ? _self.coverImage : coverImage // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as StoreDistance,activeDealCount: null == activeDealCount ? _self.activeDealCount : activeDealCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of NearbyStore
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StoreDistanceCopyWith<$Res> get distance {
  
  return $StoreDistanceCopyWith<$Res>(_self.distance, (value) {
    return _then(_self.copyWith(distance: value));
  });
}
}


/// @nodoc
mixin _$StoreDistance {

 double get value; String get unit;
/// Create a copy of StoreDistance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDistanceCopyWith<StoreDistance> get copyWith => _$StoreDistanceCopyWithImpl<StoreDistance>(this as StoreDistance, _$identity);

  /// Serializes this StoreDistance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDistance&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,unit);

@override
String toString() {
  return 'StoreDistance(value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $StoreDistanceCopyWith<$Res>  {
  factory $StoreDistanceCopyWith(StoreDistance value, $Res Function(StoreDistance) _then) = _$StoreDistanceCopyWithImpl;
@useResult
$Res call({
 double value, String unit
});




}
/// @nodoc
class _$StoreDistanceCopyWithImpl<$Res>
    implements $StoreDistanceCopyWith<$Res> {
  _$StoreDistanceCopyWithImpl(this._self, this._then);

  final StoreDistance _self;
  final $Res Function(StoreDistance) _then;

/// Create a copy of StoreDistance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? unit = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreDistance].
extension StoreDistancePatterns on StoreDistance {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDistance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDistance() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDistance value)  $default,){
final _that = this;
switch (_that) {
case _StoreDistance():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDistance value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDistance() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDistance() when $default != null:
return $default(_that.value,_that.unit);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  String unit)  $default,) {final _that = this;
switch (_that) {
case _StoreDistance():
return $default(_that.value,_that.unit);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _StoreDistance() when $default != null:
return $default(_that.value,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreDistance implements StoreDistance {
  const _StoreDistance({required this.value, required this.unit});
  factory _StoreDistance.fromJson(Map<String, dynamic> json) => _$StoreDistanceFromJson(json);

@override final  double value;
@override final  String unit;

/// Create a copy of StoreDistance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDistanceCopyWith<_StoreDistance> get copyWith => __$StoreDistanceCopyWithImpl<_StoreDistance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreDistanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDistance&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,unit);

@override
String toString() {
  return 'StoreDistance(value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$StoreDistanceCopyWith<$Res> implements $StoreDistanceCopyWith<$Res> {
  factory _$StoreDistanceCopyWith(_StoreDistance value, $Res Function(_StoreDistance) _then) = __$StoreDistanceCopyWithImpl;
@override @useResult
$Res call({
 double value, String unit
});




}
/// @nodoc
class __$StoreDistanceCopyWithImpl<$Res>
    implements _$StoreDistanceCopyWith<$Res> {
  __$StoreDistanceCopyWithImpl(this._self, this._then);

  final _StoreDistance _self;
  final $Res Function(_StoreDistance) _then;

/// Create a copy of StoreDistance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? unit = null,}) {
  return _then(_StoreDistance(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
