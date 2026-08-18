// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_reservation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservationCustomer {

 String get id; String get name; String? get phone;
/// Create a copy of ReservationCustomer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCustomerCopyWith<ReservationCustomer> get copyWith => _$ReservationCustomerCopyWithImpl<ReservationCustomer>(this as ReservationCustomer, _$identity);

  /// Serializes this ReservationCustomer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationCustomer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone);

@override
String toString() {
  return 'ReservationCustomer(id: $id, name: $name, phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ReservationCustomerCopyWith<$Res>  {
  factory $ReservationCustomerCopyWith(ReservationCustomer value, $Res Function(ReservationCustomer) _then) = _$ReservationCustomerCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? phone
});




}
/// @nodoc
class _$ReservationCustomerCopyWithImpl<$Res>
    implements $ReservationCustomerCopyWith<$Res> {
  _$ReservationCustomerCopyWithImpl(this._self, this._then);

  final ReservationCustomer _self;
  final $Res Function(ReservationCustomer) _then;

/// Create a copy of ReservationCustomer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationCustomer].
extension ReservationCustomerPatterns on ReservationCustomer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationCustomer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationCustomer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationCustomer value)  $default,){
final _that = this;
switch (_that) {
case _ReservationCustomer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationCustomer value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationCustomer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? phone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationCustomer() when $default != null:
return $default(_that.id,_that.name,_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? phone)  $default,) {final _that = this;
switch (_that) {
case _ReservationCustomer():
return $default(_that.id,_that.name,_that.phone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? phone)?  $default,) {final _that = this;
switch (_that) {
case _ReservationCustomer() when $default != null:
return $default(_that.id,_that.name,_that.phone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationCustomer implements ReservationCustomer {
  const _ReservationCustomer({required this.id, required this.name, this.phone});
  factory _ReservationCustomer.fromJson(Map<String, dynamic> json) => _$ReservationCustomerFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? phone;

/// Create a copy of ReservationCustomer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCustomerCopyWith<_ReservationCustomer> get copyWith => __$ReservationCustomerCopyWithImpl<_ReservationCustomer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationCustomerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationCustomer&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phone);

@override
String toString() {
  return 'ReservationCustomer(id: $id, name: $name, phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$ReservationCustomerCopyWith<$Res> implements $ReservationCustomerCopyWith<$Res> {
  factory _$ReservationCustomerCopyWith(_ReservationCustomer value, $Res Function(_ReservationCustomer) _then) = __$ReservationCustomerCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? phone
});




}
/// @nodoc
class __$ReservationCustomerCopyWithImpl<$Res>
    implements _$ReservationCustomerCopyWith<$Res> {
  __$ReservationCustomerCopyWithImpl(this._self, this._then);

  final _ReservationCustomer _self;
  final $Res Function(_ReservationCustomer) _then;

/// Create a copy of ReservationCustomer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = freezed,}) {
  return _then(_ReservationCustomer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OwnerReservationItem {

 String get id; String get reservationId; String get inventoryId; String get productId; String? get offerId; int get quantity; double get originalUnitPrice; double get discountedUnitPrice; double get discountAmount; double get subtotal; InventoryProduct? get product;
/// Create a copy of OwnerReservationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerReservationItemCopyWith<OwnerReservationItem> get copyWith => _$OwnerReservationItemCopyWithImpl<OwnerReservationItem>(this as OwnerReservationItem, _$identity);

  /// Serializes this OwnerReservationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerReservationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.originalUnitPrice, originalUnitPrice) || other.originalUnitPrice == originalUnitPrice)&&(identical(other.discountedUnitPrice, discountedUnitPrice) || other.discountedUnitPrice == discountedUnitPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reservationId,inventoryId,productId,offerId,quantity,originalUnitPrice,discountedUnitPrice,discountAmount,subtotal,product);

@override
String toString() {
  return 'OwnerReservationItem(id: $id, reservationId: $reservationId, inventoryId: $inventoryId, productId: $productId, offerId: $offerId, quantity: $quantity, originalUnitPrice: $originalUnitPrice, discountedUnitPrice: $discountedUnitPrice, discountAmount: $discountAmount, subtotal: $subtotal, product: $product)';
}


}

/// @nodoc
abstract mixin class $OwnerReservationItemCopyWith<$Res>  {
  factory $OwnerReservationItemCopyWith(OwnerReservationItem value, $Res Function(OwnerReservationItem) _then) = _$OwnerReservationItemCopyWithImpl;
@useResult
$Res call({
 String id, String reservationId, String inventoryId, String productId, String? offerId, int quantity, double originalUnitPrice, double discountedUnitPrice, double discountAmount, double subtotal, InventoryProduct? product
});


$InventoryProductCopyWith<$Res>? get product;

}
/// @nodoc
class _$OwnerReservationItemCopyWithImpl<$Res>
    implements $OwnerReservationItemCopyWith<$Res> {
  _$OwnerReservationItemCopyWithImpl(this._self, this._then);

  final OwnerReservationItem _self;
  final $Res Function(OwnerReservationItem) _then;

/// Create a copy of OwnerReservationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reservationId = null,Object? inventoryId = null,Object? productId = null,Object? offerId = freezed,Object? quantity = null,Object? originalUnitPrice = null,Object? discountedUnitPrice = null,Object? discountAmount = null,Object? subtotal = null,Object? product = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,offerId: freezed == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,originalUnitPrice: null == originalUnitPrice ? _self.originalUnitPrice : originalUnitPrice // ignore: cast_nullable_to_non_nullable
as double,discountedUnitPrice: null == discountedUnitPrice ? _self.discountedUnitPrice : discountedUnitPrice // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InventoryProduct?,
  ));
}
/// Create a copy of OwnerReservationItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $InventoryProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerReservationItem].
extension OwnerReservationItemPatterns on OwnerReservationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerReservationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerReservationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerReservationItem value)  $default,){
final _that = this;
switch (_that) {
case _OwnerReservationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerReservationItem value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerReservationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reservationId,  String inventoryId,  String productId,  String? offerId,  int quantity,  double originalUnitPrice,  double discountedUnitPrice,  double discountAmount,  double subtotal,  InventoryProduct? product)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerReservationItem() when $default != null:
return $default(_that.id,_that.reservationId,_that.inventoryId,_that.productId,_that.offerId,_that.quantity,_that.originalUnitPrice,_that.discountedUnitPrice,_that.discountAmount,_that.subtotal,_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reservationId,  String inventoryId,  String productId,  String? offerId,  int quantity,  double originalUnitPrice,  double discountedUnitPrice,  double discountAmount,  double subtotal,  InventoryProduct? product)  $default,) {final _that = this;
switch (_that) {
case _OwnerReservationItem():
return $default(_that.id,_that.reservationId,_that.inventoryId,_that.productId,_that.offerId,_that.quantity,_that.originalUnitPrice,_that.discountedUnitPrice,_that.discountAmount,_that.subtotal,_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reservationId,  String inventoryId,  String productId,  String? offerId,  int quantity,  double originalUnitPrice,  double discountedUnitPrice,  double discountAmount,  double subtotal,  InventoryProduct? product)?  $default,) {final _that = this;
switch (_that) {
case _OwnerReservationItem() when $default != null:
return $default(_that.id,_that.reservationId,_that.inventoryId,_that.productId,_that.offerId,_that.quantity,_that.originalUnitPrice,_that.discountedUnitPrice,_that.discountAmount,_that.subtotal,_that.product);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerReservationItem implements OwnerReservationItem {
  const _OwnerReservationItem({required this.id, required this.reservationId, required this.inventoryId, required this.productId, this.offerId, required this.quantity, required this.originalUnitPrice, required this.discountedUnitPrice, required this.discountAmount, required this.subtotal, this.product});
  factory _OwnerReservationItem.fromJson(Map<String, dynamic> json) => _$OwnerReservationItemFromJson(json);

@override final  String id;
@override final  String reservationId;
@override final  String inventoryId;
@override final  String productId;
@override final  String? offerId;
@override final  int quantity;
@override final  double originalUnitPrice;
@override final  double discountedUnitPrice;
@override final  double discountAmount;
@override final  double subtotal;
@override final  InventoryProduct? product;

/// Create a copy of OwnerReservationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerReservationItemCopyWith<_OwnerReservationItem> get copyWith => __$OwnerReservationItemCopyWithImpl<_OwnerReservationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerReservationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerReservationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.originalUnitPrice, originalUnitPrice) || other.originalUnitPrice == originalUnitPrice)&&(identical(other.discountedUnitPrice, discountedUnitPrice) || other.discountedUnitPrice == discountedUnitPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reservationId,inventoryId,productId,offerId,quantity,originalUnitPrice,discountedUnitPrice,discountAmount,subtotal,product);

@override
String toString() {
  return 'OwnerReservationItem(id: $id, reservationId: $reservationId, inventoryId: $inventoryId, productId: $productId, offerId: $offerId, quantity: $quantity, originalUnitPrice: $originalUnitPrice, discountedUnitPrice: $discountedUnitPrice, discountAmount: $discountAmount, subtotal: $subtotal, product: $product)';
}


}

/// @nodoc
abstract mixin class _$OwnerReservationItemCopyWith<$Res> implements $OwnerReservationItemCopyWith<$Res> {
  factory _$OwnerReservationItemCopyWith(_OwnerReservationItem value, $Res Function(_OwnerReservationItem) _then) = __$OwnerReservationItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String reservationId, String inventoryId, String productId, String? offerId, int quantity, double originalUnitPrice, double discountedUnitPrice, double discountAmount, double subtotal, InventoryProduct? product
});


@override $InventoryProductCopyWith<$Res>? get product;

}
/// @nodoc
class __$OwnerReservationItemCopyWithImpl<$Res>
    implements _$OwnerReservationItemCopyWith<$Res> {
  __$OwnerReservationItemCopyWithImpl(this._self, this._then);

  final _OwnerReservationItem _self;
  final $Res Function(_OwnerReservationItem) _then;

/// Create a copy of OwnerReservationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reservationId = null,Object? inventoryId = null,Object? productId = null,Object? offerId = freezed,Object? quantity = null,Object? originalUnitPrice = null,Object? discountedUnitPrice = null,Object? discountAmount = null,Object? subtotal = null,Object? product = freezed,}) {
  return _then(_OwnerReservationItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reservationId: null == reservationId ? _self.reservationId : reservationId // ignore: cast_nullable_to_non_nullable
as String,inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,offerId: freezed == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,originalUnitPrice: null == originalUnitPrice ? _self.originalUnitPrice : originalUnitPrice // ignore: cast_nullable_to_non_nullable
as double,discountedUnitPrice: null == discountedUnitPrice ? _self.discountedUnitPrice : discountedUnitPrice // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,product: freezed == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InventoryProduct?,
  ));
}

/// Create a copy of OwnerReservationItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryProductCopyWith<$Res>? get product {
    if (_self.product == null) {
    return null;
  }

  return $InventoryProductCopyWith<$Res>(_self.product!, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$OwnerReservation {

 String get id; String get customerId; String get storeId; String get reservationCode; String? get idempotencyKey; ReservationStatus get status; double get subtotal; double get totalDiscount; double get totalAmount; DateTime get reservedAt; DateTime get expiresAt; DateTime? get confirmedAt; DateTime? get readyAt; DateTime? get completedAt; DateTime? get cancelledAt; DateTime? get rejectedAt; DateTime? get createdAt; DateTime? get updatedAt; Map<String, dynamic>? get pickupInfo; String? get notes; String? get cancellationReason; String? get rejectionReason; ReservationCustomer? get customer; List<OwnerReservationItem> get items;
/// Create a copy of OwnerReservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerReservationCopyWith<OwnerReservation> get copyWith => _$OwnerReservationCopyWithImpl<OwnerReservation>(this as OwnerReservation, _$identity);

  /// Serializes this OwnerReservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerReservation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.reservationCode, reservationCode) || other.reservationCode == reservationCode)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.reservedAt, reservedAt) || other.reservedAt == reservedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.pickupInfo, pickupInfo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,storeId,reservationCode,idempotencyKey,status,subtotal,totalDiscount,totalAmount,reservedAt,expiresAt,confirmedAt,readyAt,completedAt,cancelledAt,rejectedAt,createdAt,updatedAt,const DeepCollectionEquality().hash(pickupInfo),notes,cancellationReason,rejectionReason,customer,const DeepCollectionEquality().hash(items)]);

@override
String toString() {
  return 'OwnerReservation(id: $id, customerId: $customerId, storeId: $storeId, reservationCode: $reservationCode, idempotencyKey: $idempotencyKey, status: $status, subtotal: $subtotal, totalDiscount: $totalDiscount, totalAmount: $totalAmount, reservedAt: $reservedAt, expiresAt: $expiresAt, confirmedAt: $confirmedAt, readyAt: $readyAt, completedAt: $completedAt, cancelledAt: $cancelledAt, rejectedAt: $rejectedAt, createdAt: $createdAt, updatedAt: $updatedAt, pickupInfo: $pickupInfo, notes: $notes, cancellationReason: $cancellationReason, rejectionReason: $rejectionReason, customer: $customer, items: $items)';
}


}

/// @nodoc
abstract mixin class $OwnerReservationCopyWith<$Res>  {
  factory $OwnerReservationCopyWith(OwnerReservation value, $Res Function(OwnerReservation) _then) = _$OwnerReservationCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, String storeId, String reservationCode, String? idempotencyKey, ReservationStatus status, double subtotal, double totalDiscount, double totalAmount, DateTime reservedAt, DateTime expiresAt, DateTime? confirmedAt, DateTime? readyAt, DateTime? completedAt, DateTime? cancelledAt, DateTime? rejectedAt, DateTime? createdAt, DateTime? updatedAt, Map<String, dynamic>? pickupInfo, String? notes, String? cancellationReason, String? rejectionReason, ReservationCustomer? customer, List<OwnerReservationItem> items
});


$ReservationCustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class _$OwnerReservationCopyWithImpl<$Res>
    implements $OwnerReservationCopyWith<$Res> {
  _$OwnerReservationCopyWithImpl(this._self, this._then);

  final OwnerReservation _self;
  final $Res Function(OwnerReservation) _then;

/// Create a copy of OwnerReservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? storeId = null,Object? reservationCode = null,Object? idempotencyKey = freezed,Object? status = null,Object? subtotal = null,Object? totalDiscount = null,Object? totalAmount = null,Object? reservedAt = null,Object? expiresAt = null,Object? confirmedAt = freezed,Object? readyAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? rejectedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? pickupInfo = freezed,Object? notes = freezed,Object? cancellationReason = freezed,Object? rejectionReason = freezed,Object? customer = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,reservationCode: null == reservationCode ? _self.reservationCode : reservationCode // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,reservedAt: null == reservedAt ? _self.reservedAt : reservedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pickupInfo: freezed == pickupInfo ? _self.pickupInfo : pickupInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as ReservationCustomer?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerReservationItem>,
  ));
}
/// Create a copy of OwnerReservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationCustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $ReservationCustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerReservation].
extension OwnerReservationPatterns on OwnerReservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerReservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerReservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerReservation value)  $default,){
final _that = this;
switch (_that) {
case _OwnerReservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerReservation value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerReservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  String storeId,  String reservationCode,  String? idempotencyKey,  ReservationStatus status,  double subtotal,  double totalDiscount,  double totalAmount,  DateTime reservedAt,  DateTime expiresAt,  DateTime? confirmedAt,  DateTime? readyAt,  DateTime? completedAt,  DateTime? cancelledAt,  DateTime? rejectedAt,  DateTime? createdAt,  DateTime? updatedAt,  Map<String, dynamic>? pickupInfo,  String? notes,  String? cancellationReason,  String? rejectionReason,  ReservationCustomer? customer,  List<OwnerReservationItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerReservation() when $default != null:
return $default(_that.id,_that.customerId,_that.storeId,_that.reservationCode,_that.idempotencyKey,_that.status,_that.subtotal,_that.totalDiscount,_that.totalAmount,_that.reservedAt,_that.expiresAt,_that.confirmedAt,_that.readyAt,_that.completedAt,_that.cancelledAt,_that.rejectedAt,_that.createdAt,_that.updatedAt,_that.pickupInfo,_that.notes,_that.cancellationReason,_that.rejectionReason,_that.customer,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  String storeId,  String reservationCode,  String? idempotencyKey,  ReservationStatus status,  double subtotal,  double totalDiscount,  double totalAmount,  DateTime reservedAt,  DateTime expiresAt,  DateTime? confirmedAt,  DateTime? readyAt,  DateTime? completedAt,  DateTime? cancelledAt,  DateTime? rejectedAt,  DateTime? createdAt,  DateTime? updatedAt,  Map<String, dynamic>? pickupInfo,  String? notes,  String? cancellationReason,  String? rejectionReason,  ReservationCustomer? customer,  List<OwnerReservationItem> items)  $default,) {final _that = this;
switch (_that) {
case _OwnerReservation():
return $default(_that.id,_that.customerId,_that.storeId,_that.reservationCode,_that.idempotencyKey,_that.status,_that.subtotal,_that.totalDiscount,_that.totalAmount,_that.reservedAt,_that.expiresAt,_that.confirmedAt,_that.readyAt,_that.completedAt,_that.cancelledAt,_that.rejectedAt,_that.createdAt,_that.updatedAt,_that.pickupInfo,_that.notes,_that.cancellationReason,_that.rejectionReason,_that.customer,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  String storeId,  String reservationCode,  String? idempotencyKey,  ReservationStatus status,  double subtotal,  double totalDiscount,  double totalAmount,  DateTime reservedAt,  DateTime expiresAt,  DateTime? confirmedAt,  DateTime? readyAt,  DateTime? completedAt,  DateTime? cancelledAt,  DateTime? rejectedAt,  DateTime? createdAt,  DateTime? updatedAt,  Map<String, dynamic>? pickupInfo,  String? notes,  String? cancellationReason,  String? rejectionReason,  ReservationCustomer? customer,  List<OwnerReservationItem> items)?  $default,) {final _that = this;
switch (_that) {
case _OwnerReservation() when $default != null:
return $default(_that.id,_that.customerId,_that.storeId,_that.reservationCode,_that.idempotencyKey,_that.status,_that.subtotal,_that.totalDiscount,_that.totalAmount,_that.reservedAt,_that.expiresAt,_that.confirmedAt,_that.readyAt,_that.completedAt,_that.cancelledAt,_that.rejectedAt,_that.createdAt,_that.updatedAt,_that.pickupInfo,_that.notes,_that.cancellationReason,_that.rejectionReason,_that.customer,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerReservation implements OwnerReservation {
  const _OwnerReservation({required this.id, required this.customerId, required this.storeId, required this.reservationCode, this.idempotencyKey, required this.status, required this.subtotal, required this.totalDiscount, required this.totalAmount, required this.reservedAt, required this.expiresAt, this.confirmedAt, this.readyAt, this.completedAt, this.cancelledAt, this.rejectedAt, this.createdAt, this.updatedAt, final  Map<String, dynamic>? pickupInfo, this.notes, this.cancellationReason, this.rejectionReason, this.customer, final  List<OwnerReservationItem> items = const []}): _pickupInfo = pickupInfo,_items = items;
  factory _OwnerReservation.fromJson(Map<String, dynamic> json) => _$OwnerReservationFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  String storeId;
@override final  String reservationCode;
@override final  String? idempotencyKey;
@override final  ReservationStatus status;
@override final  double subtotal;
@override final  double totalDiscount;
@override final  double totalAmount;
@override final  DateTime reservedAt;
@override final  DateTime expiresAt;
@override final  DateTime? confirmedAt;
@override final  DateTime? readyAt;
@override final  DateTime? completedAt;
@override final  DateTime? cancelledAt;
@override final  DateTime? rejectedAt;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  Map<String, dynamic>? _pickupInfo;
@override Map<String, dynamic>? get pickupInfo {
  final value = _pickupInfo;
  if (value == null) return null;
  if (_pickupInfo is EqualUnmodifiableMapView) return _pickupInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? notes;
@override final  String? cancellationReason;
@override final  String? rejectionReason;
@override final  ReservationCustomer? customer;
 final  List<OwnerReservationItem> _items;
@override@JsonKey() List<OwnerReservationItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of OwnerReservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerReservationCopyWith<_OwnerReservation> get copyWith => __$OwnerReservationCopyWithImpl<_OwnerReservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerReservationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerReservation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.reservationCode, reservationCode) || other.reservationCode == reservationCode)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.reservedAt, reservedAt) || other.reservedAt == reservedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.confirmedAt, confirmedAt) || other.confirmedAt == confirmedAt)&&(identical(other.readyAt, readyAt) || other.readyAt == readyAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.rejectedAt, rejectedAt) || other.rejectedAt == rejectedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._pickupInfo, _pickupInfo)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.cancellationReason, cancellationReason) || other.cancellationReason == cancellationReason)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.customer, customer) || other.customer == customer)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerId,storeId,reservationCode,idempotencyKey,status,subtotal,totalDiscount,totalAmount,reservedAt,expiresAt,confirmedAt,readyAt,completedAt,cancelledAt,rejectedAt,createdAt,updatedAt,const DeepCollectionEquality().hash(_pickupInfo),notes,cancellationReason,rejectionReason,customer,const DeepCollectionEquality().hash(_items)]);

@override
String toString() {
  return 'OwnerReservation(id: $id, customerId: $customerId, storeId: $storeId, reservationCode: $reservationCode, idempotencyKey: $idempotencyKey, status: $status, subtotal: $subtotal, totalDiscount: $totalDiscount, totalAmount: $totalAmount, reservedAt: $reservedAt, expiresAt: $expiresAt, confirmedAt: $confirmedAt, readyAt: $readyAt, completedAt: $completedAt, cancelledAt: $cancelledAt, rejectedAt: $rejectedAt, createdAt: $createdAt, updatedAt: $updatedAt, pickupInfo: $pickupInfo, notes: $notes, cancellationReason: $cancellationReason, rejectionReason: $rejectionReason, customer: $customer, items: $items)';
}


}

/// @nodoc
abstract mixin class _$OwnerReservationCopyWith<$Res> implements $OwnerReservationCopyWith<$Res> {
  factory _$OwnerReservationCopyWith(_OwnerReservation value, $Res Function(_OwnerReservation) _then) = __$OwnerReservationCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, String storeId, String reservationCode, String? idempotencyKey, ReservationStatus status, double subtotal, double totalDiscount, double totalAmount, DateTime reservedAt, DateTime expiresAt, DateTime? confirmedAt, DateTime? readyAt, DateTime? completedAt, DateTime? cancelledAt, DateTime? rejectedAt, DateTime? createdAt, DateTime? updatedAt, Map<String, dynamic>? pickupInfo, String? notes, String? cancellationReason, String? rejectionReason, ReservationCustomer? customer, List<OwnerReservationItem> items
});


@override $ReservationCustomerCopyWith<$Res>? get customer;

}
/// @nodoc
class __$OwnerReservationCopyWithImpl<$Res>
    implements _$OwnerReservationCopyWith<$Res> {
  __$OwnerReservationCopyWithImpl(this._self, this._then);

  final _OwnerReservation _self;
  final $Res Function(_OwnerReservation) _then;

/// Create a copy of OwnerReservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? storeId = null,Object? reservationCode = null,Object? idempotencyKey = freezed,Object? status = null,Object? subtotal = null,Object? totalDiscount = null,Object? totalAmount = null,Object? reservedAt = null,Object? expiresAt = null,Object? confirmedAt = freezed,Object? readyAt = freezed,Object? completedAt = freezed,Object? cancelledAt = freezed,Object? rejectedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? pickupInfo = freezed,Object? notes = freezed,Object? cancellationReason = freezed,Object? rejectionReason = freezed,Object? customer = freezed,Object? items = null,}) {
  return _then(_OwnerReservation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,reservationCode: null == reservationCode ? _self.reservationCode : reservationCode // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,reservedAt: null == reservedAt ? _self.reservedAt : reservedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,confirmedAt: freezed == confirmedAt ? _self.confirmedAt : confirmedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,readyAt: freezed == readyAt ? _self.readyAt : readyAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectedAt: freezed == rejectedAt ? _self.rejectedAt : rejectedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pickupInfo: freezed == pickupInfo ? _self._pickupInfo : pickupInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,cancellationReason: freezed == cancellationReason ? _self.cancellationReason : cancellationReason // ignore: cast_nullable_to_non_nullable
as String?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,customer: freezed == customer ? _self.customer : customer // ignore: cast_nullable_to_non_nullable
as ReservationCustomer?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerReservationItem>,
  ));
}

/// Create a copy of OwnerReservation
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReservationCustomerCopyWith<$Res>? get customer {
    if (_self.customer == null) {
    return null;
  }

  return $ReservationCustomerCopyWith<$Res>(_self.customer!, (value) {
    return _then(_self.copyWith(customer: value));
  });
}
}


/// @nodoc
mixin _$OwnerReservationPaginatedResponse {

 List<OwnerReservation> get items; OwnerReservationPaginationMeta get meta;
/// Create a copy of OwnerReservationPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerReservationPaginatedResponseCopyWith<OwnerReservationPaginatedResponse> get copyWith => _$OwnerReservationPaginatedResponseCopyWithImpl<OwnerReservationPaginatedResponse>(this as OwnerReservationPaginatedResponse, _$identity);

  /// Serializes this OwnerReservationPaginatedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerReservationPaginatedResponse&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),meta);

@override
String toString() {
  return 'OwnerReservationPaginatedResponse(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $OwnerReservationPaginatedResponseCopyWith<$Res>  {
  factory $OwnerReservationPaginatedResponseCopyWith(OwnerReservationPaginatedResponse value, $Res Function(OwnerReservationPaginatedResponse) _then) = _$OwnerReservationPaginatedResponseCopyWithImpl;
@useResult
$Res call({
 List<OwnerReservation> items, OwnerReservationPaginationMeta meta
});


$OwnerReservationPaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class _$OwnerReservationPaginatedResponseCopyWithImpl<$Res>
    implements $OwnerReservationPaginatedResponseCopyWith<$Res> {
  _$OwnerReservationPaginatedResponseCopyWithImpl(this._self, this._then);

  final OwnerReservationPaginatedResponse _self;
  final $Res Function(OwnerReservationPaginatedResponse) _then;

/// Create a copy of OwnerReservationPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerReservation>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as OwnerReservationPaginationMeta,
  ));
}
/// Create a copy of OwnerReservationPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerReservationPaginationMetaCopyWith<$Res> get meta {
  
  return $OwnerReservationPaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerReservationPaginatedResponse].
extension OwnerReservationPaginatedResponsePatterns on OwnerReservationPaginatedResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerReservationPaginatedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerReservationPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerReservationPaginatedResponse value)  $default,){
final _that = this;
switch (_that) {
case _OwnerReservationPaginatedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerReservationPaginatedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerReservationPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OwnerReservation> items,  OwnerReservationPaginationMeta meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerReservationPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OwnerReservation> items,  OwnerReservationPaginationMeta meta)  $default,) {final _that = this;
switch (_that) {
case _OwnerReservationPaginatedResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OwnerReservation> items,  OwnerReservationPaginationMeta meta)?  $default,) {final _that = this;
switch (_that) {
case _OwnerReservationPaginatedResponse() when $default != null:
return $default(_that.items,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerReservationPaginatedResponse implements OwnerReservationPaginatedResponse {
  const _OwnerReservationPaginatedResponse({required final  List<OwnerReservation> items, required this.meta}): _items = items;
  factory _OwnerReservationPaginatedResponse.fromJson(Map<String, dynamic> json) => _$OwnerReservationPaginatedResponseFromJson(json);

 final  List<OwnerReservation> _items;
@override List<OwnerReservation> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OwnerReservationPaginationMeta meta;

/// Create a copy of OwnerReservationPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerReservationPaginatedResponseCopyWith<_OwnerReservationPaginatedResponse> get copyWith => __$OwnerReservationPaginatedResponseCopyWithImpl<_OwnerReservationPaginatedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerReservationPaginatedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerReservationPaginatedResponse&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),meta);

@override
String toString() {
  return 'OwnerReservationPaginatedResponse(items: $items, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$OwnerReservationPaginatedResponseCopyWith<$Res> implements $OwnerReservationPaginatedResponseCopyWith<$Res> {
  factory _$OwnerReservationPaginatedResponseCopyWith(_OwnerReservationPaginatedResponse value, $Res Function(_OwnerReservationPaginatedResponse) _then) = __$OwnerReservationPaginatedResponseCopyWithImpl;
@override @useResult
$Res call({
 List<OwnerReservation> items, OwnerReservationPaginationMeta meta
});


@override $OwnerReservationPaginationMetaCopyWith<$Res> get meta;

}
/// @nodoc
class __$OwnerReservationPaginatedResponseCopyWithImpl<$Res>
    implements _$OwnerReservationPaginatedResponseCopyWith<$Res> {
  __$OwnerReservationPaginatedResponseCopyWithImpl(this._self, this._then);

  final _OwnerReservationPaginatedResponse _self;
  final $Res Function(_OwnerReservationPaginatedResponse) _then;

/// Create a copy of OwnerReservationPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? meta = null,}) {
  return _then(_OwnerReservationPaginatedResponse(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerReservation>,meta: null == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as OwnerReservationPaginationMeta,
  ));
}

/// Create a copy of OwnerReservationPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerReservationPaginationMetaCopyWith<$Res> get meta {
  
  return $OwnerReservationPaginationMetaCopyWith<$Res>(_self.meta, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// @nodoc
mixin _$OwnerReservationPaginationMeta {

 int get total; int get page; int get limit; int get totalPages;
/// Create a copy of OwnerReservationPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerReservationPaginationMetaCopyWith<OwnerReservationPaginationMeta> get copyWith => _$OwnerReservationPaginationMetaCopyWithImpl<OwnerReservationPaginationMeta>(this as OwnerReservationPaginationMeta, _$identity);

  /// Serializes this OwnerReservationPaginationMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerReservationPaginationMeta&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,page,limit,totalPages);

@override
String toString() {
  return 'OwnerReservationPaginationMeta(total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $OwnerReservationPaginationMetaCopyWith<$Res>  {
  factory $OwnerReservationPaginationMetaCopyWith(OwnerReservationPaginationMeta value, $Res Function(OwnerReservationPaginationMeta) _then) = _$OwnerReservationPaginationMetaCopyWithImpl;
@useResult
$Res call({
 int total, int page, int limit, int totalPages
});




}
/// @nodoc
class _$OwnerReservationPaginationMetaCopyWithImpl<$Res>
    implements $OwnerReservationPaginationMetaCopyWith<$Res> {
  _$OwnerReservationPaginationMetaCopyWithImpl(this._self, this._then);

  final OwnerReservationPaginationMeta _self;
  final $Res Function(OwnerReservationPaginationMeta) _then;

/// Create a copy of OwnerReservationPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? page = null,Object? limit = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerReservationPaginationMeta].
extension OwnerReservationPaginationMetaPatterns on OwnerReservationPaginationMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerReservationPaginationMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerReservationPaginationMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerReservationPaginationMeta value)  $default,){
final _that = this;
switch (_that) {
case _OwnerReservationPaginationMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerReservationPaginationMeta value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerReservationPaginationMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int page,  int limit,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerReservationPaginationMeta() when $default != null:
return $default(_that.total,_that.page,_that.limit,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int page,  int limit,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _OwnerReservationPaginationMeta():
return $default(_that.total,_that.page,_that.limit,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int page,  int limit,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _OwnerReservationPaginationMeta() when $default != null:
return $default(_that.total,_that.page,_that.limit,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerReservationPaginationMeta extends OwnerReservationPaginationMeta {
  const _OwnerReservationPaginationMeta({required this.total, required this.page, required this.limit, required this.totalPages}): super._();
  factory _OwnerReservationPaginationMeta.fromJson(Map<String, dynamic> json) => _$OwnerReservationPaginationMetaFromJson(json);

@override final  int total;
@override final  int page;
@override final  int limit;
@override final  int totalPages;

/// Create a copy of OwnerReservationPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerReservationPaginationMetaCopyWith<_OwnerReservationPaginationMeta> get copyWith => __$OwnerReservationPaginationMetaCopyWithImpl<_OwnerReservationPaginationMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerReservationPaginationMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerReservationPaginationMeta&&(identical(other.total, total) || other.total == total)&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,page,limit,totalPages);

@override
String toString() {
  return 'OwnerReservationPaginationMeta(total: $total, page: $page, limit: $limit, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$OwnerReservationPaginationMetaCopyWith<$Res> implements $OwnerReservationPaginationMetaCopyWith<$Res> {
  factory _$OwnerReservationPaginationMetaCopyWith(_OwnerReservationPaginationMeta value, $Res Function(_OwnerReservationPaginationMeta) _then) = __$OwnerReservationPaginationMetaCopyWithImpl;
@override @useResult
$Res call({
 int total, int page, int limit, int totalPages
});




}
/// @nodoc
class __$OwnerReservationPaginationMetaCopyWithImpl<$Res>
    implements _$OwnerReservationPaginationMetaCopyWith<$Res> {
  __$OwnerReservationPaginationMetaCopyWithImpl(this._self, this._then);

  final _OwnerReservationPaginationMeta _self;
  final $Res Function(_OwnerReservationPaginationMeta) _then;

/// Create a copy of OwnerReservationPaginationMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? page = null,Object? limit = null,Object? totalPages = null,}) {
  return _then(_OwnerReservationPaginationMeta(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
