// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_offer_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerOffer {

 String get id; String get inventoryId; String? get title; String? get description; DiscountType get discountType; double get discountValue; double get originalPriceSnapshot; double get discountAmount; double get discountedPrice; DateTime get startsAt; DateTime get endsAt; OfferStatus get status; OfferStatus? get effectiveStatus;// Provided dynamically by backend
 String get createdById; DateTime get createdAt; DateTime get updatedAt; DateTime? get deletedAt;// Relationship
 OwnerInventoryItem? get inventory;
/// Create a copy of OwnerOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerOfferCopyWith<OwnerOffer> get copyWith => _$OwnerOfferCopyWithImpl<OwnerOffer>(this as OwnerOffer, _$identity);

  /// Serializes this OwnerOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.originalPriceSnapshot, originalPriceSnapshot) || other.originalPriceSnapshot == originalPriceSnapshot)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.effectiveStatus, effectiveStatus) || other.effectiveStatus == effectiveStatus)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.inventory, inventory) || other.inventory == inventory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inventoryId,title,description,discountType,discountValue,originalPriceSnapshot,discountAmount,discountedPrice,startsAt,endsAt,status,effectiveStatus,createdById,createdAt,updatedAt,deletedAt,inventory);

@override
String toString() {
  return 'OwnerOffer(id: $id, inventoryId: $inventoryId, title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, originalPriceSnapshot: $originalPriceSnapshot, discountAmount: $discountAmount, discountedPrice: $discountedPrice, startsAt: $startsAt, endsAt: $endsAt, status: $status, effectiveStatus: $effectiveStatus, createdById: $createdById, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, inventory: $inventory)';
}


}

/// @nodoc
abstract mixin class $OwnerOfferCopyWith<$Res>  {
  factory $OwnerOfferCopyWith(OwnerOffer value, $Res Function(OwnerOffer) _then) = _$OwnerOfferCopyWithImpl;
@useResult
$Res call({
 String id, String inventoryId, String? title, String? description, DiscountType discountType, double discountValue, double originalPriceSnapshot, double discountAmount, double discountedPrice, DateTime startsAt, DateTime endsAt, OfferStatus status, OfferStatus? effectiveStatus, String createdById, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt, OwnerInventoryItem? inventory
});


$OwnerInventoryItemCopyWith<$Res>? get inventory;

}
/// @nodoc
class _$OwnerOfferCopyWithImpl<$Res>
    implements $OwnerOfferCopyWith<$Res> {
  _$OwnerOfferCopyWithImpl(this._self, this._then);

  final OwnerOffer _self;
  final $Res Function(OwnerOffer) _then;

/// Create a copy of OwnerOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? inventoryId = null,Object? title = freezed,Object? description = freezed,Object? discountType = null,Object? discountValue = null,Object? originalPriceSnapshot = null,Object? discountAmount = null,Object? discountedPrice = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? effectiveStatus = freezed,Object? createdById = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? inventory = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as DiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,originalPriceSnapshot: null == originalPriceSnapshot ? _self.originalPriceSnapshot : originalPriceSnapshot // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: null == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferStatus,effectiveStatus: freezed == effectiveStatus ? _self.effectiveStatus : effectiveStatus // ignore: cast_nullable_to_non_nullable
as OfferStatus?,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inventory: freezed == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as OwnerInventoryItem?,
  ));
}
/// Create a copy of OwnerOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerInventoryItemCopyWith<$Res>? get inventory {
    if (_self.inventory == null) {
    return null;
  }

  return $OwnerInventoryItemCopyWith<$Res>(_self.inventory!, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerOffer].
extension OwnerOfferPatterns on OwnerOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerOffer value)  $default,){
final _that = this;
switch (_that) {
case _OwnerOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerOffer value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String inventoryId,  String? title,  String? description,  DiscountType discountType,  double discountValue,  double originalPriceSnapshot,  double discountAmount,  double discountedPrice,  DateTime startsAt,  DateTime endsAt,  OfferStatus status,  OfferStatus? effectiveStatus,  String createdById,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  OwnerInventoryItem? inventory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerOffer() when $default != null:
return $default(_that.id,_that.inventoryId,_that.title,_that.description,_that.discountType,_that.discountValue,_that.originalPriceSnapshot,_that.discountAmount,_that.discountedPrice,_that.startsAt,_that.endsAt,_that.status,_that.effectiveStatus,_that.createdById,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.inventory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String inventoryId,  String? title,  String? description,  DiscountType discountType,  double discountValue,  double originalPriceSnapshot,  double discountAmount,  double discountedPrice,  DateTime startsAt,  DateTime endsAt,  OfferStatus status,  OfferStatus? effectiveStatus,  String createdById,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  OwnerInventoryItem? inventory)  $default,) {final _that = this;
switch (_that) {
case _OwnerOffer():
return $default(_that.id,_that.inventoryId,_that.title,_that.description,_that.discountType,_that.discountValue,_that.originalPriceSnapshot,_that.discountAmount,_that.discountedPrice,_that.startsAt,_that.endsAt,_that.status,_that.effectiveStatus,_that.createdById,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.inventory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String inventoryId,  String? title,  String? description,  DiscountType discountType,  double discountValue,  double originalPriceSnapshot,  double discountAmount,  double discountedPrice,  DateTime startsAt,  DateTime endsAt,  OfferStatus status,  OfferStatus? effectiveStatus,  String createdById,  DateTime createdAt,  DateTime updatedAt,  DateTime? deletedAt,  OwnerInventoryItem? inventory)?  $default,) {final _that = this;
switch (_that) {
case _OwnerOffer() when $default != null:
return $default(_that.id,_that.inventoryId,_that.title,_that.description,_that.discountType,_that.discountValue,_that.originalPriceSnapshot,_that.discountAmount,_that.discountedPrice,_that.startsAt,_that.endsAt,_that.status,_that.effectiveStatus,_that.createdById,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.inventory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerOffer implements OwnerOffer {
  const _OwnerOffer({required this.id, required this.inventoryId, this.title, this.description, required this.discountType, required this.discountValue, required this.originalPriceSnapshot, required this.discountAmount, required this.discountedPrice, required this.startsAt, required this.endsAt, required this.status, this.effectiveStatus, required this.createdById, required this.createdAt, required this.updatedAt, this.deletedAt, this.inventory});
  factory _OwnerOffer.fromJson(Map<String, dynamic> json) => _$OwnerOfferFromJson(json);

@override final  String id;
@override final  String inventoryId;
@override final  String? title;
@override final  String? description;
@override final  DiscountType discountType;
@override final  double discountValue;
@override final  double originalPriceSnapshot;
@override final  double discountAmount;
@override final  double discountedPrice;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  OfferStatus status;
@override final  OfferStatus? effectiveStatus;
// Provided dynamically by backend
@override final  String createdById;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  DateTime? deletedAt;
// Relationship
@override final  OwnerInventoryItem? inventory;

/// Create a copy of OwnerOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerOfferCopyWith<_OwnerOffer> get copyWith => __$OwnerOfferCopyWithImpl<_OwnerOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.originalPriceSnapshot, originalPriceSnapshot) || other.originalPriceSnapshot == originalPriceSnapshot)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.effectiveStatus, effectiveStatus) || other.effectiveStatus == effectiveStatus)&&(identical(other.createdById, createdById) || other.createdById == createdById)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.inventory, inventory) || other.inventory == inventory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,inventoryId,title,description,discountType,discountValue,originalPriceSnapshot,discountAmount,discountedPrice,startsAt,endsAt,status,effectiveStatus,createdById,createdAt,updatedAt,deletedAt,inventory);

@override
String toString() {
  return 'OwnerOffer(id: $id, inventoryId: $inventoryId, title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, originalPriceSnapshot: $originalPriceSnapshot, discountAmount: $discountAmount, discountedPrice: $discountedPrice, startsAt: $startsAt, endsAt: $endsAt, status: $status, effectiveStatus: $effectiveStatus, createdById: $createdById, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, inventory: $inventory)';
}


}

/// @nodoc
abstract mixin class _$OwnerOfferCopyWith<$Res> implements $OwnerOfferCopyWith<$Res> {
  factory _$OwnerOfferCopyWith(_OwnerOffer value, $Res Function(_OwnerOffer) _then) = __$OwnerOfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String inventoryId, String? title, String? description, DiscountType discountType, double discountValue, double originalPriceSnapshot, double discountAmount, double discountedPrice, DateTime startsAt, DateTime endsAt, OfferStatus status, OfferStatus? effectiveStatus, String createdById, DateTime createdAt, DateTime updatedAt, DateTime? deletedAt, OwnerInventoryItem? inventory
});


@override $OwnerInventoryItemCopyWith<$Res>? get inventory;

}
/// @nodoc
class __$OwnerOfferCopyWithImpl<$Res>
    implements _$OwnerOfferCopyWith<$Res> {
  __$OwnerOfferCopyWithImpl(this._self, this._then);

  final _OwnerOffer _self;
  final $Res Function(_OwnerOffer) _then;

/// Create a copy of OwnerOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? inventoryId = null,Object? title = freezed,Object? description = freezed,Object? discountType = null,Object? discountValue = null,Object? originalPriceSnapshot = null,Object? discountAmount = null,Object? discountedPrice = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? effectiveStatus = freezed,Object? createdById = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? inventory = freezed,}) {
  return _then(_OwnerOffer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as DiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,originalPriceSnapshot: null == originalPriceSnapshot ? _self.originalPriceSnapshot : originalPriceSnapshot // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: null == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferStatus,effectiveStatus: freezed == effectiveStatus ? _self.effectiveStatus : effectiveStatus // ignore: cast_nullable_to_non_nullable
as OfferStatus?,createdById: null == createdById ? _self.createdById : createdById // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,inventory: freezed == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as OwnerInventoryItem?,
  ));
}

/// Create a copy of OwnerOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerInventoryItemCopyWith<$Res>? get inventory {
    if (_self.inventory == null) {
    return null;
  }

  return $OwnerInventoryItemCopyWith<$Res>(_self.inventory!, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}
}


/// @nodoc
mixin _$OwnerOfferPaginatedResponse {

 List<OwnerOffer> get items; OwnerOfferPaginationMeta get meta;
/// Create a copy of OwnerOfferPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerOfferPaginatedResponseCopyWith<OwnerOfferPaginatedResponse> get copyWith => _$OwnerOfferPaginatedResponseCopyWithImpl<OwnerOfferPaginatedResponse>(this as OwnerOfferPaginatedResponse, _$identity);

  /// Serializes this OwnerOfferPaginatedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerOfferPaginatedResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),meta);

@override
String toString() {
  return 'OwnerOfferPaginatedResponse(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $OwnerOfferPaginatedResponseCopyWith<$Res>  {
  factory $OwnerOfferPaginatedResponseCopyWith(OwnerOfferPaginatedResponse value, $Res Function(OwnerOfferPaginatedResponse) _then) = _$OwnerOfferPaginatedResponseCopyWithImpl;
@useResult
$Res call({
 List<OwnerOffer> items, OwnerOfferPaginationMeta meta
});


$OwnerOfferPaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$OwnerOfferPaginatedResponseCopyWithImpl<$Res>
    implements $OwnerOfferPaginatedResponseCopyWith<$Res> {
  _$OwnerOfferPaginatedResponseCopyWithImpl(this._self, this._then);

  final OwnerOfferPaginatedResponse _self;
  final $Res Function(OwnerOfferPaginatedResponse) _then;

/// Create a copy of OwnerOfferPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerOffer>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as OwnerOfferPaginationMeta,
  ));
}
/// Create a copy of OwnerOfferPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerOfferPaginationMetaCopyWith<$Res> get meta {
  
  return $OwnerOfferPaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerOfferPaginatedResponse].
extension OwnerOfferPaginatedResponsePatterns on OwnerOfferPaginatedResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerOfferPaginatedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerOfferPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerOfferPaginatedResponse value)  $default,){
final _that = this;
switch (_that) {
case _OwnerOfferPaginatedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerOfferPaginatedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerOfferPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OwnerOffer> items,  OwnerOfferPaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerOfferPaginatedResponse() when $default != null:
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OwnerOffer> items,  OwnerOfferPaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _OwnerOfferPaginatedResponse():
return $default(_that.items,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OwnerOffer> items,  OwnerOfferPaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _OwnerOfferPaginatedResponse() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerOfferPaginatedResponse implements OwnerOfferPaginatedResponse {
  const _OwnerOfferPaginatedResponse({required final  List<OwnerOffer> items, required this.meta}): _items = items;
  factory _OwnerOfferPaginatedResponse.fromJson(Map<String, dynamic> json) => _$OwnerOfferPaginatedResponseFromJson(json);

 final  List<OwnerOffer> _items;
@override List<OwnerOffer> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OwnerOfferPaginationMeta meta;

/// Create a copy of OwnerOfferPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerOfferPaginatedResponseCopyWith<_OwnerOfferPaginatedResponse> get copyWith => __$OwnerOfferPaginatedResponseCopyWithImpl<_OwnerOfferPaginatedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerOfferPaginatedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerOfferPaginatedResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);

@override
String toString() {
  return 'OwnerOfferPaginatedResponse(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$OwnerOfferPaginatedResponseCopyWith<$Res> implements $OwnerOfferPaginatedResponseCopyWith<$Res> {
  factory _$OwnerOfferPaginatedResponseCopyWith(_OwnerOfferPaginatedResponse value, $Res Function(_OwnerOfferPaginatedResponse) _then) = __$OwnerOfferPaginatedResponseCopyWithImpl;
@override @useResult
$Res call({
 List<OwnerOffer> items, OwnerOfferPaginationMeta meta
});


@override $OwnerOfferPaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$OwnerOfferPaginatedResponseCopyWithImpl<$Res>
    implements _$OwnerOfferPaginatedResponseCopyWith<$Res> {
  __$OwnerOfferPaginatedResponseCopyWithImpl(this._self, this._then);

  final _OwnerOfferPaginatedResponse _self;
  final $Res Function(_OwnerOfferPaginatedResponse) _then;

/// Create a copy of OwnerOfferPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_OwnerOfferPaginatedResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerOffer>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as OwnerOfferPaginationMeta,
  ));
}

/// Create a copy of OwnerOfferPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerOfferPaginationMetaCopyWith<$Res> get meta {
  
  return $OwnerOfferPaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$OwnerOfferPaginationMeta {

 int get total; int get page; int get limit; int get totalPages; bool get hasNextPage; bool get hasPreviousPage;
/// Create a copy of OwnerOfferPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerOfferPaginationMetaCopyWith<OwnerOfferPaginationMeta> get copyWith => _$OwnerOfferPaginationMetaCopyWithImpl<OwnerOfferPaginationMeta>(this as OwnerOfferPaginationMeta, _$identity);

  /// Serializes this OwnerOfferPaginationMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerOfferPaginationMeta&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.hasPreviousPage, hasPreviousPage) || other.hasPreviousPage == hasPreviousPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,page,limit,totalPages,hasNextPage,hasPreviousPage);

@override
String toString() {
  return 'OwnerOfferPaginationMeta(total: $total, page: $page, limit: $limit, totalPages: $totalPages, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
}


}

/// @nodoc
abstract mixin class $OwnerOfferPaginationMetaCopyWith<$Res>  {
  factory $OwnerOfferPaginationMetaCopyWith(OwnerOfferPaginationMeta value, $Res Function(OwnerOfferPaginationMeta) _then) = _$OwnerOfferPaginationMetaCopyWithImpl;
@useResult
$Res call({
 int total, int page, int limit, int totalPages, bool hasNextPage, bool hasPreviousPage
});




}
/// @nodoc
class _$OwnerOfferPaginationMetaCopyWithImpl<$Res>
    implements $OwnerOfferPaginationMetaCopyWith<$Res> {
  _$OwnerOfferPaginationMetaCopyWithImpl(this._self, this._then);

  final OwnerOfferPaginationMeta _self;
  final $Res Function(OwnerOfferPaginationMeta) _then;

/// Create a copy of OwnerOfferPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? page = null,Object? limit = null,Object? totalPages = null,Object? hasNextPage = null,Object? hasPreviousPage = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,hasPreviousPage: null == hasPreviousPage ? _self.hasPreviousPage : hasPreviousPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerOfferPaginationMeta].
extension OwnerOfferPaginationMetaPatterns on OwnerOfferPaginationMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerOfferPaginationMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerOfferPaginationMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerOfferPaginationMeta value)  $default,){
final _that = this;
switch (_that) {
case _OwnerOfferPaginationMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerOfferPaginationMeta value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerOfferPaginationMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int page,  int limit,  int totalPages,  bool hasNextPage,  bool hasPreviousPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerOfferPaginationMeta() when $default != null:
return $default(_that.total,_that.page,_that.limit,_that.totalPages,_that.hasNextPage,_that.hasPreviousPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int page,  int limit,  int totalPages,  bool hasNextPage,  bool hasPreviousPage)  $default,) {final _that = this;
switch (_that) {
case _OwnerOfferPaginationMeta():
return $default(_that.total,_that.page,_that.limit,_that.totalPages,_that.hasNextPage,_that.hasPreviousPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int page,  int limit,  int totalPages,  bool hasNextPage,  bool hasPreviousPage)?  $default,) {final _that = this;
switch (_that) {
case _OwnerOfferPaginationMeta() when $default != null:
return $default(_that.total,_that.page,_that.limit,_that.totalPages,_that.hasNextPage,_that.hasPreviousPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerOfferPaginationMeta implements OwnerOfferPaginationMeta {
  const _OwnerOfferPaginationMeta({required this.total, required this.page, required this.limit, required this.totalPages, required this.hasNextPage, required this.hasPreviousPage});
  factory _OwnerOfferPaginationMeta.fromJson(Map<String, dynamic> json) => _$OwnerOfferPaginationMetaFromJson(json);

@override final  int total;
@override final  int page;
@override final  int limit;
@override final  int totalPages;
@override final  bool hasNextPage;
@override final  bool hasPreviousPage;

/// Create a copy of OwnerOfferPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerOfferPaginationMetaCopyWith<_OwnerOfferPaginationMeta> get copyWith => __$OwnerOfferPaginationMetaCopyWithImpl<_OwnerOfferPaginationMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerOfferPaginationMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerOfferPaginationMeta&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.hasNextPage, hasNextPage) || other.hasNextPage == hasNextPage)&&(identical(other.hasPreviousPage, hasPreviousPage) || other.hasPreviousPage == hasPreviousPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,page,limit,totalPages,hasNextPage,hasPreviousPage);

@override
String toString() {
  return 'OwnerOfferPaginationMeta(total: $total, page: $page, limit: $limit, totalPages: $totalPages, hasNextPage: $hasNextPage, hasPreviousPage: $hasPreviousPage)';
}


}

/// @nodoc
abstract mixin class _$OwnerOfferPaginationMetaCopyWith<$Res> implements $OwnerOfferPaginationMetaCopyWith<$Res> {
  factory _$OwnerOfferPaginationMetaCopyWith(_OwnerOfferPaginationMeta value, $Res Function(_OwnerOfferPaginationMeta) _then) = __$OwnerOfferPaginationMetaCopyWithImpl;
@override @useResult
$Res call({
 int total, int page, int limit, int totalPages, bool hasNextPage, bool hasPreviousPage
});




}
/// @nodoc
class __$OwnerOfferPaginationMetaCopyWithImpl<$Res>
    implements _$OwnerOfferPaginationMetaCopyWith<$Res> {
  __$OwnerOfferPaginationMetaCopyWithImpl(this._self, this._then);

  final _OwnerOfferPaginationMeta _self;
  final $Res Function(_OwnerOfferPaginationMeta) _then;

/// Create a copy of OwnerOfferPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? page = null,Object? limit = null,Object? totalPages = null,Object? hasNextPage = null,Object? hasPreviousPage = null,}) {
  return _then(_OwnerOfferPaginationMeta(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,hasNextPage: null == hasNextPage ? _self.hasNextPage : hasNextPage // ignore: cast_nullable_to_non_nullable
as bool,hasPreviousPage: null == hasPreviousPage ? _self.hasPreviousPage : hasPreviousPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CreateOfferRequest {

 String? get title; String? get description; DiscountType get discountType; double get discountValue; String get startsAt;// ISO 8601
 String get endsAt;
/// Create a copy of CreateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateOfferRequestCopyWith<CreateOfferRequest> get copyWith => _$CreateOfferRequestCopyWithImpl<CreateOfferRequest>(this as CreateOfferRequest, _$identity);

  /// Serializes this CreateOfferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateOfferRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,discountType,discountValue,startsAt,endsAt);

@override
String toString() {
  return 'CreateOfferRequest(title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $CreateOfferRequestCopyWith<$Res>  {
  factory $CreateOfferRequestCopyWith(CreateOfferRequest value, $Res Function(CreateOfferRequest) _then) = _$CreateOfferRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, DiscountType discountType, double discountValue, String startsAt, String endsAt
});




}
/// @nodoc
class _$CreateOfferRequestCopyWithImpl<$Res>
    implements $CreateOfferRequestCopyWith<$Res> {
  _$CreateOfferRequestCopyWithImpl(this._self, this._then);

  final CreateOfferRequest _self;
  final $Res Function(CreateOfferRequest) _then;

/// Create a copy of CreateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? discountType = null,Object? discountValue = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as DiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateOfferRequest].
extension CreateOfferRequestPatterns on CreateOfferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateOfferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateOfferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateOfferRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateOfferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateOfferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateOfferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  DiscountType discountType,  double discountValue,  String startsAt,  String endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateOfferRequest() when $default != null:
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  DiscountType discountType,  double discountValue,  String startsAt,  String endsAt)  $default,) {final _that = this;
switch (_that) {
case _CreateOfferRequest():
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  DiscountType discountType,  double discountValue,  String startsAt,  String endsAt)?  $default,) {final _that = this;
switch (_that) {
case _CreateOfferRequest() when $default != null:
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateOfferRequest implements CreateOfferRequest {
  const _CreateOfferRequest({this.title, this.description, required this.discountType, required this.discountValue, required this.startsAt, required this.endsAt});
  factory _CreateOfferRequest.fromJson(Map<String, dynamic> json) => _$CreateOfferRequestFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  DiscountType discountType;
@override final  double discountValue;
@override final  String startsAt;
// ISO 8601
@override final  String endsAt;

/// Create a copy of CreateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateOfferRequestCopyWith<_CreateOfferRequest> get copyWith => __$CreateOfferRequestCopyWithImpl<_CreateOfferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateOfferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateOfferRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,discountType,discountValue,startsAt,endsAt);

@override
String toString() {
  return 'CreateOfferRequest(title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$CreateOfferRequestCopyWith<$Res> implements $CreateOfferRequestCopyWith<$Res> {
  factory _$CreateOfferRequestCopyWith(_CreateOfferRequest value, $Res Function(_CreateOfferRequest) _then) = __$CreateOfferRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, DiscountType discountType, double discountValue, String startsAt, String endsAt
});




}
/// @nodoc
class __$CreateOfferRequestCopyWithImpl<$Res>
    implements _$CreateOfferRequestCopyWith<$Res> {
  __$CreateOfferRequestCopyWithImpl(this._self, this._then);

  final _CreateOfferRequest _self;
  final $Res Function(_CreateOfferRequest) _then;

/// Create a copy of CreateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? discountType = null,Object? discountValue = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_CreateOfferRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as DiscountType,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$UpdateOfferRequest {

 String? get title; String? get description; DiscountType? get discountType; double? get discountValue; String? get startsAt; String? get endsAt;
/// Create a copy of UpdateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateOfferRequestCopyWith<UpdateOfferRequest> get copyWith => _$UpdateOfferRequestCopyWithImpl<UpdateOfferRequest>(this as UpdateOfferRequest, _$identity);

  /// Serializes this UpdateOfferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateOfferRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,discountType,discountValue,startsAt,endsAt);

@override
String toString() {
  return 'UpdateOfferRequest(title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $UpdateOfferRequestCopyWith<$Res>  {
  factory $UpdateOfferRequestCopyWith(UpdateOfferRequest value, $Res Function(UpdateOfferRequest) _then) = _$UpdateOfferRequestCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, DiscountType? discountType, double? discountValue, String? startsAt, String? endsAt
});




}
/// @nodoc
class _$UpdateOfferRequestCopyWithImpl<$Res>
    implements $UpdateOfferRequestCopyWith<$Res> {
  _$UpdateOfferRequestCopyWithImpl(this._self, this._then);

  final UpdateOfferRequest _self;
  final $Res Function(UpdateOfferRequest) _then;

/// Create a copy of UpdateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? discountType = freezed,Object? discountValue = freezed,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as DiscountType?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateOfferRequest].
extension UpdateOfferRequestPatterns on UpdateOfferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateOfferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateOfferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateOfferRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateOfferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateOfferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateOfferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  DiscountType? discountType,  double? discountValue,  String? startsAt,  String? endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateOfferRequest() when $default != null:
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  DiscountType? discountType,  double? discountValue,  String? startsAt,  String? endsAt)  $default,) {final _that = this;
switch (_that) {
case _UpdateOfferRequest():
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  DiscountType? discountType,  double? discountValue,  String? startsAt,  String? endsAt)?  $default,) {final _that = this;
switch (_that) {
case _UpdateOfferRequest() when $default != null:
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateOfferRequest implements UpdateOfferRequest {
  const _UpdateOfferRequest({this.title, this.description, this.discountType, this.discountValue, this.startsAt, this.endsAt});
  factory _UpdateOfferRequest.fromJson(Map<String, dynamic> json) => _$UpdateOfferRequestFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  DiscountType? discountType;
@override final  double? discountValue;
@override final  String? startsAt;
@override final  String? endsAt;

/// Create a copy of UpdateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateOfferRequestCopyWith<_UpdateOfferRequest> get copyWith => __$UpdateOfferRequestCopyWithImpl<_UpdateOfferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateOfferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateOfferRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,discountType,discountValue,startsAt,endsAt);

@override
String toString() {
  return 'UpdateOfferRequest(title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$UpdateOfferRequestCopyWith<$Res> implements $UpdateOfferRequestCopyWith<$Res> {
  factory _$UpdateOfferRequestCopyWith(_UpdateOfferRequest value, $Res Function(_UpdateOfferRequest) _then) = __$UpdateOfferRequestCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, DiscountType? discountType, double? discountValue, String? startsAt, String? endsAt
});




}
/// @nodoc
class __$UpdateOfferRequestCopyWithImpl<$Res>
    implements _$UpdateOfferRequestCopyWith<$Res> {
  __$UpdateOfferRequestCopyWithImpl(this._self, this._then);

  final _UpdateOfferRequest _self;
  final $Res Function(_UpdateOfferRequest) _then;

/// Create a copy of UpdateOfferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? discountType = freezed,Object? discountValue = freezed,Object? startsAt = freezed,Object? endsAt = freezed,}) {
  return _then(_UpdateOfferRequest(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: freezed == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as DiscountType?,discountValue: freezed == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double?,startsAt: freezed == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as String?,endsAt: freezed == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
