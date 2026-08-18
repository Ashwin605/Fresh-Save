// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discovery_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DiscoveryFilters {

 double? get radius; String? get categoryId; String? get categoryName;// For displaying the chip
 double? get minDiscount; int? get expiryWithinHours;
/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<DiscoveryFilters> get copyWith => _$DiscoveryFiltersCopyWithImpl<DiscoveryFilters>(this as DiscoveryFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryFilters&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.minDiscount, minDiscount) || other.minDiscount == minDiscount)&&(identical(other.expiryWithinHours, expiryWithinHours) || other.expiryWithinHours == expiryWithinHours));
}


@override
int get hashCode => Object.hash(runtimeType,radius,categoryId,categoryName,minDiscount,expiryWithinHours);

@override
String toString() {
  return 'DiscoveryFilters(radius: $radius, categoryId: $categoryId, categoryName: $categoryName, minDiscount: $minDiscount, expiryWithinHours: $expiryWithinHours)';
}


}

/// @nodoc
abstract mixin class $DiscoveryFiltersCopyWith<$Res>  {
  factory $DiscoveryFiltersCopyWith(DiscoveryFilters value, $Res Function(DiscoveryFilters) _then) = _$DiscoveryFiltersCopyWithImpl;
@useResult
$Res call({
 double? radius, String? categoryId, String? categoryName, double? minDiscount, int? expiryWithinHours
});




}
/// @nodoc
class _$DiscoveryFiltersCopyWithImpl<$Res>
    implements $DiscoveryFiltersCopyWith<$Res> {
  _$DiscoveryFiltersCopyWithImpl(this._self, this._then);

  final DiscoveryFilters _self;
  final $Res Function(DiscoveryFilters) _then;

/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? radius = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? minDiscount = freezed,Object? expiryWithinHours = freezed,}) {
  return _then(_self.copyWith(
radius: freezed == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,minDiscount: freezed == minDiscount ? _self.minDiscount : minDiscount // ignore: cast_nullable_to_non_nullable
as double?,expiryWithinHours: freezed == expiryWithinHours ? _self.expiryWithinHours : expiryWithinHours // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiscoveryFilters].
extension DiscoveryFiltersPatterns on DiscoveryFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryFilters value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryFilters value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? radius,  String? categoryId,  String? categoryName,  double? minDiscount,  int? expiryWithinHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
return $default(_that.radius,_that.categoryId,_that.categoryName,_that.minDiscount,_that.expiryWithinHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? radius,  String? categoryId,  String? categoryName,  double? minDiscount,  int? expiryWithinHours)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryFilters():
return $default(_that.radius,_that.categoryId,_that.categoryName,_that.minDiscount,_that.expiryWithinHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? radius,  String? categoryId,  String? categoryName,  double? minDiscount,  int? expiryWithinHours)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryFilters() when $default != null:
return $default(_that.radius,_that.categoryId,_that.categoryName,_that.minDiscount,_that.expiryWithinHours);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryFilters extends DiscoveryFilters {
  const _DiscoveryFilters({this.radius, this.categoryId, this.categoryName, this.minDiscount, this.expiryWithinHours}): super._();
  

@override final  double? radius;
@override final  String? categoryId;
@override final  String? categoryName;
// For displaying the chip
@override final  double? minDiscount;
@override final  int? expiryWithinHours;

/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryFiltersCopyWith<_DiscoveryFilters> get copyWith => __$DiscoveryFiltersCopyWithImpl<_DiscoveryFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryFilters&&(identical(other.radius, radius) || other.radius == radius)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.minDiscount, minDiscount) || other.minDiscount == minDiscount)&&(identical(other.expiryWithinHours, expiryWithinHours) || other.expiryWithinHours == expiryWithinHours));
}


@override
int get hashCode => Object.hash(runtimeType,radius,categoryId,categoryName,minDiscount,expiryWithinHours);

@override
String toString() {
  return 'DiscoveryFilters(radius: $radius, categoryId: $categoryId, categoryName: $categoryName, minDiscount: $minDiscount, expiryWithinHours: $expiryWithinHours)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryFiltersCopyWith<$Res> implements $DiscoveryFiltersCopyWith<$Res> {
  factory _$DiscoveryFiltersCopyWith(_DiscoveryFilters value, $Res Function(_DiscoveryFilters) _then) = __$DiscoveryFiltersCopyWithImpl;
@override @useResult
$Res call({
 double? radius, String? categoryId, String? categoryName, double? minDiscount, int? expiryWithinHours
});




}
/// @nodoc
class __$DiscoveryFiltersCopyWithImpl<$Res>
    implements _$DiscoveryFiltersCopyWith<$Res> {
  __$DiscoveryFiltersCopyWithImpl(this._self, this._then);

  final _DiscoveryFilters _self;
  final $Res Function(_DiscoveryFilters) _then;

/// Create a copy of DiscoveryFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? radius = freezed,Object? categoryId = freezed,Object? categoryName = freezed,Object? minDiscount = freezed,Object? expiryWithinHours = freezed,}) {
  return _then(_DiscoveryFilters(
radius: freezed == radius ? _self.radius : radius // ignore: cast_nullable_to_non_nullable
as double?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String?,categoryName: freezed == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String?,minDiscount: freezed == minDiscount ? _self.minDiscount : minDiscount // ignore: cast_nullable_to_non_nullable
as double?,expiryWithinHours: freezed == expiryWithinHours ? _self.expiryWithinHours : expiryWithinHours // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$DiscoveryState {

 List<Deal> get deals; int get currentPage; bool get hasMore; DiscoveryStatus get status; DiscoveryFilters get filters; DiscoverySort get sort; String? get errorMessage;
/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscoveryStateCopyWith<DiscoveryState> get copyWith => _$DiscoveryStateCopyWithImpl<DiscoveryState>(this as DiscoveryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscoveryState&&const DeepCollectionEquality().equals(other.deals, deals)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.status, status) || other.status == status)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(deals),currentPage,hasMore,status,filters,sort,errorMessage);

@override
String toString() {
  return 'DiscoveryState(deals: $deals, currentPage: $currentPage, hasMore: $hasMore, status: $status, filters: $filters, sort: $sort, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $DiscoveryStateCopyWith<$Res>  {
  factory $DiscoveryStateCopyWith(DiscoveryState value, $Res Function(DiscoveryState) _then) = _$DiscoveryStateCopyWithImpl;
@useResult
$Res call({
 List<Deal> deals, int currentPage, bool hasMore, DiscoveryStatus status, DiscoveryFilters filters, DiscoverySort sort, String? errorMessage
});


$DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$DiscoveryStateCopyWithImpl<$Res>
    implements $DiscoveryStateCopyWith<$Res> {
  _$DiscoveryStateCopyWithImpl(this._self, this._then);

  final DiscoveryState _self;
  final $Res Function(DiscoveryState) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deals = null,Object? currentPage = null,Object? hasMore = null,Object? status = null,Object? filters = null,Object? sort = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
deals: null == deals ? _self.deals : deals // ignore: cast_nullable_to_non_nullable
as List<Deal>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryStatus,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as DiscoverySort,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiscoveryState].
extension DiscoveryStatePatterns on DiscoveryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiscoveryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiscoveryState value)  $default,){
final _that = this;
switch (_that) {
case _DiscoveryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiscoveryState value)?  $default,){
final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Deal> deals,  int currentPage,  bool hasMore,  DiscoveryStatus status,  DiscoveryFilters filters,  DiscoverySort sort,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.deals,_that.currentPage,_that.hasMore,_that.status,_that.filters,_that.sort,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Deal> deals,  int currentPage,  bool hasMore,  DiscoveryStatus status,  DiscoveryFilters filters,  DiscoverySort sort,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState():
return $default(_that.deals,_that.currentPage,_that.hasMore,_that.status,_that.filters,_that.sort,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Deal> deals,  int currentPage,  bool hasMore,  DiscoveryStatus status,  DiscoveryFilters filters,  DiscoverySort sort,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _DiscoveryState() when $default != null:
return $default(_that.deals,_that.currentPage,_that.hasMore,_that.status,_that.filters,_that.sort,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _DiscoveryState implements DiscoveryState {
  const _DiscoveryState({final  List<Deal> deals = const [], this.currentPage = 1, this.hasMore = true, this.status = DiscoveryStatus.initial, this.filters = const DiscoveryFilters(), this.sort = DiscoverySort.relevance, this.errorMessage}): _deals = deals;
  

 final  List<Deal> _deals;
@override@JsonKey() List<Deal> get deals {
  if (_deals is EqualUnmodifiableListView) return _deals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deals);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  DiscoveryStatus status;
@override@JsonKey() final  DiscoveryFilters filters;
@override@JsonKey() final  DiscoverySort sort;
@override final  String? errorMessage;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscoveryStateCopyWith<_DiscoveryState> get copyWith => __$DiscoveryStateCopyWithImpl<_DiscoveryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscoveryState&&const DeepCollectionEquality().equals(other._deals, _deals)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.status, status) || other.status == status)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_deals),currentPage,hasMore,status,filters,sort,errorMessage);

@override
String toString() {
  return 'DiscoveryState(deals: $deals, currentPage: $currentPage, hasMore: $hasMore, status: $status, filters: $filters, sort: $sort, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$DiscoveryStateCopyWith<$Res> implements $DiscoveryStateCopyWith<$Res> {
  factory _$DiscoveryStateCopyWith(_DiscoveryState value, $Res Function(_DiscoveryState) _then) = __$DiscoveryStateCopyWithImpl;
@override @useResult
$Res call({
 List<Deal> deals, int currentPage, bool hasMore, DiscoveryStatus status, DiscoveryFilters filters, DiscoverySort sort, String? errorMessage
});


@override $DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$DiscoveryStateCopyWithImpl<$Res>
    implements _$DiscoveryStateCopyWith<$Res> {
  __$DiscoveryStateCopyWithImpl(this._self, this._then);

  final _DiscoveryState _self;
  final $Res Function(_DiscoveryState) _then;

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deals = null,Object? currentPage = null,Object? hasMore = null,Object? status = null,Object? filters = null,Object? sort = null,Object? errorMessage = freezed,}) {
  return _then(_DiscoveryState(
deals: null == deals ? _self._deals : deals // ignore: cast_nullable_to_non_nullable
as List<Deal>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DiscoveryStatus,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as DiscoverySort,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DiscoveryState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}

// dart format on
