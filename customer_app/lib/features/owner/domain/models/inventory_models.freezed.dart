// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'inventory_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InventoryProduct {

 String get name; String get brand; String get unit; String? get sku; String? get barcode;
/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryProductCopyWith<InventoryProduct> get copyWith => _$InventoryProductCopyWithImpl<InventoryProduct>(this as InventoryProduct, _$identity);

  /// Serializes this InventoryProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryProduct&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,brand,unit,sku,barcode);

@override
String toString() {
  return 'InventoryProduct(name: $name, brand: $brand, unit: $unit, sku: $sku, barcode: $barcode)';
}


}

/// @nodoc
abstract mixin class $InventoryProductCopyWith<$Res>  {
  factory $InventoryProductCopyWith(InventoryProduct value, $Res Function(InventoryProduct) _then) = _$InventoryProductCopyWithImpl;
@useResult
$Res call({
 String name, String brand, String unit, String? sku, String? barcode
});




}
/// @nodoc
class _$InventoryProductCopyWithImpl<$Res>
    implements $InventoryProductCopyWith<$Res> {
  _$InventoryProductCopyWithImpl(this._self, this._then);

  final InventoryProduct _self;
  final $Res Function(InventoryProduct) _then;

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? brand = null,Object? unit = null,Object? sku = freezed,Object? barcode = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryProduct].
extension InventoryProductPatterns on InventoryProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryProduct value)  $default,){
final _that = this;
switch (_that) {
case _InventoryProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryProduct value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String brand,  String unit,  String? sku,  String? barcode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
return $default(_that.name,_that.brand,_that.unit,_that.sku,_that.barcode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String brand,  String unit,  String? sku,  String? barcode)  $default,) {final _that = this;
switch (_that) {
case _InventoryProduct():
return $default(_that.name,_that.brand,_that.unit,_that.sku,_that.barcode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String brand,  String unit,  String? sku,  String? barcode)?  $default,) {final _that = this;
switch (_that) {
case _InventoryProduct() when $default != null:
return $default(_that.name,_that.brand,_that.unit,_that.sku,_that.barcode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryProduct implements InventoryProduct {
  const _InventoryProduct({required this.name, required this.brand, required this.unit, this.sku, this.barcode});
  factory _InventoryProduct.fromJson(Map<String, dynamic> json) => _$InventoryProductFromJson(json);

@override final  String name;
@override final  String brand;
@override final  String unit;
@override final  String? sku;
@override final  String? barcode;

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryProductCopyWith<_InventoryProduct> get copyWith => __$InventoryProductCopyWithImpl<_InventoryProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryProduct&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,brand,unit,sku,barcode);

@override
String toString() {
  return 'InventoryProduct(name: $name, brand: $brand, unit: $unit, sku: $sku, barcode: $barcode)';
}


}

/// @nodoc
abstract mixin class _$InventoryProductCopyWith<$Res> implements $InventoryProductCopyWith<$Res> {
  factory _$InventoryProductCopyWith(_InventoryProduct value, $Res Function(_InventoryProduct) _then) = __$InventoryProductCopyWithImpl;
@override @useResult
$Res call({
 String name, String brand, String unit, String? sku, String? barcode
});




}
/// @nodoc
class __$InventoryProductCopyWithImpl<$Res>
    implements _$InventoryProductCopyWith<$Res> {
  __$InventoryProductCopyWithImpl(this._self, this._then);

  final _InventoryProduct _self;
  final $Res Function(_InventoryProduct) _then;

/// Create a copy of InventoryProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? brand = null,Object? unit = null,Object? sku = freezed,Object? barcode = freezed,}) {
  return _then(_InventoryProduct(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: null == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OwnerInventoryItem {

 String get id; String get storeId; String get productId; String? get batchNumber; int get stockQuantity; double get originalPrice; double get sellingPrice; DateTime? get manufacturingDate; DateTime get expiryDate; String get status; String get expiryStatus; String get timeRemaining; InventoryProduct get product;
/// Create a copy of OwnerInventoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerInventoryItemCopyWith<OwnerInventoryItem> get copyWith => _$OwnerInventoryItemCopyWithImpl<OwnerInventoryItem>(this as OwnerInventoryItem, _$identity);

  /// Serializes this OwnerInventoryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerInventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.manufacturingDate, manufacturingDate) || other.manufacturingDate == manufacturingDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiryStatus, expiryStatus) || other.expiryStatus == expiryStatus)&&(identical(other.timeRemaining, timeRemaining) || other.timeRemaining == timeRemaining)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,productId,batchNumber,stockQuantity,originalPrice,sellingPrice,manufacturingDate,expiryDate,status,expiryStatus,timeRemaining,product);

@override
String toString() {
  return 'OwnerInventoryItem(id: $id, storeId: $storeId, productId: $productId, batchNumber: $batchNumber, stockQuantity: $stockQuantity, originalPrice: $originalPrice, sellingPrice: $sellingPrice, manufacturingDate: $manufacturingDate, expiryDate: $expiryDate, status: $status, expiryStatus: $expiryStatus, timeRemaining: $timeRemaining, product: $product)';
}


}

/// @nodoc
abstract mixin class $OwnerInventoryItemCopyWith<$Res>  {
  factory $OwnerInventoryItemCopyWith(OwnerInventoryItem value, $Res Function(OwnerInventoryItem) _then) = _$OwnerInventoryItemCopyWithImpl;
@useResult
$Res call({
 String id, String storeId, String productId, String? batchNumber, int stockQuantity, double originalPrice, double sellingPrice, DateTime? manufacturingDate, DateTime expiryDate, String status, String expiryStatus, String timeRemaining, InventoryProduct product
});


$InventoryProductCopyWith<$Res> get product;

}
/// @nodoc
class _$OwnerInventoryItemCopyWithImpl<$Res>
    implements $OwnerInventoryItemCopyWith<$Res> {
  _$OwnerInventoryItemCopyWithImpl(this._self, this._then);

  final OwnerInventoryItem _self;
  final $Res Function(OwnerInventoryItem) _then;

/// Create a copy of OwnerInventoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? storeId = null,Object? productId = null,Object? batchNumber = freezed,Object? stockQuantity = null,Object? originalPrice = null,Object? sellingPrice = null,Object? manufacturingDate = freezed,Object? expiryDate = null,Object? status = null,Object? expiryStatus = null,Object? timeRemaining = null,Object? product = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,manufacturingDate: freezed == manufacturingDate ? _self.manufacturingDate : manufacturingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiryStatus: null == expiryStatus ? _self.expiryStatus : expiryStatus // ignore: cast_nullable_to_non_nullable
as String,timeRemaining: null == timeRemaining ? _self.timeRemaining : timeRemaining // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InventoryProduct,
  ));
}
/// Create a copy of OwnerInventoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryProductCopyWith<$Res> get product {
  
  return $InventoryProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerInventoryItem].
extension OwnerInventoryItemPatterns on OwnerInventoryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerInventoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerInventoryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerInventoryItem value)  $default,){
final _that = this;
switch (_that) {
case _OwnerInventoryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerInventoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerInventoryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String storeId,  String productId,  String? batchNumber,  int stockQuantity,  double originalPrice,  double sellingPrice,  DateTime? manufacturingDate,  DateTime expiryDate,  String status,  String expiryStatus,  String timeRemaining,  InventoryProduct product)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerInventoryItem() when $default != null:
return $default(_that.id,_that.storeId,_that.productId,_that.batchNumber,_that.stockQuantity,_that.originalPrice,_that.sellingPrice,_that.manufacturingDate,_that.expiryDate,_that.status,_that.expiryStatus,_that.timeRemaining,_that.product);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String storeId,  String productId,  String? batchNumber,  int stockQuantity,  double originalPrice,  double sellingPrice,  DateTime? manufacturingDate,  DateTime expiryDate,  String status,  String expiryStatus,  String timeRemaining,  InventoryProduct product)  $default,) {final _that = this;
switch (_that) {
case _OwnerInventoryItem():
return $default(_that.id,_that.storeId,_that.productId,_that.batchNumber,_that.stockQuantity,_that.originalPrice,_that.sellingPrice,_that.manufacturingDate,_that.expiryDate,_that.status,_that.expiryStatus,_that.timeRemaining,_that.product);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String storeId,  String productId,  String? batchNumber,  int stockQuantity,  double originalPrice,  double sellingPrice,  DateTime? manufacturingDate,  DateTime expiryDate,  String status,  String expiryStatus,  String timeRemaining,  InventoryProduct product)?  $default,) {final _that = this;
switch (_that) {
case _OwnerInventoryItem() when $default != null:
return $default(_that.id,_that.storeId,_that.productId,_that.batchNumber,_that.stockQuantity,_that.originalPrice,_that.sellingPrice,_that.manufacturingDate,_that.expiryDate,_that.status,_that.expiryStatus,_that.timeRemaining,_that.product);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerInventoryItem implements OwnerInventoryItem {
  const _OwnerInventoryItem({required this.id, required this.storeId, required this.productId, this.batchNumber, required this.stockQuantity, required this.originalPrice, required this.sellingPrice, this.manufacturingDate, required this.expiryDate, required this.status, required this.expiryStatus, required this.timeRemaining, required this.product});
  factory _OwnerInventoryItem.fromJson(Map<String, dynamic> json) => _$OwnerInventoryItemFromJson(json);

@override final  String id;
@override final  String storeId;
@override final  String productId;
@override final  String? batchNumber;
@override final  int stockQuantity;
@override final  double originalPrice;
@override final  double sellingPrice;
@override final  DateTime? manufacturingDate;
@override final  DateTime expiryDate;
@override final  String status;
@override final  String expiryStatus;
@override final  String timeRemaining;
@override final  InventoryProduct product;

/// Create a copy of OwnerInventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerInventoryItemCopyWith<_OwnerInventoryItem> get copyWith => __$OwnerInventoryItemCopyWithImpl<_OwnerInventoryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerInventoryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerInventoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.batchNumber, batchNumber) || other.batchNumber == batchNumber)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.sellingPrice, sellingPrice) || other.sellingPrice == sellingPrice)&&(identical(other.manufacturingDate, manufacturingDate) || other.manufacturingDate == manufacturingDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.expiryStatus, expiryStatus) || other.expiryStatus == expiryStatus)&&(identical(other.timeRemaining, timeRemaining) || other.timeRemaining == timeRemaining)&&(identical(other.product, product) || other.product == product));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,storeId,productId,batchNumber,stockQuantity,originalPrice,sellingPrice,manufacturingDate,expiryDate,status,expiryStatus,timeRemaining,product);

@override
String toString() {
  return 'OwnerInventoryItem(id: $id, storeId: $storeId, productId: $productId, batchNumber: $batchNumber, stockQuantity: $stockQuantity, originalPrice: $originalPrice, sellingPrice: $sellingPrice, manufacturingDate: $manufacturingDate, expiryDate: $expiryDate, status: $status, expiryStatus: $expiryStatus, timeRemaining: $timeRemaining, product: $product)';
}


}

/// @nodoc
abstract mixin class _$OwnerInventoryItemCopyWith<$Res> implements $OwnerInventoryItemCopyWith<$Res> {
  factory _$OwnerInventoryItemCopyWith(_OwnerInventoryItem value, $Res Function(_OwnerInventoryItem) _then) = __$OwnerInventoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String storeId, String productId, String? batchNumber, int stockQuantity, double originalPrice, double sellingPrice, DateTime? manufacturingDate, DateTime expiryDate, String status, String expiryStatus, String timeRemaining, InventoryProduct product
});


@override $InventoryProductCopyWith<$Res> get product;

}
/// @nodoc
class __$OwnerInventoryItemCopyWithImpl<$Res>
    implements _$OwnerInventoryItemCopyWith<$Res> {
  __$OwnerInventoryItemCopyWithImpl(this._self, this._then);

  final _OwnerInventoryItem _self;
  final $Res Function(_OwnerInventoryItem) _then;

/// Create a copy of OwnerInventoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? storeId = null,Object? productId = null,Object? batchNumber = freezed,Object? stockQuantity = null,Object? originalPrice = null,Object? sellingPrice = null,Object? manufacturingDate = freezed,Object? expiryDate = null,Object? status = null,Object? expiryStatus = null,Object? timeRemaining = null,Object? product = null,}) {
  return _then(_OwnerInventoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,storeId: null == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as String,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,batchNumber: freezed == batchNumber ? _self.batchNumber : batchNumber // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as int,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,sellingPrice: null == sellingPrice ? _self.sellingPrice : sellingPrice // ignore: cast_nullable_to_non_nullable
as double,manufacturingDate: freezed == manufacturingDate ? _self.manufacturingDate : manufacturingDate // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,expiryStatus: null == expiryStatus ? _self.expiryStatus : expiryStatus // ignore: cast_nullable_to_non_nullable
as String,timeRemaining: null == timeRemaining ? _self.timeRemaining : timeRemaining // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as InventoryProduct,
  ));
}

/// Create a copy of OwnerInventoryItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryProductCopyWith<$Res> get product {
  
  return $InventoryProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}
}


/// @nodoc
mixin _$AdjustStockRequest {

 String get action;// ADD, REMOVE, SET
 int get quantity; String? get reason; String? get movementType;
/// Create a copy of AdjustStockRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdjustStockRequestCopyWith<AdjustStockRequest> get copyWith => _$AdjustStockRequestCopyWithImpl<AdjustStockRequest>(this as AdjustStockRequest, _$identity);

  /// Serializes this AdjustStockRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdjustStockRequest&&(identical(other.action, action) || other.action == action)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.movementType, movementType) || other.movementType == movementType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,quantity,reason,movementType);

@override
String toString() {
  return 'AdjustStockRequest(action: $action, quantity: $quantity, reason: $reason, movementType: $movementType)';
}


}

/// @nodoc
abstract mixin class $AdjustStockRequestCopyWith<$Res>  {
  factory $AdjustStockRequestCopyWith(AdjustStockRequest value, $Res Function(AdjustStockRequest) _then) = _$AdjustStockRequestCopyWithImpl;
@useResult
$Res call({
 String action, int quantity, String? reason, String? movementType
});




}
/// @nodoc
class _$AdjustStockRequestCopyWithImpl<$Res>
    implements $AdjustStockRequestCopyWith<$Res> {
  _$AdjustStockRequestCopyWithImpl(this._self, this._then);

  final AdjustStockRequest _self;
  final $Res Function(AdjustStockRequest) _then;

/// Create a copy of AdjustStockRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? action = null,Object? quantity = null,Object? reason = freezed,Object? movementType = freezed,}) {
  return _then(_self.copyWith(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,movementType: freezed == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdjustStockRequest].
extension AdjustStockRequestPatterns on AdjustStockRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdjustStockRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdjustStockRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdjustStockRequest value)  $default,){
final _that = this;
switch (_that) {
case _AdjustStockRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdjustStockRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AdjustStockRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String action,  int quantity,  String? reason,  String? movementType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdjustStockRequest() when $default != null:
return $default(_that.action,_that.quantity,_that.reason,_that.movementType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String action,  int quantity,  String? reason,  String? movementType)  $default,) {final _that = this;
switch (_that) {
case _AdjustStockRequest():
return $default(_that.action,_that.quantity,_that.reason,_that.movementType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String action,  int quantity,  String? reason,  String? movementType)?  $default,) {final _that = this;
switch (_that) {
case _AdjustStockRequest() when $default != null:
return $default(_that.action,_that.quantity,_that.reason,_that.movementType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdjustStockRequest implements AdjustStockRequest {
  const _AdjustStockRequest({required this.action, required this.quantity, this.reason, this.movementType});
  factory _AdjustStockRequest.fromJson(Map<String, dynamic> json) => _$AdjustStockRequestFromJson(json);

@override final  String action;
// ADD, REMOVE, SET
@override final  int quantity;
@override final  String? reason;
@override final  String? movementType;

/// Create a copy of AdjustStockRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjustStockRequestCopyWith<_AdjustStockRequest> get copyWith => __$AdjustStockRequestCopyWithImpl<_AdjustStockRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdjustStockRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdjustStockRequest&&(identical(other.action, action) || other.action == action)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.movementType, movementType) || other.movementType == movementType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action,quantity,reason,movementType);

@override
String toString() {
  return 'AdjustStockRequest(action: $action, quantity: $quantity, reason: $reason, movementType: $movementType)';
}


}

/// @nodoc
abstract mixin class _$AdjustStockRequestCopyWith<$Res> implements $AdjustStockRequestCopyWith<$Res> {
  factory _$AdjustStockRequestCopyWith(_AdjustStockRequest value, $Res Function(_AdjustStockRequest) _then) = __$AdjustStockRequestCopyWithImpl;
@override @useResult
$Res call({
 String action, int quantity, String? reason, String? movementType
});




}
/// @nodoc
class __$AdjustStockRequestCopyWithImpl<$Res>
    implements _$AdjustStockRequestCopyWith<$Res> {
  __$AdjustStockRequestCopyWithImpl(this._self, this._then);

  final _AdjustStockRequest _self;
  final $Res Function(_AdjustStockRequest) _then;

/// Create a copy of AdjustStockRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? action = null,Object? quantity = null,Object? reason = freezed,Object? movementType = freezed,}) {
  return _then(_AdjustStockRequest(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,movementType: freezed == movementType ? _self.movementType : movementType // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$InventoryPaginatedResponse {

 bool get success; InventoryPaginatedData get data;
/// Create a copy of InventoryPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryPaginatedResponseCopyWith<InventoryPaginatedResponse> get copyWith => _$InventoryPaginatedResponseCopyWithImpl<InventoryPaginatedResponse>(this as InventoryPaginatedResponse, _$identity);

  /// Serializes this InventoryPaginatedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryPaginatedResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'InventoryPaginatedResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $InventoryPaginatedResponseCopyWith<$Res>  {
  factory $InventoryPaginatedResponseCopyWith(InventoryPaginatedResponse value, $Res Function(InventoryPaginatedResponse) _then) = _$InventoryPaginatedResponseCopyWithImpl;
@useResult
$Res call({
 bool success, InventoryPaginatedData data
});


$InventoryPaginatedDataCopyWith<$Res> get data;

}
/// @nodoc
class _$InventoryPaginatedResponseCopyWithImpl<$Res>
    implements $InventoryPaginatedResponseCopyWith<$Res> {
  _$InventoryPaginatedResponseCopyWithImpl(this._self, this._then);

  final InventoryPaginatedResponse _self;
  final $Res Function(InventoryPaginatedResponse) _then;

/// Create a copy of InventoryPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InventoryPaginatedData,
  ));
}
/// Create a copy of InventoryPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryPaginatedDataCopyWith<$Res> get data {
  
  return $InventoryPaginatedDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryPaginatedResponse].
extension InventoryPaginatedResponsePatterns on InventoryPaginatedResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryPaginatedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryPaginatedResponse value)  $default,){
final _that = this;
switch (_that) {
case _InventoryPaginatedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryPaginatedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  InventoryPaginatedData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryPaginatedResponse() when $default != null:
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  InventoryPaginatedData data)  $default,) {final _that = this;
switch (_that) {
case _InventoryPaginatedResponse():
return $default(_that.success,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  InventoryPaginatedData data)?  $default,) {final _that = this;
switch (_that) {
case _InventoryPaginatedResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryPaginatedResponse implements InventoryPaginatedResponse {
  const _InventoryPaginatedResponse({required this.success, required this.data});
  factory _InventoryPaginatedResponse.fromJson(Map<String, dynamic> json) => _$InventoryPaginatedResponseFromJson(json);

@override final  bool success;
@override final  InventoryPaginatedData data;

/// Create a copy of InventoryPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryPaginatedResponseCopyWith<_InventoryPaginatedResponse> get copyWith => __$InventoryPaginatedResponseCopyWithImpl<_InventoryPaginatedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryPaginatedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryPaginatedResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'InventoryPaginatedResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$InventoryPaginatedResponseCopyWith<$Res> implements $InventoryPaginatedResponseCopyWith<$Res> {
  factory _$InventoryPaginatedResponseCopyWith(_InventoryPaginatedResponse value, $Res Function(_InventoryPaginatedResponse) _then) = __$InventoryPaginatedResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, InventoryPaginatedData data
});


@override $InventoryPaginatedDataCopyWith<$Res> get data;

}
/// @nodoc
class __$InventoryPaginatedResponseCopyWithImpl<$Res>
    implements _$InventoryPaginatedResponseCopyWith<$Res> {
  __$InventoryPaginatedResponseCopyWithImpl(this._self, this._then);

  final _InventoryPaginatedResponse _self;
  final $Res Function(_InventoryPaginatedResponse) _then;

/// Create a copy of InventoryPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,}) {
  return _then(_InventoryPaginatedResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as InventoryPaginatedData,
  ));
}

/// Create a copy of InventoryPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryPaginatedDataCopyWith<$Res> get data {
  
  return $InventoryPaginatedDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$InventoryPaginatedData {

 List<OwnerInventoryItem> get items; InventoryPaginationInfo get pagination;
/// Create a copy of InventoryPaginatedData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryPaginatedDataCopyWith<InventoryPaginatedData> get copyWith => _$InventoryPaginatedDataCopyWithImpl<InventoryPaginatedData>(this as InventoryPaginatedData, _$identity);

  /// Serializes this InventoryPaginatedData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryPaginatedData&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),pagination);

@override
String toString() {
  return 'InventoryPaginatedData(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $InventoryPaginatedDataCopyWith<$Res>  {
  factory $InventoryPaginatedDataCopyWith(InventoryPaginatedData value, $Res Function(InventoryPaginatedData) _then) = _$InventoryPaginatedDataCopyWithImpl;
@useResult
$Res call({
 List<OwnerInventoryItem> items, InventoryPaginationInfo pagination
});


$InventoryPaginationInfoCopyWith<$Res> get pagination;

}
/// @nodoc
class _$InventoryPaginatedDataCopyWithImpl<$Res>
    implements $InventoryPaginatedDataCopyWith<$Res> {
  _$InventoryPaginatedDataCopyWithImpl(this._self, this._then);

  final InventoryPaginatedData _self;
  final $Res Function(InventoryPaginatedData) _then;

/// Create a copy of InventoryPaginatedData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerInventoryItem>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as InventoryPaginationInfo,
  ));
}
/// Create a copy of InventoryPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryPaginationInfoCopyWith<$Res> get pagination {
  
  return $InventoryPaginationInfoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [InventoryPaginatedData].
extension InventoryPaginatedDataPatterns on InventoryPaginatedData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryPaginatedData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryPaginatedData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryPaginatedData value)  $default,){
final _that = this;
switch (_that) {
case _InventoryPaginatedData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryPaginatedData value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryPaginatedData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OwnerInventoryItem> items,  InventoryPaginationInfo pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryPaginatedData() when $default != null:
return $default(_that.items,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OwnerInventoryItem> items,  InventoryPaginationInfo pagination)  $default,) {final _that = this;
switch (_that) {
case _InventoryPaginatedData():
return $default(_that.items,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OwnerInventoryItem> items,  InventoryPaginationInfo pagination)?  $default,) {final _that = this;
switch (_that) {
case _InventoryPaginatedData() when $default != null:
return $default(_that.items,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryPaginatedData implements InventoryPaginatedData {
  const _InventoryPaginatedData({required final  List<OwnerInventoryItem> items, required this.pagination}): _items = items;
  factory _InventoryPaginatedData.fromJson(Map<String, dynamic> json) => _$InventoryPaginatedDataFromJson(json);

 final  List<OwnerInventoryItem> _items;
@override List<OwnerInventoryItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  InventoryPaginationInfo pagination;

/// Create a copy of InventoryPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryPaginatedDataCopyWith<_InventoryPaginatedData> get copyWith => __$InventoryPaginatedDataCopyWithImpl<_InventoryPaginatedData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryPaginatedDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryPaginatedData&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pagination);

@override
String toString() {
  return 'InventoryPaginatedData(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$InventoryPaginatedDataCopyWith<$Res> implements $InventoryPaginatedDataCopyWith<$Res> {
  factory _$InventoryPaginatedDataCopyWith(_InventoryPaginatedData value, $Res Function(_InventoryPaginatedData) _then) = __$InventoryPaginatedDataCopyWithImpl;
@override @useResult
$Res call({
 List<OwnerInventoryItem> items, InventoryPaginationInfo pagination
});


@override $InventoryPaginationInfoCopyWith<$Res> get pagination;

}
/// @nodoc
class __$InventoryPaginatedDataCopyWithImpl<$Res>
    implements _$InventoryPaginatedDataCopyWith<$Res> {
  __$InventoryPaginatedDataCopyWithImpl(this._self, this._then);

  final _InventoryPaginatedData _self;
  final $Res Function(_InventoryPaginatedData) _then;

/// Create a copy of InventoryPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_InventoryPaginatedData(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerInventoryItem>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as InventoryPaginationInfo,
  ));
}

/// Create a copy of InventoryPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InventoryPaginationInfoCopyWith<$Res> get pagination {
  
  return $InventoryPaginationInfoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$InventoryPaginationInfo {

 int get page; int get limit; int get total; int get totalPages;
/// Create a copy of InventoryPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InventoryPaginationInfoCopyWith<InventoryPaginationInfo> get copyWith => _$InventoryPaginationInfoCopyWithImpl<InventoryPaginationInfo>(this as InventoryPaginationInfo, _$identity);

  /// Serializes this InventoryPaginationInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InventoryPaginationInfo&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,totalPages);

@override
String toString() {
  return 'InventoryPaginationInfo(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $InventoryPaginationInfoCopyWith<$Res>  {
  factory $InventoryPaginationInfoCopyWith(InventoryPaginationInfo value, $Res Function(InventoryPaginationInfo) _then) = _$InventoryPaginationInfoCopyWithImpl;
@useResult
$Res call({
 int page, int limit, int total, int totalPages
});




}
/// @nodoc
class _$InventoryPaginationInfoCopyWithImpl<$Res>
    implements $InventoryPaginationInfoCopyWith<$Res> {
  _$InventoryPaginationInfoCopyWithImpl(this._self, this._then);

  final InventoryPaginationInfo _self;
  final $Res Function(InventoryPaginationInfo) _then;

/// Create a copy of InventoryPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? limit = null,Object? total = null,Object? totalPages = null,}) {
  return _then(_self.copyWith(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [InventoryPaginationInfo].
extension InventoryPaginationInfoPatterns on InventoryPaginationInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InventoryPaginationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InventoryPaginationInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InventoryPaginationInfo value)  $default,){
final _that = this;
switch (_that) {
case _InventoryPaginationInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InventoryPaginationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _InventoryPaginationInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int limit,  int total,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InventoryPaginationInfo() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int limit,  int total,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _InventoryPaginationInfo():
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int limit,  int total,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _InventoryPaginationInfo() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InventoryPaginationInfo implements InventoryPaginationInfo {
  const _InventoryPaginationInfo({required this.page, required this.limit, required this.total, required this.totalPages});
  factory _InventoryPaginationInfo.fromJson(Map<String, dynamic> json) => _$InventoryPaginationInfoFromJson(json);

@override final  int page;
@override final  int limit;
@override final  int total;
@override final  int totalPages;

/// Create a copy of InventoryPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InventoryPaginationInfoCopyWith<_InventoryPaginationInfo> get copyWith => __$InventoryPaginationInfoCopyWithImpl<_InventoryPaginationInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InventoryPaginationInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InventoryPaginationInfo&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,totalPages);

@override
String toString() {
  return 'InventoryPaginationInfo(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$InventoryPaginationInfoCopyWith<$Res> implements $InventoryPaginationInfoCopyWith<$Res> {
  factory _$InventoryPaginationInfoCopyWith(_InventoryPaginationInfo value, $Res Function(_InventoryPaginationInfo) _then) = __$InventoryPaginationInfoCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit, int total, int totalPages
});




}
/// @nodoc
class __$InventoryPaginationInfoCopyWithImpl<$Res>
    implements _$InventoryPaginationInfoCopyWith<$Res> {
  __$InventoryPaginationInfoCopyWithImpl(this._self, this._then);

  final _InventoryPaginationInfo _self;
  final $Res Function(_InventoryPaginationInfo) _then;

/// Create a copy of InventoryPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? total = null,Object? totalPages = null,}) {
  return _then(_InventoryPaginationInfo(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
