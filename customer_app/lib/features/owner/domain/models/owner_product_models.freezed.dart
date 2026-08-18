// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'owner_product_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OwnerProductCategory {

 String get id; String get name; String get slug;
/// Create a copy of OwnerProductCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProductCategoryCopyWith<OwnerProductCategory> get copyWith => _$OwnerProductCategoryCopyWithImpl<OwnerProductCategory>(this as OwnerProductCategory, _$identity);

  /// Serializes this OwnerProductCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProductCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'OwnerProductCategory(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class $OwnerProductCategoryCopyWith<$Res>  {
  factory $OwnerProductCategoryCopyWith(OwnerProductCategory value, $Res Function(OwnerProductCategory) _then) = _$OwnerProductCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug
});




}
/// @nodoc
class _$OwnerProductCategoryCopyWithImpl<$Res>
    implements $OwnerProductCategoryCopyWith<$Res> {
  _$OwnerProductCategoryCopyWithImpl(this._self, this._then);

  final OwnerProductCategory _self;
  final $Res Function(OwnerProductCategory) _then;

/// Create a copy of OwnerProductCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OwnerProductCategory].
extension OwnerProductCategoryPatterns on OwnerProductCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProductCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProductCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProductCategory value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProductCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProductCategory value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProductCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerProductCategory() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug)  $default,) {final _that = this;
switch (_that) {
case _OwnerProductCategory():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug)?  $default,) {final _that = this;
switch (_that) {
case _OwnerProductCategory() when $default != null:
return $default(_that.id,_that.name,_that.slug);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProductCategory implements OwnerProductCategory {
  const _OwnerProductCategory({required this.id, required this.name, required this.slug});
  factory _OwnerProductCategory.fromJson(Map<String, dynamic> json) => _$OwnerProductCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;

/// Create a copy of OwnerProductCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProductCategoryCopyWith<_OwnerProductCategory> get copyWith => __$OwnerProductCategoryCopyWithImpl<_OwnerProductCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProductCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProductCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug);

@override
String toString() {
  return 'OwnerProductCategory(id: $id, name: $name, slug: $slug)';
}


}

/// @nodoc
abstract mixin class _$OwnerProductCategoryCopyWith<$Res> implements $OwnerProductCategoryCopyWith<$Res> {
  factory _$OwnerProductCategoryCopyWith(_OwnerProductCategory value, $Res Function(_OwnerProductCategory) _then) = __$OwnerProductCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug
});




}
/// @nodoc
class __$OwnerProductCategoryCopyWithImpl<$Res>
    implements _$OwnerProductCategoryCopyWith<$Res> {
  __$OwnerProductCategoryCopyWithImpl(this._self, this._then);

  final _OwnerProductCategory _self;
  final $Res Function(_OwnerProductCategory) _then;

/// Create a copy of OwnerProductCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,}) {
  return _then(_OwnerProductCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OwnerProduct {

 String get id; String get name; String get categoryId; String? get slug; String? get description; String? get brand; String? get sku; String? get barcode; String? get image; String? get unit; String get status; OwnerProductCategory? get category; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of OwnerProduct
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProductCopyWith<OwnerProduct> get copyWith => _$OwnerProductCopyWithImpl<OwnerProduct>(this as OwnerProduct, _$identity);

  /// Serializes this OwnerProduct to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.image, image) || other.image == image)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,slug,description,brand,sku,barcode,image,unit,status,category,createdAt,updatedAt);

@override
String toString() {
  return 'OwnerProduct(id: $id, name: $name, categoryId: $categoryId, slug: $slug, description: $description, brand: $brand, sku: $sku, barcode: $barcode, image: $image, unit: $unit, status: $status, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $OwnerProductCopyWith<$Res>  {
  factory $OwnerProductCopyWith(OwnerProduct value, $Res Function(OwnerProduct) _then) = _$OwnerProductCopyWithImpl;
@useResult
$Res call({
 String id, String name, String categoryId, String? slug, String? description, String? brand, String? sku, String? barcode, String? image, String? unit, String status, OwnerProductCategory? category, DateTime? createdAt, DateTime? updatedAt
});


$OwnerProductCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class _$OwnerProductCopyWithImpl<$Res>
    implements $OwnerProductCopyWith<$Res> {
  _$OwnerProductCopyWithImpl(this._self, this._then);

  final OwnerProduct _self;
  final $Res Function(OwnerProduct) _then;

/// Create a copy of OwnerProduct
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? slug = freezed,Object? description = freezed,Object? brand = freezed,Object? sku = freezed,Object? barcode = freezed,Object? image = freezed,Object? unit = freezed,Object? status = null,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as OwnerProductCategory?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of OwnerProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProductCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $OwnerProductCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerProduct].
extension OwnerProductPatterns on OwnerProduct {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProduct value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProduct() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProduct value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProduct():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProduct value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProduct() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String? slug,  String? description,  String? brand,  String? sku,  String? barcode,  String? image,  String? unit,  String status,  OwnerProductCategory? category,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerProduct() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.slug,_that.description,_that.brand,_that.sku,_that.barcode,_that.image,_that.unit,_that.status,_that.category,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String categoryId,  String? slug,  String? description,  String? brand,  String? sku,  String? barcode,  String? image,  String? unit,  String status,  OwnerProductCategory? category,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _OwnerProduct():
return $default(_that.id,_that.name,_that.categoryId,_that.slug,_that.description,_that.brand,_that.sku,_that.barcode,_that.image,_that.unit,_that.status,_that.category,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String categoryId,  String? slug,  String? description,  String? brand,  String? sku,  String? barcode,  String? image,  String? unit,  String status,  OwnerProductCategory? category,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _OwnerProduct() when $default != null:
return $default(_that.id,_that.name,_that.categoryId,_that.slug,_that.description,_that.brand,_that.sku,_that.barcode,_that.image,_that.unit,_that.status,_that.category,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProduct implements OwnerProduct {
  const _OwnerProduct({required this.id, required this.name, required this.categoryId, this.slug, this.description, this.brand, this.sku, this.barcode, this.image, this.unit, required this.status, this.category, this.createdAt, this.updatedAt});
  factory _OwnerProduct.fromJson(Map<String, dynamic> json) => _$OwnerProductFromJson(json);

@override final  String id;
@override final  String name;
@override final  String categoryId;
@override final  String? slug;
@override final  String? description;
@override final  String? brand;
@override final  String? sku;
@override final  String? barcode;
@override final  String? image;
@override final  String? unit;
@override final  String status;
@override final  OwnerProductCategory? category;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of OwnerProduct
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProductCopyWith<_OwnerProduct> get copyWith => __$OwnerProductCopyWithImpl<_OwnerProduct>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProductToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProduct&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.sku, sku) || other.sku == sku)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.image, image) || other.image == image)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.status, status) || other.status == status)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,categoryId,slug,description,brand,sku,barcode,image,unit,status,category,createdAt,updatedAt);

@override
String toString() {
  return 'OwnerProduct(id: $id, name: $name, categoryId: $categoryId, slug: $slug, description: $description, brand: $brand, sku: $sku, barcode: $barcode, image: $image, unit: $unit, status: $status, category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$OwnerProductCopyWith<$Res> implements $OwnerProductCopyWith<$Res> {
  factory _$OwnerProductCopyWith(_OwnerProduct value, $Res Function(_OwnerProduct) _then) = __$OwnerProductCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String categoryId, String? slug, String? description, String? brand, String? sku, String? barcode, String? image, String? unit, String status, OwnerProductCategory? category, DateTime? createdAt, DateTime? updatedAt
});


@override $OwnerProductCategoryCopyWith<$Res>? get category;

}
/// @nodoc
class __$OwnerProductCopyWithImpl<$Res>
    implements _$OwnerProductCopyWith<$Res> {
  __$OwnerProductCopyWithImpl(this._self, this._then);

  final _OwnerProduct _self;
  final $Res Function(_OwnerProduct) _then;

/// Create a copy of OwnerProduct
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? categoryId = null,Object? slug = freezed,Object? description = freezed,Object? brand = freezed,Object? sku = freezed,Object? barcode = freezed,Object? image = freezed,Object? unit = freezed,Object? status = null,Object? category = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_OwnerProduct(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,slug: freezed == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,sku: freezed == sku ? _self.sku : sku // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as OwnerProductCategory?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of OwnerProduct
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProductCategoryCopyWith<$Res>? get category {
    if (_self.category == null) {
    return null;
  }

  return $OwnerProductCategoryCopyWith<$Res>(_self.category!, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// @nodoc
mixin _$OwnerProductPaginatedResponse {

 bool get success; OwnerProductPaginatedData get data;
/// Create a copy of OwnerProductPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProductPaginatedResponseCopyWith<OwnerProductPaginatedResponse> get copyWith => _$OwnerProductPaginatedResponseCopyWithImpl<OwnerProductPaginatedResponse>(this as OwnerProductPaginatedResponse, _$identity);

  /// Serializes this OwnerProductPaginatedResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProductPaginatedResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'OwnerProductPaginatedResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class $OwnerProductPaginatedResponseCopyWith<$Res>  {
  factory $OwnerProductPaginatedResponseCopyWith(OwnerProductPaginatedResponse value, $Res Function(OwnerProductPaginatedResponse) _then) = _$OwnerProductPaginatedResponseCopyWithImpl;
@useResult
$Res call({
 bool success, OwnerProductPaginatedData data
});


$OwnerProductPaginatedDataCopyWith<$Res> get data;

}
/// @nodoc
class _$OwnerProductPaginatedResponseCopyWithImpl<$Res>
    implements $OwnerProductPaginatedResponseCopyWith<$Res> {
  _$OwnerProductPaginatedResponseCopyWithImpl(this._self, this._then);

  final OwnerProductPaginatedResponse _self;
  final $Res Function(OwnerProductPaginatedResponse) _then;

/// Create a copy of OwnerProductPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? success = null,Object? data = null,}) {
  return _then(_self.copyWith(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OwnerProductPaginatedData,
  ));
}
/// Create a copy of OwnerProductPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProductPaginatedDataCopyWith<$Res> get data {
  
  return $OwnerProductPaginatedDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerProductPaginatedResponse].
extension OwnerProductPaginatedResponsePatterns on OwnerProductPaginatedResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProductPaginatedResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProductPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProductPaginatedResponse value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProductPaginatedResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProductPaginatedResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProductPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool success,  OwnerProductPaginatedData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerProductPaginatedResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool success,  OwnerProductPaginatedData data)  $default,) {final _that = this;
switch (_that) {
case _OwnerProductPaginatedResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool success,  OwnerProductPaginatedData data)?  $default,) {final _that = this;
switch (_that) {
case _OwnerProductPaginatedResponse() when $default != null:
return $default(_that.success,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProductPaginatedResponse implements OwnerProductPaginatedResponse {
  const _OwnerProductPaginatedResponse({required this.success, required this.data});
  factory _OwnerProductPaginatedResponse.fromJson(Map<String, dynamic> json) => _$OwnerProductPaginatedResponseFromJson(json);

@override final  bool success;
@override final  OwnerProductPaginatedData data;

/// Create a copy of OwnerProductPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProductPaginatedResponseCopyWith<_OwnerProductPaginatedResponse> get copyWith => __$OwnerProductPaginatedResponseCopyWithImpl<_OwnerProductPaginatedResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProductPaginatedResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProductPaginatedResponse&&(identical(other.success, success) || other.success == success)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,success,data);

@override
String toString() {
  return 'OwnerProductPaginatedResponse(success: $success, data: $data)';
}


}

/// @nodoc
abstract mixin class _$OwnerProductPaginatedResponseCopyWith<$Res> implements $OwnerProductPaginatedResponseCopyWith<$Res> {
  factory _$OwnerProductPaginatedResponseCopyWith(_OwnerProductPaginatedResponse value, $Res Function(_OwnerProductPaginatedResponse) _then) = __$OwnerProductPaginatedResponseCopyWithImpl;
@override @useResult
$Res call({
 bool success, OwnerProductPaginatedData data
});


@override $OwnerProductPaginatedDataCopyWith<$Res> get data;

}
/// @nodoc
class __$OwnerProductPaginatedResponseCopyWithImpl<$Res>
    implements _$OwnerProductPaginatedResponseCopyWith<$Res> {
  __$OwnerProductPaginatedResponseCopyWithImpl(this._self, this._then);

  final _OwnerProductPaginatedResponse _self;
  final $Res Function(_OwnerProductPaginatedResponse) _then;

/// Create a copy of OwnerProductPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? success = null,Object? data = null,}) {
  return _then(_OwnerProductPaginatedResponse(
success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as OwnerProductPaginatedData,
  ));
}

/// Create a copy of OwnerProductPaginatedResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProductPaginatedDataCopyWith<$Res> get data {
  
  return $OwnerProductPaginatedDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// @nodoc
mixin _$OwnerProductPaginatedData {

 List<OwnerProduct> get items; OwnerProductPaginationInfo get pagination;
/// Create a copy of OwnerProductPaginatedData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProductPaginatedDataCopyWith<OwnerProductPaginatedData> get copyWith => _$OwnerProductPaginatedDataCopyWithImpl<OwnerProductPaginatedData>(this as OwnerProductPaginatedData, _$identity);

  /// Serializes this OwnerProductPaginatedData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProductPaginatedData&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),pagination);

@override
String toString() {
  return 'OwnerProductPaginatedData(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class $OwnerProductPaginatedDataCopyWith<$Res>  {
  factory $OwnerProductPaginatedDataCopyWith(OwnerProductPaginatedData value, $Res Function(OwnerProductPaginatedData) _then) = _$OwnerProductPaginatedDataCopyWithImpl;
@useResult
$Res call({
 List<OwnerProduct> items, OwnerProductPaginationInfo pagination
});


$OwnerProductPaginationInfoCopyWith<$Res> get pagination;

}
/// @nodoc
class _$OwnerProductPaginatedDataCopyWithImpl<$Res>
    implements $OwnerProductPaginatedDataCopyWith<$Res> {
  _$OwnerProductPaginatedDataCopyWithImpl(this._self, this._then);

  final OwnerProductPaginatedData _self;
  final $Res Function(OwnerProductPaginatedData) _then;

/// Create a copy of OwnerProductPaginatedData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerProduct>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as OwnerProductPaginationInfo,
  ));
}
/// Create a copy of OwnerProductPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProductPaginationInfoCopyWith<$Res> get pagination {
  
  return $OwnerProductPaginationInfoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [OwnerProductPaginatedData].
extension OwnerProductPaginatedDataPatterns on OwnerProductPaginatedData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProductPaginatedData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProductPaginatedData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProductPaginatedData value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProductPaginatedData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProductPaginatedData value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProductPaginatedData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OwnerProduct> items,  OwnerProductPaginationInfo pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OwnerProductPaginatedData() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OwnerProduct> items,  OwnerProductPaginationInfo pagination)  $default,) {final _that = this;
switch (_that) {
case _OwnerProductPaginatedData():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OwnerProduct> items,  OwnerProductPaginationInfo pagination)?  $default,) {final _that = this;
switch (_that) {
case _OwnerProductPaginatedData() when $default != null:
return $default(_that.items,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProductPaginatedData implements OwnerProductPaginatedData {
  const _OwnerProductPaginatedData({required final  List<OwnerProduct> items, required this.pagination}): _items = items;
  factory _OwnerProductPaginatedData.fromJson(Map<String, dynamic> json) => _$OwnerProductPaginatedDataFromJson(json);

 final  List<OwnerProduct> _items;
@override List<OwnerProduct> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  OwnerProductPaginationInfo pagination;

/// Create a copy of OwnerProductPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProductPaginatedDataCopyWith<_OwnerProductPaginatedData> get copyWith => __$OwnerProductPaginatedDataCopyWithImpl<_OwnerProductPaginatedData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProductPaginatedDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProductPaginatedData&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pagination);

@override
String toString() {
  return 'OwnerProductPaginatedData(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$OwnerProductPaginatedDataCopyWith<$Res> implements $OwnerProductPaginatedDataCopyWith<$Res> {
  factory _$OwnerProductPaginatedDataCopyWith(_OwnerProductPaginatedData value, $Res Function(_OwnerProductPaginatedData) _then) = __$OwnerProductPaginatedDataCopyWithImpl;
@override @useResult
$Res call({
 List<OwnerProduct> items, OwnerProductPaginationInfo pagination
});


@override $OwnerProductPaginationInfoCopyWith<$Res> get pagination;

}
/// @nodoc
class __$OwnerProductPaginatedDataCopyWithImpl<$Res>
    implements _$OwnerProductPaginatedDataCopyWith<$Res> {
  __$OwnerProductPaginatedDataCopyWithImpl(this._self, this._then);

  final _OwnerProductPaginatedData _self;
  final $Res Function(_OwnerProductPaginatedData) _then;

/// Create a copy of OwnerProductPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_OwnerProductPaginatedData(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<OwnerProduct>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as OwnerProductPaginationInfo,
  ));
}

/// Create a copy of OwnerProductPaginatedData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OwnerProductPaginationInfoCopyWith<$Res> get pagination {
  
  return $OwnerProductPaginationInfoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// @nodoc
mixin _$OwnerProductPaginationInfo {

 int get page; int get limit; int get total; int get totalPages;
/// Create a copy of OwnerProductPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OwnerProductPaginationInfoCopyWith<OwnerProductPaginationInfo> get copyWith => _$OwnerProductPaginationInfoCopyWithImpl<OwnerProductPaginationInfo>(this as OwnerProductPaginationInfo, _$identity);

  /// Serializes this OwnerProductPaginationInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OwnerProductPaginationInfo&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,totalPages);

@override
String toString() {
  return 'OwnerProductPaginationInfo(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class $OwnerProductPaginationInfoCopyWith<$Res>  {
  factory $OwnerProductPaginationInfoCopyWith(OwnerProductPaginationInfo value, $Res Function(OwnerProductPaginationInfo) _then) = _$OwnerProductPaginationInfoCopyWithImpl;
@useResult
$Res call({
 int page, int limit, int total, int totalPages
});




}
/// @nodoc
class _$OwnerProductPaginationInfoCopyWithImpl<$Res>
    implements $OwnerProductPaginationInfoCopyWith<$Res> {
  _$OwnerProductPaginationInfoCopyWithImpl(this._self, this._then);

  final OwnerProductPaginationInfo _self;
  final $Res Function(OwnerProductPaginationInfo) _then;

/// Create a copy of OwnerProductPaginationInfo
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


/// Adds pattern-matching-related methods to [OwnerProductPaginationInfo].
extension OwnerProductPaginationInfoPatterns on OwnerProductPaginationInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OwnerProductPaginationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OwnerProductPaginationInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OwnerProductPaginationInfo value)  $default,){
final _that = this;
switch (_that) {
case _OwnerProductPaginationInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OwnerProductPaginationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _OwnerProductPaginationInfo() when $default != null:
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
case _OwnerProductPaginationInfo() when $default != null:
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
case _OwnerProductPaginationInfo():
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
case _OwnerProductPaginationInfo() when $default != null:
return $default(_that.page,_that.limit,_that.total,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OwnerProductPaginationInfo implements OwnerProductPaginationInfo {
  const _OwnerProductPaginationInfo({required this.page, required this.limit, required this.total, required this.totalPages});
  factory _OwnerProductPaginationInfo.fromJson(Map<String, dynamic> json) => _$OwnerProductPaginationInfoFromJson(json);

@override final  int page;
@override final  int limit;
@override final  int total;
@override final  int totalPages;

/// Create a copy of OwnerProductPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OwnerProductPaginationInfoCopyWith<_OwnerProductPaginationInfo> get copyWith => __$OwnerProductPaginationInfoCopyWithImpl<_OwnerProductPaginationInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OwnerProductPaginationInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OwnerProductPaginationInfo&&(identical(other.page, page) || other.page == page)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.total, total) || other.total == total)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,page,limit,total,totalPages);

@override
String toString() {
  return 'OwnerProductPaginationInfo(page: $page, limit: $limit, total: $total, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$OwnerProductPaginationInfoCopyWith<$Res> implements $OwnerProductPaginationInfoCopyWith<$Res> {
  factory _$OwnerProductPaginationInfoCopyWith(_OwnerProductPaginationInfo value, $Res Function(_OwnerProductPaginationInfo) _then) = __$OwnerProductPaginationInfoCopyWithImpl;
@override @useResult
$Res call({
 int page, int limit, int total, int totalPages
});




}
/// @nodoc
class __$OwnerProductPaginationInfoCopyWithImpl<$Res>
    implements _$OwnerProductPaginationInfoCopyWith<$Res> {
  __$OwnerProductPaginationInfoCopyWithImpl(this._self, this._then);

  final _OwnerProductPaginationInfo _self;
  final $Res Function(_OwnerProductPaginationInfo) _then;

/// Create a copy of OwnerProductPaginationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? limit = null,Object? total = null,Object? totalPages = null,}) {
  return _then(_OwnerProductPaginationInfo(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
