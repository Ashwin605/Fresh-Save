// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {

 String get query; List<String> get recentSearches; List<Deal> get deals; List<Store> get stores; List<Product> get products; SearchStatus get status; DiscoveryFilters get filters; DiscoverySort get sort; String? get errorMessage;
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateCopyWith<SearchState> get copyWith => _$SearchStateCopyWithImpl<SearchState>(this as SearchState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other.recentSearches, recentSearches)&&const DeepCollectionEquality().equals(other.deals, deals)&&const DeepCollectionEquality().equals(other.stores, stores)&&const DeepCollectionEquality().equals(other.products, products)&&(identical(other.status, status) || other.status == status)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(recentSearches),const DeepCollectionEquality().hash(deals),const DeepCollectionEquality().hash(stores),const DeepCollectionEquality().hash(products),status,filters,sort,errorMessage);

@override
String toString() {
  return 'SearchState(query: $query, recentSearches: $recentSearches, deals: $deals, stores: $stores, products: $products, status: $status, filters: $filters, sort: $sort, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SearchStateCopyWith<$Res>  {
  factory $SearchStateCopyWith(SearchState value, $Res Function(SearchState) _then) = _$SearchStateCopyWithImpl;
@useResult
$Res call({
 String query, List<String> recentSearches, List<Deal> deals, List<Store> stores, List<Product> products, SearchStatus status, DiscoveryFilters filters, DiscoverySort sort, String? errorMessage
});


$DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class _$SearchStateCopyWithImpl<$Res>
    implements $SearchStateCopyWith<$Res> {
  _$SearchStateCopyWithImpl(this._self, this._then);

  final SearchState _self;
  final $Res Function(SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? recentSearches = null,Object? deals = null,Object? stores = null,Object? products = null,Object? status = null,Object? filters = null,Object? sort = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,recentSearches: null == recentSearches ? _self.recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,deals: null == deals ? _self.deals : deals // ignore: cast_nullable_to_non_nullable
as List<Deal>,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,products: null == products ? _self.products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as DiscoverySort,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DiscoveryFiltersCopyWith<$Res> get filters {
  
  return $DiscoveryFiltersCopyWith<$Res>(_self.filters, (value) {
    return _then(_self.copyWith(filters: value));
  });
}
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchState value)  $default,){
final _that = this;
switch (_that) {
case _SearchState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchState value)?  $default,){
final _that = this;
switch (_that) {
case _SearchState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  List<String> recentSearches,  List<Deal> deals,  List<Store> stores,  List<Product> products,  SearchStatus status,  DiscoveryFilters filters,  DiscoverySort sort,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.query,_that.recentSearches,_that.deals,_that.stores,_that.products,_that.status,_that.filters,_that.sort,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  List<String> recentSearches,  List<Deal> deals,  List<Store> stores,  List<Product> products,  SearchStatus status,  DiscoveryFilters filters,  DiscoverySort sort,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SearchState():
return $default(_that.query,_that.recentSearches,_that.deals,_that.stores,_that.products,_that.status,_that.filters,_that.sort,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  List<String> recentSearches,  List<Deal> deals,  List<Store> stores,  List<Product> products,  SearchStatus status,  DiscoveryFilters filters,  DiscoverySort sort,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SearchState() when $default != null:
return $default(_that.query,_that.recentSearches,_that.deals,_that.stores,_that.products,_that.status,_that.filters,_that.sort,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SearchState implements SearchState {
  const _SearchState({this.query = '', final  List<String> recentSearches = const [], final  List<Deal> deals = const [], final  List<Store> stores = const [], final  List<Product> products = const [], this.status = SearchStatus.initial, this.filters = const DiscoveryFilters(), this.sort = DiscoverySort.relevance, this.errorMessage}): _recentSearches = recentSearches,_deals = deals,_stores = stores,_products = products;
  

@override@JsonKey() final  String query;
 final  List<String> _recentSearches;
@override@JsonKey() List<String> get recentSearches {
  if (_recentSearches is EqualUnmodifiableListView) return _recentSearches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentSearches);
}

 final  List<Deal> _deals;
@override@JsonKey() List<Deal> get deals {
  if (_deals is EqualUnmodifiableListView) return _deals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deals);
}

 final  List<Store> _stores;
@override@JsonKey() List<Store> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}

 final  List<Product> _products;
@override@JsonKey() List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

@override@JsonKey() final  SearchStatus status;
@override@JsonKey() final  DiscoveryFilters filters;
@override@JsonKey() final  DiscoverySort sort;
@override final  String? errorMessage;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchStateCopyWith<_SearchState> get copyWith => __$SearchStateCopyWithImpl<_SearchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchState&&(identical(other.query, query) || other.query == query)&&const DeepCollectionEquality().equals(other._recentSearches, _recentSearches)&&const DeepCollectionEquality().equals(other._deals, _deals)&&const DeepCollectionEquality().equals(other._stores, _stores)&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.status, status) || other.status == status)&&(identical(other.filters, filters) || other.filters == filters)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,query,const DeepCollectionEquality().hash(_recentSearches),const DeepCollectionEquality().hash(_deals),const DeepCollectionEquality().hash(_stores),const DeepCollectionEquality().hash(_products),status,filters,sort,errorMessage);

@override
String toString() {
  return 'SearchState(query: $query, recentSearches: $recentSearches, deals: $deals, stores: $stores, products: $products, status: $status, filters: $filters, sort: $sort, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SearchStateCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory _$SearchStateCopyWith(_SearchState value, $Res Function(_SearchState) _then) = __$SearchStateCopyWithImpl;
@override @useResult
$Res call({
 String query, List<String> recentSearches, List<Deal> deals, List<Store> stores, List<Product> products, SearchStatus status, DiscoveryFilters filters, DiscoverySort sort, String? errorMessage
});


@override $DiscoveryFiltersCopyWith<$Res> get filters;

}
/// @nodoc
class __$SearchStateCopyWithImpl<$Res>
    implements _$SearchStateCopyWith<$Res> {
  __$SearchStateCopyWithImpl(this._self, this._then);

  final _SearchState _self;
  final $Res Function(_SearchState) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? recentSearches = null,Object? deals = null,Object? stores = null,Object? products = null,Object? status = null,Object? filters = null,Object? sort = null,Object? errorMessage = freezed,}) {
  return _then(_SearchState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,recentSearches: null == recentSearches ? _self._recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as List<String>,deals: null == deals ? _self._deals : deals // ignore: cast_nullable_to_non_nullable
as List<Deal>,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<Store>,products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SearchStatus,filters: null == filters ? _self.filters : filters // ignore: cast_nullable_to_non_nullable
as DiscoveryFilters,sort: null == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as DiscoverySort,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SearchState
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
