// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reservation_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReservationItemRequest {

 String get inventoryId; int get quantity;
/// Create a copy of ReservationItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationItemRequestCopyWith<ReservationItemRequest> get copyWith => _$ReservationItemRequestCopyWithImpl<ReservationItemRequest>(this as ReservationItemRequest, _$identity);

  /// Serializes this ReservationItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationItemRequest&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryId,quantity);

@override
String toString() {
  return 'ReservationItemRequest(inventoryId: $inventoryId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $ReservationItemRequestCopyWith<$Res>  {
  factory $ReservationItemRequestCopyWith(ReservationItemRequest value, $Res Function(ReservationItemRequest) _then) = _$ReservationItemRequestCopyWithImpl;
@useResult
$Res call({
 String inventoryId, int quantity
});




}
/// @nodoc
class _$ReservationItemRequestCopyWithImpl<$Res>
    implements $ReservationItemRequestCopyWith<$Res> {
  _$ReservationItemRequestCopyWithImpl(this._self, this._then);

  final ReservationItemRequest _self;
  final $Res Function(ReservationItemRequest) _then;

/// Create a copy of ReservationItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inventoryId = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationItemRequest].
extension ReservationItemRequestPatterns on ReservationItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReservationItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inventoryId,  int quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationItemRequest() when $default != null:
return $default(_that.inventoryId,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inventoryId,  int quantity)  $default,) {final _that = this;
switch (_that) {
case _ReservationItemRequest():
return $default(_that.inventoryId,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inventoryId,  int quantity)?  $default,) {final _that = this;
switch (_that) {
case _ReservationItemRequest() when $default != null:
return $default(_that.inventoryId,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationItemRequest implements ReservationItemRequest {
  const _ReservationItemRequest({required this.inventoryId, required this.quantity});
  factory _ReservationItemRequest.fromJson(Map<String, dynamic> json) => _$ReservationItemRequestFromJson(json);

@override final  String inventoryId;
@override final  int quantity;

/// Create a copy of ReservationItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationItemRequestCopyWith<_ReservationItemRequest> get copyWith => __$ReservationItemRequestCopyWithImpl<_ReservationItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationItemRequest&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inventoryId,quantity);

@override
String toString() {
  return 'ReservationItemRequest(inventoryId: $inventoryId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$ReservationItemRequestCopyWith<$Res> implements $ReservationItemRequestCopyWith<$Res> {
  factory _$ReservationItemRequestCopyWith(_ReservationItemRequest value, $Res Function(_ReservationItemRequest) _then) = __$ReservationItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String inventoryId, int quantity
});




}
/// @nodoc
class __$ReservationItemRequestCopyWithImpl<$Res>
    implements _$ReservationItemRequestCopyWith<$Res> {
  __$ReservationItemRequestCopyWithImpl(this._self, this._then);

  final _ReservationItemRequest _self;
  final $Res Function(_ReservationItemRequest) _then;

/// Create a copy of ReservationItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inventoryId = null,Object? quantity = null,}) {
  return _then(_ReservationItemRequest(
inventoryId: null == inventoryId ? _self.inventoryId : inventoryId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$CreateReservationRequest {

 String get storeId; List<ReservationItemRequest> get items; String? get notes;
/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateReservationRequestCopyWith<CreateReservationRequest> get copyWith => _$CreateReservationRequestCopyWithImpl<CreateReservationRequest>(this as CreateReservationRequest, _$identity);

  /// Serializes this CreateReservationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateReservationRequest&&(identical(other.storeId, storeId) || other.storeId == storeId)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,const DeepCollectionEquality().hash(items),notes);

@override
String toString() {
  return 'CreateReservationRequest(storeId: $storeId, items: $items, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $CreateReservationRequestCopyWith<$Res>  {
  factory $CreateReservationRequestCopyWith(CreateReservationRequest value, $Res Function(CreateReservationRequest) _then) = _$CreateReservationRequestCopyWithImpl;
@useResult
$Res call({
 String storeId, List<ReservationItemRequest> items, String? notes
});




}
/// @nodoc
class _$CreateReservationRequestCopyWithImpl<$Res>
    implements $CreateReservationRequestCopyWith<$Res> {
  _$CreateReservationRequestCopyWithImpl(this._self, this._then);

  final CreateReservationRequest _self;
  final $Res Function(CreateReservationRequest) _then;

/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = null,Object? items = null,Object? notes = freezed,}) {
  return _then(_self.copyWith(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReservationItemRequest>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateReservationRequest].
extension CreateReservationRequestPatterns on CreateReservationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateReservationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateReservationRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateReservationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateReservationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeId,  List<ReservationItemRequest> items,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
return $default(_that.storeId,_that.items,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeId,  List<ReservationItemRequest> items,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _CreateReservationRequest():
return $default(_that.storeId,_that.items,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeId,  List<ReservationItemRequest> items,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _CreateReservationRequest() when $default != null:
return $default(_that.storeId,_that.items,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateReservationRequest implements CreateReservationRequest {
  const _CreateReservationRequest({required this.storeId, required final  List<ReservationItemRequest> items, this.notes}): _items = items;
  factory _CreateReservationRequest.fromJson(Map<String, dynamic> json) => _$CreateReservationRequestFromJson(json);

@override final  String storeId;
 final  List<ReservationItemRequest> _items;
@override List<ReservationItemRequest> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? notes;

/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateReservationRequestCopyWith<_CreateReservationRequest> get copyWith => __$CreateReservationRequestCopyWithImpl<_CreateReservationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateReservationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateReservationRequest&&(identical(other.storeId, storeId) || other.storeId == storeId)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,const DeepCollectionEquality().hash(_items),notes);

@override
String toString() {
  return 'CreateReservationRequest(storeId: $storeId, items: $items, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$CreateReservationRequestCopyWith<$Res> implements $CreateReservationRequestCopyWith<$Res> {
  factory _$CreateReservationRequestCopyWith(_CreateReservationRequest value, $Res Function(_CreateReservationRequest) _then) = __$CreateReservationRequestCopyWithImpl;
@override @useResult
$Res call({
 String storeId, List<ReservationItemRequest> items, String? notes
});




}
/// @nodoc
class __$CreateReservationRequestCopyWithImpl<$Res>
    implements _$CreateReservationRequestCopyWith<$Res> {
  __$CreateReservationRequestCopyWithImpl(this._self, this._then);

  final _CreateReservationRequest _self;
  final $Res Function(_CreateReservationRequest) _then;

/// Create a copy of CreateReservationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = null,Object? items = null,Object? notes = freezed,}) {
  return _then(_CreateReservationRequest(
storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReservationItemRequest>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Reservation {

 String get id; String get customerId; String get storeId; String get reservationCode; String? get idempotencyKey; ReservationStatus get status; double get subtotal; double get totalDiscount; double get totalAmount; DateTime? get expiresAt; String? get notes; DateTime? get createdAt; DateTime? get updatedAt; List<ReservationItem> get items;
/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationCopyWith<Reservation> get copyWith => _$ReservationCopyWithImpl<Reservation>(this as Reservation, _$identity);

  /// Serializes this Reservation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.reservationCode, reservationCode) || other.reservationCode == reservationCode)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,storeId,reservationCode,idempotencyKey,status,subtotal,totalDiscount,totalAmount,expiresAt,notes,createdAt,updatedAt,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'Reservation(id: $id, customerId: $customerId, storeId: $storeId, reservationCode: $reservationCode, idempotencyKey: $idempotencyKey, status: $status, subtotal: $subtotal, totalDiscount: $totalDiscount, totalAmount: $totalAmount, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class $ReservationCopyWith<$Res>  {
  factory $ReservationCopyWith(Reservation value, $Res Function(Reservation) _then) = _$ReservationCopyWithImpl;
@useResult
$Res call({
 String id, String customerId, String storeId, String reservationCode, String? idempotencyKey, ReservationStatus status, double subtotal, double totalDiscount, double totalAmount, DateTime? expiresAt, String? notes, DateTime? createdAt, DateTime? updatedAt, List<ReservationItem> items
});




}
/// @nodoc
class _$ReservationCopyWithImpl<$Res>
    implements $ReservationCopyWith<$Res> {
  _$ReservationCopyWithImpl(this._self, this._then);

  final Reservation _self;
  final $Res Function(Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customerId = null,Object? storeId = null,Object? reservationCode = null,Object? idempotencyKey = freezed,Object? status = null,Object? subtotal = null,Object? totalDiscount = null,Object? totalAmount = null,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
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
as double,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReservationItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [Reservation].
extension ReservationPatterns on Reservation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Reservation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Reservation value)  $default,){
final _that = this;
switch (_that) {
case _Reservation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Reservation value)?  $default,){
final _that = this;
switch (_that) {
case _Reservation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customerId,  String storeId,  String reservationCode,  String? idempotencyKey,  ReservationStatus status,  double subtotal,  double totalDiscount,  double totalAmount,  DateTime? expiresAt,  String? notes,  DateTime? createdAt,  DateTime? updatedAt,  List<ReservationItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.customerId,_that.storeId,_that.reservationCode,_that.idempotencyKey,_that.status,_that.subtotal,_that.totalDiscount,_that.totalAmount,_that.expiresAt,_that.notes,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customerId,  String storeId,  String reservationCode,  String? idempotencyKey,  ReservationStatus status,  double subtotal,  double totalDiscount,  double totalAmount,  DateTime? expiresAt,  String? notes,  DateTime? createdAt,  DateTime? updatedAt,  List<ReservationItem> items)  $default,) {final _that = this;
switch (_that) {
case _Reservation():
return $default(_that.id,_that.customerId,_that.storeId,_that.reservationCode,_that.idempotencyKey,_that.status,_that.subtotal,_that.totalDiscount,_that.totalAmount,_that.expiresAt,_that.notes,_that.createdAt,_that.updatedAt,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customerId,  String storeId,  String reservationCode,  String? idempotencyKey,  ReservationStatus status,  double subtotal,  double totalDiscount,  double totalAmount,  DateTime? expiresAt,  String? notes,  DateTime? createdAt,  DateTime? updatedAt,  List<ReservationItem> items)?  $default,) {final _that = this;
switch (_that) {
case _Reservation() when $default != null:
return $default(_that.id,_that.customerId,_that.storeId,_that.reservationCode,_that.idempotencyKey,_that.status,_that.subtotal,_that.totalDiscount,_that.totalAmount,_that.expiresAt,_that.notes,_that.createdAt,_that.updatedAt,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Reservation implements Reservation {
  const _Reservation({required this.id, required this.customerId, required this.storeId, required this.reservationCode, this.idempotencyKey, required this.status, this.subtotal = 0, this.totalDiscount = 0, this.totalAmount = 0, this.expiresAt, this.notes, this.createdAt, this.updatedAt, final  List<ReservationItem> items = const []}): _items = items;
  factory _Reservation.fromJson(Map<String, dynamic> json) => _$ReservationFromJson(json);

@override final  String id;
@override final  String customerId;
@override final  String storeId;
@override final  String reservationCode;
@override final  String? idempotencyKey;
@override final  ReservationStatus status;
@override@JsonKey() final  double subtotal;
@override@JsonKey() final  double totalDiscount;
@override@JsonKey() final  double totalAmount;
@override final  DateTime? expiresAt;
@override final  String? notes;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
 final  List<ReservationItem> _items;
@override@JsonKey() List<ReservationItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationCopyWith<_Reservation> get copyWith => __$ReservationCopyWithImpl<_Reservation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reservation&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.reservationCode, reservationCode) || other.reservationCode == reservationCode)&&(identical(other.idempotencyKey, idempotencyKey) || other.idempotencyKey == idempotencyKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal)&&(identical(other.totalDiscount, totalDiscount) || other.totalDiscount == totalDiscount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,storeId,reservationCode,idempotencyKey,status,subtotal,totalDiscount,totalAmount,expiresAt,notes,createdAt,updatedAt,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'Reservation(id: $id, customerId: $customerId, storeId: $storeId, reservationCode: $reservationCode, idempotencyKey: $idempotencyKey, status: $status, subtotal: $subtotal, totalDiscount: $totalDiscount, totalAmount: $totalAmount, expiresAt: $expiresAt, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReservationCopyWith<$Res> implements $ReservationCopyWith<$Res> {
  factory _$ReservationCopyWith(_Reservation value, $Res Function(_Reservation) _then) = __$ReservationCopyWithImpl;
@override @useResult
$Res call({
 String id, String customerId, String storeId, String reservationCode, String? idempotencyKey, ReservationStatus status, double subtotal, double totalDiscount, double totalAmount, DateTime? expiresAt, String? notes, DateTime? createdAt, DateTime? updatedAt, List<ReservationItem> items
});




}
/// @nodoc
class __$ReservationCopyWithImpl<$Res>
    implements _$ReservationCopyWith<$Res> {
  __$ReservationCopyWithImpl(this._self, this._then);

  final _Reservation _self;
  final $Res Function(_Reservation) _then;

/// Create a copy of Reservation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customerId = null,Object? storeId = null,Object? reservationCode = null,Object? idempotencyKey = freezed,Object? status = null,Object? subtotal = null,Object? totalDiscount = null,Object? totalAmount = null,Object? expiresAt = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? items = null,}) {
  return _then(_Reservation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,reservationCode: null == reservationCode ? _self.reservationCode : reservationCode // ignore: cast_nullable_to_non_nullable
as String,idempotencyKey: freezed == idempotencyKey ? _self.idempotencyKey : idempotencyKey // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReservationStatus,subtotal: null == subtotal ? _self.subtotal : subtotal // ignore: cast_nullable_to_non_nullable
as double,totalDiscount: null == totalDiscount ? _self.totalDiscount : totalDiscount // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReservationItem>,
  ));
}


}


/// @nodoc
mixin _$ReservationItem {

 String get id; String get reservationId; String get inventoryId; String get productId; String? get offerId; int get quantity; double get originalUnitPrice; double get discountedUnitPrice; double get discountAmount; double get subtotal;
/// Create a copy of ReservationItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReservationItemCopyWith<ReservationItem> get copyWith => _$ReservationItemCopyWithImpl<ReservationItem>(this as ReservationItem, _$identity);

  /// Serializes this ReservationItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReservationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.originalUnitPrice, originalUnitPrice) || other.originalUnitPrice == originalUnitPrice)&&(identical(other.discountedUnitPrice, discountedUnitPrice) || other.discountedUnitPrice == discountedUnitPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reservationId,inventoryId,productId,offerId,quantity,originalUnitPrice,discountedUnitPrice,discountAmount,subtotal);

@override
String toString() {
  return 'ReservationItem(id: $id, reservationId: $reservationId, inventoryId: $inventoryId, productId: $productId, offerId: $offerId, quantity: $quantity, originalUnitPrice: $originalUnitPrice, discountedUnitPrice: $discountedUnitPrice, discountAmount: $discountAmount, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class $ReservationItemCopyWith<$Res>  {
  factory $ReservationItemCopyWith(ReservationItem value, $Res Function(ReservationItem) _then) = _$ReservationItemCopyWithImpl;
@useResult
$Res call({
 String id, String reservationId, String inventoryId, String productId, String? offerId, int quantity, double originalUnitPrice, double discountedUnitPrice, double discountAmount, double subtotal
});




}
/// @nodoc
class _$ReservationItemCopyWithImpl<$Res>
    implements $ReservationItemCopyWith<$Res> {
  _$ReservationItemCopyWithImpl(this._self, this._then);

  final ReservationItem _self;
  final $Res Function(ReservationItem) _then;

/// Create a copy of ReservationItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? reservationId = null,Object? inventoryId = null,Object? productId = null,Object? offerId = freezed,Object? quantity = null,Object? originalUnitPrice = null,Object? discountedUnitPrice = null,Object? discountAmount = null,Object? subtotal = null,}) {
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
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ReservationItem].
extension ReservationItemPatterns on ReservationItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReservationItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReservationItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReservationItem value)  $default,){
final _that = this;
switch (_that) {
case _ReservationItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReservationItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReservationItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String reservationId,  String inventoryId,  String productId,  String? offerId,  int quantity,  double originalUnitPrice,  double discountedUnitPrice,  double discountAmount,  double subtotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReservationItem() when $default != null:
return $default(_that.id,_that.reservationId,_that.inventoryId,_that.productId,_that.offerId,_that.quantity,_that.originalUnitPrice,_that.discountedUnitPrice,_that.discountAmount,_that.subtotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String reservationId,  String inventoryId,  String productId,  String? offerId,  int quantity,  double originalUnitPrice,  double discountedUnitPrice,  double discountAmount,  double subtotal)  $default,) {final _that = this;
switch (_that) {
case _ReservationItem():
return $default(_that.id,_that.reservationId,_that.inventoryId,_that.productId,_that.offerId,_that.quantity,_that.originalUnitPrice,_that.discountedUnitPrice,_that.discountAmount,_that.subtotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String reservationId,  String inventoryId,  String productId,  String? offerId,  int quantity,  double originalUnitPrice,  double discountedUnitPrice,  double discountAmount,  double subtotal)?  $default,) {final _that = this;
switch (_that) {
case _ReservationItem() when $default != null:
return $default(_that.id,_that.reservationId,_that.inventoryId,_that.productId,_that.offerId,_that.quantity,_that.originalUnitPrice,_that.discountedUnitPrice,_that.discountAmount,_that.subtotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReservationItem implements ReservationItem {
  const _ReservationItem({required this.id, required this.reservationId, required this.inventoryId, required this.productId, this.offerId, required this.quantity, this.originalUnitPrice = 0, this.discountedUnitPrice = 0, this.discountAmount = 0, this.subtotal = 0});
  factory _ReservationItem.fromJson(Map<String, dynamic> json) => _$ReservationItemFromJson(json);

@override final  String id;
@override final  String reservationId;
@override final  String inventoryId;
@override final  String productId;
@override final  String? offerId;
@override final  int quantity;
@override@JsonKey() final  double originalUnitPrice;
@override@JsonKey() final  double discountedUnitPrice;
@override@JsonKey() final  double discountAmount;
@override@JsonKey() final  double subtotal;

/// Create a copy of ReservationItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReservationItemCopyWith<_ReservationItem> get copyWith => __$ReservationItemCopyWithImpl<_ReservationItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReservationItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReservationItem&&(identical(other.id, id) || other.id == id)&&(identical(other.reservationId, reservationId) || other.reservationId == reservationId)&&(identical(other.inventoryId, inventoryId) || other.inventoryId == inventoryId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.originalUnitPrice, originalUnitPrice) || other.originalUnitPrice == originalUnitPrice)&&(identical(other.discountedUnitPrice, discountedUnitPrice) || other.discountedUnitPrice == discountedUnitPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.subtotal, subtotal) || other.subtotal == subtotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,reservationId,inventoryId,productId,offerId,quantity,originalUnitPrice,discountedUnitPrice,discountAmount,subtotal);

@override
String toString() {
  return 'ReservationItem(id: $id, reservationId: $reservationId, inventoryId: $inventoryId, productId: $productId, offerId: $offerId, quantity: $quantity, originalUnitPrice: $originalUnitPrice, discountedUnitPrice: $discountedUnitPrice, discountAmount: $discountAmount, subtotal: $subtotal)';
}


}

/// @nodoc
abstract mixin class _$ReservationItemCopyWith<$Res> implements $ReservationItemCopyWith<$Res> {
  factory _$ReservationItemCopyWith(_ReservationItem value, $Res Function(_ReservationItem) _then) = __$ReservationItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String reservationId, String inventoryId, String productId, String? offerId, int quantity, double originalUnitPrice, double discountedUnitPrice, double discountAmount, double subtotal
});




}
/// @nodoc
class __$ReservationItemCopyWithImpl<$Res>
    implements _$ReservationItemCopyWith<$Res> {
  __$ReservationItemCopyWithImpl(this._self, this._then);

  final _ReservationItem _self;
  final $Res Function(_ReservationItem) _then;

/// Create a copy of ReservationItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? reservationId = null,Object? inventoryId = null,Object? productId = null,Object? offerId = freezed,Object? quantity = null,Object? originalUnitPrice = null,Object? discountedUnitPrice = null,Object? discountAmount = null,Object? subtotal = null,}) {
  return _then(_ReservationItem(
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
as double,
  ));
}


}

// dart format on
