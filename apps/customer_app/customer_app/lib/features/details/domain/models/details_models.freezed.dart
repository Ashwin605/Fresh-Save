// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'details_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DealDetail {

 String get id; DealProduct get product; DealOffer get offer; DealInventory get inventory; DealStore get store; DealDistance? get distance; double get relevanceScore;
/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealDetailCopyWith<DealDetail> get copyWith => _$DealDetailCopyWithImpl<DealDetail>(this as DealDetail, _$identity);

  /// Serializes this DealDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.product, product) || other.product == product)&&(identical(other.offer, offer) || other.offer == offer)&&(identical(other.inventory, inventory) || other.inventory == inventory)&&(identical(other.store, store) || other.store == store)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.relevanceScore, relevanceScore) || other.relevanceScore == relevanceScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,product,offer,inventory,store,distance,relevanceScore);

@override
String toString() {
  return 'DealDetail(id: $id, product: $product, offer: $offer, inventory: $inventory, store: $store, distance: $distance, relevanceScore: $relevanceScore)';
}


}

/// @nodoc
abstract mixin class $DealDetailCopyWith<$Res>  {
  factory $DealDetailCopyWith(DealDetail value, $Res Function(DealDetail) _then) = _$DealDetailCopyWithImpl;
@useResult
$Res call({
 String id, DealProduct product, DealOffer offer, DealInventory inventory, DealStore store, DealDistance? distance, double relevanceScore
});


$DealProductCopyWith<$Res> get product;$DealOfferCopyWith<$Res> get offer;$DealInventoryCopyWith<$Res> get inventory;$DealStoreCopyWith<$Res> get store;$DealDistanceCopyWith<$Res>? get distance;

}
/// @nodoc
class _$DealDetailCopyWithImpl<$Res>
    implements $DealDetailCopyWith<$Res> {
  _$DealDetailCopyWithImpl(this._self, this._then);

  final DealDetail _self;
  final $Res Function(DealDetail) _then;

/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? product = null,Object? offer = null,Object? inventory = null,Object? store = null,Object? distance = freezed,Object? relevanceScore = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as DealProduct,offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as DealOffer,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as DealInventory,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as DealStore,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as DealDistance?,relevanceScore: null == relevanceScore ? _self.relevanceScore : relevanceScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealProductCopyWith<$Res> get product {
  
  return $DealProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealOfferCopyWith<$Res> get offer {
  
  return $DealOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealInventoryCopyWith<$Res> get inventory {
  
  return $DealInventoryCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealStoreCopyWith<$Res> get store {
  
  return $DealStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealDistanceCopyWith<$Res>? get distance {
    if (_self.distance == null) {
    return null;
  }

  return $DealDistanceCopyWith<$Res>(_self.distance!, (value) {
    return _then(_self.copyWith(distance: value));
  });
}
}


/// Adds pattern-matching-related methods to [DealDetail].
extension DealDetailPatterns on DealDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealDetail value)  $default,){
final _that = this;
switch (_that) {
case _DealDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealDetail value)?  $default,){
final _that = this;
switch (_that) {
case _DealDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DealProduct product,  DealOffer offer,  DealInventory inventory,  DealStore store,  DealDistance? distance,  double relevanceScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealDetail() when $default != null:
return $default(_that.id,_that.product,_that.offer,_that.inventory,_that.store,_that.distance,_that.relevanceScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DealProduct product,  DealOffer offer,  DealInventory inventory,  DealStore store,  DealDistance? distance,  double relevanceScore)  $default,) {final _that = this;
switch (_that) {
case _DealDetail():
return $default(_that.id,_that.product,_that.offer,_that.inventory,_that.store,_that.distance,_that.relevanceScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DealProduct product,  DealOffer offer,  DealInventory inventory,  DealStore store,  DealDistance? distance,  double relevanceScore)?  $default,) {final _that = this;
switch (_that) {
case _DealDetail() when $default != null:
return $default(_that.id,_that.product,_that.offer,_that.inventory,_that.store,_that.distance,_that.relevanceScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealDetail implements DealDetail {
  const _DealDetail({required this.id, required this.product, required this.offer, required this.inventory, required this.store, this.distance, this.relevanceScore = 0});
  factory _DealDetail.fromJson(Map<String, dynamic> json) => _$DealDetailFromJson(json);

@override final  String id;
@override final  DealProduct product;
@override final  DealOffer offer;
@override final  DealInventory inventory;
@override final  DealStore store;
@override final  DealDistance? distance;
@override@JsonKey() final  double relevanceScore;

/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealDetailCopyWith<_DealDetail> get copyWith => __$DealDetailCopyWithImpl<_DealDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.product, product) || other.product == product)&&(identical(other.offer, offer) || other.offer == offer)&&(identical(other.inventory, inventory) || other.inventory == inventory)&&(identical(other.store, store) || other.store == store)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.relevanceScore, relevanceScore) || other.relevanceScore == relevanceScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,product,offer,inventory,store,distance,relevanceScore);

@override
String toString() {
  return 'DealDetail(id: $id, product: $product, offer: $offer, inventory: $inventory, store: $store, distance: $distance, relevanceScore: $relevanceScore)';
}


}

/// @nodoc
abstract mixin class _$DealDetailCopyWith<$Res> implements $DealDetailCopyWith<$Res> {
  factory _$DealDetailCopyWith(_DealDetail value, $Res Function(_DealDetail) _then) = __$DealDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, DealProduct product, DealOffer offer, DealInventory inventory, DealStore store, DealDistance? distance, double relevanceScore
});


@override $DealProductCopyWith<$Res> get product;@override $DealOfferCopyWith<$Res> get offer;@override $DealInventoryCopyWith<$Res> get inventory;@override $DealStoreCopyWith<$Res> get store;@override $DealDistanceCopyWith<$Res>? get distance;

}
/// @nodoc
class __$DealDetailCopyWithImpl<$Res>
    implements _$DealDetailCopyWith<$Res> {
  __$DealDetailCopyWithImpl(this._self, this._then);

  final _DealDetail _self;
  final $Res Function(_DealDetail) _then;

/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? product = null,Object? offer = null,Object? inventory = null,Object? store = null,Object? distance = freezed,Object? relevanceScore = null,}) {
  return _then(_DealDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as DealProduct,offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as DealOffer,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as DealInventory,store: null == store ? _self.store : store // ignore: cast_nullable_to_non_nullable
as DealStore,distance: freezed == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as DealDistance?,relevanceScore: null == relevanceScore ? _self.relevanceScore : relevanceScore // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealProductCopyWith<$Res> get product {
  
  return $DealProductCopyWith<$Res>(_self.product, (value) {
    return _then(_self.copyWith(product: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealOfferCopyWith<$Res> get offer {
  
  return $DealOfferCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealInventoryCopyWith<$Res> get inventory {
  
  return $DealInventoryCopyWith<$Res>(_self.inventory, (value) {
    return _then(_self.copyWith(inventory: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealStoreCopyWith<$Res> get store {
  
  return $DealStoreCopyWith<$Res>(_self.store, (value) {
    return _then(_self.copyWith(store: value));
  });
}/// Create a copy of DealDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealDistanceCopyWith<$Res>? get distance {
    if (_self.distance == null) {
    return null;
  }

  return $DealDistanceCopyWith<$Res>(_self.distance!, (value) {
    return _then(_self.copyWith(distance: value));
  });
}
}


/// @nodoc
mixin _$DealProduct {

 String get id; String get name; String? get brand; String? get image; String? get unit; DealCategory? get category;
/// Create a copy of DealProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealProductCopyWith<DealProduct> get copyWith => _$DealProductCopyWithImpl<DealProduct>(this as DealProduct, _$identity);

  /// Serializes this DealProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.image, image) || other.image == image)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,brand,image,unit,category);

@override
String toString() {
  return 'DealProduct(id: $id, name: $name, brand: $brand, image: $image, unit: $unit, category: $category)';
}


}

/// @nodoc
abstract mixin class $DealProductCopyWith<$Res>  {
  factory $DealProductCopyWith(DealProduct value, $Res Function(DealProduct) _then) = _$DealProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? brand, String? image, String? unit, DealCategory? category
});


$DealCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$DealProductCopyWithImpl<$Res>
    implements $DealProductCopyWith<$Res> {
  _$DealProductCopyWithImpl(this._self, this._then);

  final DealProduct _self;
  final $Res Function(DealProduct) _then;

/// Create a copy of DealProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? brand = freezed,Object? image = freezed,Object? unit = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DealCategory?,
  ));
}
/// Create a copy of DealProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $DealCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [DealProduct].
extension DealProductPatterns on DealProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealProduct value)  $default,){
final _that = this;
switch (_that) {
case _DealProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealProduct value)?  $default,){
final _that = this;
switch (_that) {
case _DealProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? brand,  String? image,  String? unit,  DealCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealProduct() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.image,_that.unit,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? brand,  String? image,  String? unit,  DealCategory? category)  $default,) {final _that = this;
switch (_that) {
case _DealProduct():
return $default(_that.id,_that.name,_that.brand,_that.image,_that.unit,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? brand,  String? image,  String? unit,  DealCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _DealProduct() when $default != null:
return $default(_that.id,_that.name,_that.brand,_that.image,_that.unit,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealProduct implements DealProduct {
  const _DealProduct({required this.id, required this.name, this.brand, this.image, this.unit, this.category});
  factory _DealProduct.fromJson(Map<String, dynamic> json) => _$DealProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? brand;
@override final  String? image;
@override final  String? unit;
@override final  DealCategory? category;

/// Create a copy of DealProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealProductCopyWith<_DealProduct> get copyWith => __$DealProductCopyWithImpl<_DealProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.image, image) || other.image == image)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,brand,image,unit,category);

@override
String toString() {
  return 'DealProduct(id: $id, name: $name, brand: $brand, image: $image, unit: $unit, category: $category)';
}


}

/// @nodoc
abstract mixin class _$DealProductCopyWith<$Res> implements $DealProductCopyWith<$Res> {
  factory _$DealProductCopyWith(_DealProduct value, $Res Function(_DealProduct) _then) = __$DealProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? brand, String? image, String? unit, DealCategory? category
});


@override $DealCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$DealProductCopyWithImpl<$Res>
    implements _$DealProductCopyWith<$Res> {
  __$DealProductCopyWithImpl(this._self, this._then);

  final _DealProduct _self;
  final $Res Function(_DealProduct) _then;

/// Create a copy of DealProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? brand = freezed,Object? image = freezed,Object? unit = freezed,Object? category = freezed,}) {
  return _then(_DealProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DealCategory?,
  ));
}

/// Create a copy of DealProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $DealCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$DealCategory {

 String get id; String get name; String? get slug;
/// Create a copy of DealCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealCategoryCopyWith<DealCategory> get copyWith => _$DealCategoryCopyWithImpl<DealCategory>(this as DealCategory, _$identity);

  /// Serializes this DealCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'DealCategory(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class $DealCategoryCopyWith<$Res>  {
  factory $DealCategoryCopyWith(DealCategory value, $Res Function(DealCategory) _then) = _$DealCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? slug
});




}
/// @nodoc
class _$DealCategoryCopyWithImpl<$Res>
    implements $DealCategoryCopyWith<$Res> {
  _$DealCategoryCopyWithImpl(this._self, this._then);

  final DealCategory _self;
  final $Res Function(DealCategory) _then;

/// Create a copy of DealCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DealCategory].
extension DealCategoryPatterns on DealCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealCategory value)  $default,){
final _that = this;
switch (_that) {
case _DealCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealCategory value)?  $default,){
final _that = this;
switch (_that) {
case _DealCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealCategory() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? slug)  $default,) {final _that = this;
switch (_that) {
case _DealCategory():
return $default(_that.id,_that.name,_that.slug);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? slug)?  $default,) {final _that = this;
switch (_that) {
case _DealCategory() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealCategory implements DealCategory {
  const _DealCategory({required this.id, required this.name, this.slug});
  factory _DealCategory.fromJson(Map<String, dynamic> json) => _$DealCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? slug;

/// Create a copy of DealCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealCategoryCopyWith<_DealCategory> get copyWith => __$DealCategoryCopyWithImpl<_DealCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'DealCategory(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$DealCategoryCopyWith<$Res> implements $DealCategoryCopyWith<$Res> {
  factory _$DealCategoryCopyWith(_DealCategory value, $Res Function(_DealCategory) _then) = __$DealCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? slug
});




}
/// @nodoc
class __$DealCategoryCopyWithImpl<$Res>
    implements _$DealCategoryCopyWith<$Res> {
  __$DealCategoryCopyWithImpl(this._self, this._then);

  final _DealCategory _self;
  final $Res Function(_DealCategory) _then;

/// Create a copy of DealCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = freezed,}) {
  return _then(_DealCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DealOffer {

 String? get title; String? get description; String get discountType; double get discountValue; double get originalPrice; double get discountedPrice; double get discountAmount; DateTime get startsAt; DateTime get endsAt;
/// Create a copy of DealOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealOfferCopyWith<DealOffer> get copyWith => _$DealOfferCopyWithImpl<DealOffer>(this as DealOffer, _$identity);

  /// Serializes this DealOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealOffer&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,discountType,discountValue,originalPrice,discountedPrice,discountAmount,startsAt,endsAt);

@override
String toString() {
  return 'DealOffer(title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, originalPrice: $originalPrice, discountedPrice: $discountedPrice, discountAmount: $discountAmount, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class $DealOfferCopyWith<$Res>  {
  factory $DealOfferCopyWith(DealOffer value, $Res Function(DealOffer) _then) = _$DealOfferCopyWithImpl;
@useResult
$Res call({
 String? title, String? description, String discountType, double discountValue, double originalPrice, double discountedPrice, double discountAmount, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class _$DealOfferCopyWithImpl<$Res>
    implements $DealOfferCopyWith<$Res> {
  _$DealOfferCopyWithImpl(this._self, this._then);

  final DealOffer _self;
  final $Res Function(DealOffer) _then;

/// Create a copy of DealOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = freezed,Object? description = freezed,Object? discountType = null,Object? discountValue = null,Object? originalPrice = null,Object? discountedPrice = null,Object? discountAmount = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_self.copyWith(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: null == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DealOffer].
extension DealOfferPatterns on DealOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealOffer value)  $default,){
final _that = this;
switch (_that) {
case _DealOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealOffer value)?  $default,){
final _that = this;
switch (_that) {
case _DealOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? title,  String? description,  String discountType,  double discountValue,  double originalPrice,  double discountedPrice,  double discountAmount,  DateTime startsAt,  DateTime endsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealOffer() when $default != null:
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.originalPrice,_that.discountedPrice,_that.discountAmount,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? title,  String? description,  String discountType,  double discountValue,  double originalPrice,  double discountedPrice,  double discountAmount,  DateTime startsAt,  DateTime endsAt)  $default,) {final _that = this;
switch (_that) {
case _DealOffer():
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.originalPrice,_that.discountedPrice,_that.discountAmount,_that.startsAt,_that.endsAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? title,  String? description,  String discountType,  double discountValue,  double originalPrice,  double discountedPrice,  double discountAmount,  DateTime startsAt,  DateTime endsAt)?  $default,) {final _that = this;
switch (_that) {
case _DealOffer() when $default != null:
return $default(_that.title,_that.description,_that.discountType,_that.discountValue,_that.originalPrice,_that.discountedPrice,_that.discountAmount,_that.startsAt,_that.endsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealOffer implements DealOffer {
  const _DealOffer({this.title, this.description, required this.discountType, required this.discountValue, required this.originalPrice, required this.discountedPrice, required this.discountAmount, required this.startsAt, required this.endsAt});
  factory _DealOffer.fromJson(Map<String, dynamic> json) => _$DealOfferFromJson(json);

@override final  String? title;
@override final  String? description;
@override final  String discountType;
@override final  double discountValue;
@override final  double originalPrice;
@override final  double discountedPrice;
@override final  double discountAmount;
@override final  DateTime startsAt;
@override final  DateTime endsAt;

/// Create a copy of DealOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealOfferCopyWith<_DealOffer> get copyWith => __$DealOfferCopyWithImpl<_DealOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealOffer&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.discountType, discountType) || other.discountType == discountType)&&(identical(other.discountValue, discountValue) || other.discountValue == discountValue)&&(identical(other.originalPrice, originalPrice) || other.originalPrice == originalPrice)&&(identical(other.discountedPrice, discountedPrice) || other.discountedPrice == discountedPrice)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,discountType,discountValue,originalPrice,discountedPrice,discountAmount,startsAt,endsAt);

@override
String toString() {
  return 'DealOffer(title: $title, description: $description, discountType: $discountType, discountValue: $discountValue, originalPrice: $originalPrice, discountedPrice: $discountedPrice, discountAmount: $discountAmount, startsAt: $startsAt, endsAt: $endsAt)';
}


}

/// @nodoc
abstract mixin class _$DealOfferCopyWith<$Res> implements $DealOfferCopyWith<$Res> {
  factory _$DealOfferCopyWith(_DealOffer value, $Res Function(_DealOffer) _then) = __$DealOfferCopyWithImpl;
@override @useResult
$Res call({
 String? title, String? description, String discountType, double discountValue, double originalPrice, double discountedPrice, double discountAmount, DateTime startsAt, DateTime endsAt
});




}
/// @nodoc
class __$DealOfferCopyWithImpl<$Res>
    implements _$DealOfferCopyWith<$Res> {
  __$DealOfferCopyWithImpl(this._self, this._then);

  final _DealOffer _self;
  final $Res Function(_DealOffer) _then;

/// Create a copy of DealOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = freezed,Object? description = freezed,Object? discountType = null,Object? discountValue = null,Object? originalPrice = null,Object? discountedPrice = null,Object? discountAmount = null,Object? startsAt = null,Object? endsAt = null,}) {
  return _then(_DealOffer(
title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,discountType: null == discountType ? _self.discountType : discountType // ignore: cast_nullable_to_non_nullable
as String,discountValue: null == discountValue ? _self.discountValue : discountValue // ignore: cast_nullable_to_non_nullable
as double,originalPrice: null == originalPrice ? _self.originalPrice : originalPrice // ignore: cast_nullable_to_non_nullable
as double,discountedPrice: null == discountedPrice ? _self.discountedPrice : discountedPrice // ignore: cast_nullable_to_non_nullable
as double,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as double,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DealInventory {

 String get id; int get availableQuantity; DateTime get expiryDate; String get expiryStatus;
/// Create a copy of DealInventory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealInventoryCopyWith<DealInventory> get copyWith => _$DealInventoryCopyWithImpl<DealInventory>(this as DealInventory, _$identity);

  /// Serializes this DealInventory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealInventory&&(identical(other.id, id) || other.id == id)&&(identical(other.availableQuantity, availableQuantity) || other.availableQuantity == availableQuantity)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.expiryStatus, expiryStatus) || other.expiryStatus == expiryStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,availableQuantity,expiryDate,expiryStatus);

@override
String toString() {
  return 'DealInventory(id: $id, availableQuantity: $availableQuantity, expiryDate: $expiryDate, expiryStatus: $expiryStatus)';
}


}

/// @nodoc
abstract mixin class $DealInventoryCopyWith<$Res>  {
  factory $DealInventoryCopyWith(DealInventory value, $Res Function(DealInventory) _then) = _$DealInventoryCopyWithImpl;
@useResult
$Res call({
 String id, int availableQuantity, DateTime expiryDate, String expiryStatus
});




}
/// @nodoc
class _$DealInventoryCopyWithImpl<$Res>
    implements $DealInventoryCopyWith<$Res> {
  _$DealInventoryCopyWithImpl(this._self, this._then);

  final DealInventory _self;
  final $Res Function(DealInventory) _then;

/// Create a copy of DealInventory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? availableQuantity = null,Object? expiryDate = null,Object? expiryStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,availableQuantity: null == availableQuantity ? _self.availableQuantity : availableQuantity // ignore: cast_nullable_to_non_nullable
as int,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,expiryStatus: null == expiryStatus ? _self.expiryStatus : expiryStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DealInventory].
extension DealInventoryPatterns on DealInventory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealInventory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealInventory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealInventory value)  $default,){
final _that = this;
switch (_that) {
case _DealInventory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealInventory value)?  $default,){
final _that = this;
switch (_that) {
case _DealInventory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int availableQuantity,  DateTime expiryDate,  String expiryStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealInventory() when $default != null:
return $default(_that.id,_that.availableQuantity,_that.expiryDate,_that.expiryStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int availableQuantity,  DateTime expiryDate,  String expiryStatus)  $default,) {final _that = this;
switch (_that) {
case _DealInventory():
return $default(_that.id,_that.availableQuantity,_that.expiryDate,_that.expiryStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int availableQuantity,  DateTime expiryDate,  String expiryStatus)?  $default,) {final _that = this;
switch (_that) {
case _DealInventory() when $default != null:
return $default(_that.id,_that.availableQuantity,_that.expiryDate,_that.expiryStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealInventory extends DealInventory {
  const _DealInventory({required this.id, required this.availableQuantity, required this.expiryDate, required this.expiryStatus}): super._();
  factory _DealInventory.fromJson(Map<String, dynamic> json) => _$DealInventoryFromJson(json);

@override final  String id;
@override final  int availableQuantity;
@override final  DateTime expiryDate;
@override final  String expiryStatus;

/// Create a copy of DealInventory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealInventoryCopyWith<_DealInventory> get copyWith => __$DealInventoryCopyWithImpl<_DealInventory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealInventoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealInventory&&(identical(other.id, id) || other.id == id)&&(identical(other.availableQuantity, availableQuantity) || other.availableQuantity == availableQuantity)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.expiryStatus, expiryStatus) || other.expiryStatus == expiryStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,availableQuantity,expiryDate,expiryStatus);

@override
String toString() {
  return 'DealInventory(id: $id, availableQuantity: $availableQuantity, expiryDate: $expiryDate, expiryStatus: $expiryStatus)';
}


}

/// @nodoc
abstract mixin class _$DealInventoryCopyWith<$Res> implements $DealInventoryCopyWith<$Res> {
  factory _$DealInventoryCopyWith(_DealInventory value, $Res Function(_DealInventory) _then) = __$DealInventoryCopyWithImpl;
@override @useResult
$Res call({
 String id, int availableQuantity, DateTime expiryDate, String expiryStatus
});




}
/// @nodoc
class __$DealInventoryCopyWithImpl<$Res>
    implements _$DealInventoryCopyWith<$Res> {
  __$DealInventoryCopyWithImpl(this._self, this._then);

  final _DealInventory _self;
  final $Res Function(_DealInventory) _then;

/// Create a copy of DealInventory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? availableQuantity = null,Object? expiryDate = null,Object? expiryStatus = null,}) {
  return _then(_DealInventory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,availableQuantity: null == availableQuantity ? _self.availableQuantity : availableQuantity // ignore: cast_nullable_to_non_nullable
as int,expiryDate: null == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime,expiryStatus: null == expiryStatus ? _self.expiryStatus : expiryStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DealStore {

 String get id; String get name; String? get logo; String? get address; String? get city;
/// Create a copy of DealStore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealStoreCopyWith<DealStore> get copyWith => _$DealStoreCopyWithImpl<DealStore>(this as DealStore, _$identity);

  /// Serializes this DealStore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealStore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logo,address,city);

@override
String toString() {
  return 'DealStore(id: $id, name: $name, logo: $logo, address: $address, city: $city)';
}


}

/// @nodoc
abstract mixin class $DealStoreCopyWith<$Res>  {
  factory $DealStoreCopyWith(DealStore value, $Res Function(DealStore) _then) = _$DealStoreCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? logo, String? address, String? city
});




}
/// @nodoc
class _$DealStoreCopyWithImpl<$Res>
    implements $DealStoreCopyWith<$Res> {
  _$DealStoreCopyWithImpl(this._self, this._then);

  final DealStore _self;
  final $Res Function(DealStore) _then;

/// Create a copy of DealStore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? logo = freezed,Object? address = freezed,Object? city = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DealStore].
extension DealStorePatterns on DealStore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealStore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealStore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealStore value)  $default,){
final _that = this;
switch (_that) {
case _DealStore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealStore value)?  $default,){
final _that = this;
switch (_that) {
case _DealStore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? logo,  String? address,  String? city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealStore() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.address,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? logo,  String? address,  String? city)  $default,) {final _that = this;
switch (_that) {
case _DealStore():
return $default(_that.id,_that.name,_that.logo,_that.address,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? logo,  String? address,  String? city)?  $default,) {final _that = this;
switch (_that) {
case _DealStore() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.address,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealStore implements DealStore {
  const _DealStore({required this.id, required this.name, this.logo, this.address, this.city});
  factory _DealStore.fromJson(Map<String, dynamic> json) => _$DealStoreFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? logo;
@override final  String? address;
@override final  String? city;

/// Create a copy of DealStore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealStoreCopyWith<_DealStore> get copyWith => __$DealStoreCopyWithImpl<_DealStore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealStoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealStore&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logo,address,city);

@override
String toString() {
  return 'DealStore(id: $id, name: $name, logo: $logo, address: $address, city: $city)';
}


}

/// @nodoc
abstract mixin class _$DealStoreCopyWith<$Res> implements $DealStoreCopyWith<$Res> {
  factory _$DealStoreCopyWith(_DealStore value, $Res Function(_DealStore) _then) = __$DealStoreCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? logo, String? address, String? city
});




}
/// @nodoc
class __$DealStoreCopyWithImpl<$Res>
    implements _$DealStoreCopyWith<$Res> {
  __$DealStoreCopyWithImpl(this._self, this._then);

  final _DealStore _self;
  final $Res Function(_DealStore) _then;

/// Create a copy of DealStore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? logo = freezed,Object? address = freezed,Object? city = freezed,}) {
  return _then(_DealStore(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DealDistance {

 double get value; String get unit;
/// Create a copy of DealDistance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealDistanceCopyWith<DealDistance> get copyWith => _$DealDistanceCopyWithImpl<DealDistance>(this as DealDistance, _$identity);

  /// Serializes this DealDistance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealDistance&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,unit);

@override
String toString() {
  return 'DealDistance(value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $DealDistanceCopyWith<$Res>  {
  factory $DealDistanceCopyWith(DealDistance value, $Res Function(DealDistance) _then) = _$DealDistanceCopyWithImpl;
@useResult
$Res call({
 double value, String unit
});




}
/// @nodoc
class _$DealDistanceCopyWithImpl<$Res>
    implements $DealDistanceCopyWith<$Res> {
  _$DealDistanceCopyWithImpl(this._self, this._then);

  final DealDistance _self;
  final $Res Function(DealDistance) _then;

/// Create a copy of DealDistance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? unit = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DealDistance].
extension DealDistancePatterns on DealDistance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealDistance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealDistance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealDistance value)  $default,){
final _that = this;
switch (_that) {
case _DealDistance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealDistance value)?  $default,){
final _that = this;
switch (_that) {
case _DealDistance() when $default != null:
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
case _DealDistance() when $default != null:
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
case _DealDistance():
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
case _DealDistance() when $default != null:
return $default(_that.value,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealDistance implements DealDistance {
  const _DealDistance({required this.value, required this.unit});
  factory _DealDistance.fromJson(Map<String, dynamic> json) => _$DealDistanceFromJson(json);

@override final  double value;
@override final  String unit;

/// Create a copy of DealDistance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealDistanceCopyWith<_DealDistance> get copyWith => __$DealDistanceCopyWithImpl<_DealDistance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealDistanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealDistance&&(identical(other.value, value) || other.value == value)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,unit);

@override
String toString() {
  return 'DealDistance(value: $value, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$DealDistanceCopyWith<$Res> implements $DealDistanceCopyWith<$Res> {
  factory _$DealDistanceCopyWith(_DealDistance value, $Res Function(_DealDistance) _then) = __$DealDistanceCopyWithImpl;
@override @useResult
$Res call({
 double value, String unit
});




}
/// @nodoc
class __$DealDistanceCopyWithImpl<$Res>
    implements _$DealDistanceCopyWith<$Res> {
  __$DealDistanceCopyWithImpl(this._self, this._then);

  final _DealDistance _self;
  final $Res Function(_DealDistance) _then;

/// Create a copy of DealDistance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? unit = null,}) {
  return _then(_DealDistance(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProductDetail {

 String get id; String get name; String? get slug; String? get description; String? get brand; String? get sku; String? get barcode; String? get image; String? get unit; String? get categoryId; String? get status; DealCategory? get category;
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailCopyWith<ProductDetail> get copyWith => _$ProductDetailCopyWithImpl<ProductDetail>(this as ProductDetail, _$identity);

  /// Serializes this ProductDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.image, image) || other.image == image)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,brand,sku,barcode,image,unit,categoryId,status,category);

@override
String toString() {
  return 'ProductDetail(id: $id, name: $name, slug: $slug, description: $description, brand: $brand, sku: $sku, barcode: $barcode, image: $image, unit: $unit, categoryId: $categoryId, status: $status, category: $category)';
}


}

/// @nodoc
abstract mixin class $ProductDetailCopyWith<$Res>  {
  factory $ProductDetailCopyWith(ProductDetail value, $Res Function(ProductDetail) _then) = _$ProductDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? slug, String? description, String? brand, String? sku, String? barcode, String? image, String? unit, String? categoryId, String? status, DealCategory? category
});


$DealCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$ProductDetailCopyWithImpl<$Res>
    implements $ProductDetailCopyWith<$Res> {
  _$ProductDetailCopyWithImpl(this._self, this._then);

  final ProductDetail _self;
  final $Res Function(ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = freezed,Object? description = freezed,Object? brand = freezed,Object? sku = freezed,Object? barcode = freezed,Object? image = freezed,Object? unit = freezed,Object? categoryId = freezed,Object? status = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DealCategory?,
  ));
}
/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $DealCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetail].
extension ProductDetailPatterns on ProductDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProductDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? slug,  String? description,  String? brand,  String? sku,  String? barcode,  String? image,  String? unit,  String? categoryId,  String? status,  DealCategory? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.brand,_that.sku,_that.barcode,_that.image,_that.unit,_that.categoryId,_that.status,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? slug,  String? description,  String? brand,  String? sku,  String? barcode,  String? image,  String? unit,  String? categoryId,  String? status,  DealCategory? category)  $default,) {final _that = this;
switch (_that) {
case _ProductDetail():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.brand,_that.sku,_that.barcode,_that.image,_that.unit,_that.categoryId,_that.status,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? slug,  String? description,  String? brand,  String? sku,  String? barcode,  String? image,  String? unit,  String? categoryId,  String? status,  DealCategory? category)?  $default,) {final _that = this;
switch (_that) {
case _ProductDetail() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.brand,_that.sku,_that.barcode,_that.image,_that.unit,_that.categoryId,_that.status,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductDetail implements ProductDetail {
  const _ProductDetail({required this.id, required this.name, this.slug, this.description, this.brand, this.sku, this.barcode, this.image, this.unit, this.categoryId, this.status, this.category});
  factory _ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? slug;
@override final  String? description;
@override final  String? brand;
@override final  String? sku;
@override final  String? barcode;
@override final  String? image;
@override final  String? unit;
@override final  String? categoryId;
@override final  String? status;
@override final  DealCategory? category;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductDetailCopyWith<_ProductDetail> get copyWith => __$ProductDetailCopyWithImpl<_ProductDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.image, image) || other.image == image)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,brand,sku,barcode,image,unit,categoryId,status,category);

@override
String toString() {
  return 'ProductDetail(id: $id, name: $name, slug: $slug, description: $description, brand: $brand, sku: $sku, barcode: $barcode, image: $image, unit: $unit, categoryId: $categoryId, status: $status, category: $category)';
}


}

/// @nodoc
abstract mixin class _$ProductDetailCopyWith<$Res> implements $ProductDetailCopyWith<$Res> {
  factory _$ProductDetailCopyWith(_ProductDetail value, $Res Function(_ProductDetail) _then) = __$ProductDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? slug, String? description, String? brand, String? sku, String? barcode, String? image, String? unit, String? categoryId, String? status, DealCategory? category
});


@override $DealCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$ProductDetailCopyWithImpl<$Res>
    implements _$ProductDetailCopyWith<$Res> {
  __$ProductDetailCopyWithImpl(this._self, this._then);

  final _ProductDetail _self;
  final $Res Function(_ProductDetail) _then;

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = freezed,Object? description = freezed,Object? brand = freezed,Object? sku = freezed,Object? barcode = freezed,Object? image = freezed,Object? unit = freezed,Object? categoryId = freezed,Object? status = freezed,Object? category = freezed,}) {
  return _then(_ProductDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DealCategory?,
  ));
}

/// Create a copy of ProductDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $DealCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
