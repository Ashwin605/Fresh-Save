// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_details_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreProfileState {

 DealStore? get storeMetadata; DealDistance? get storeDistance; List<Deal> get offers; int get currentPage; bool get hasMore; StoreDetailsStatus get status; String? get errorMessage;
/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreProfileStateCopyWith<StoreProfileState> get copyWith => _$StoreProfileStateCopyWithImpl<StoreProfileState>(this as StoreProfileState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreProfileState&&(identical(other.storeMetadata, storeMetadata) || other.storeMetadata == storeMetadata)&&(identical(other.storeDistance, storeDistance) || other.storeDistance == storeDistance)&&const DeepCollectionEquality().equals(other.offers, offers)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,storeMetadata,storeDistance,const DeepCollectionEquality().hash(offers),currentPage,hasMore,status,errorMessage);

@override
String toString() {
  return 'StoreProfileState(storeMetadata: $storeMetadata, storeDistance: $storeDistance, offers: $offers, currentPage: $currentPage, hasMore: $hasMore, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $StoreProfileStateCopyWith<$Res>  {
  factory $StoreProfileStateCopyWith(StoreProfileState value, $Res Function(StoreProfileState) _then) = _$StoreProfileStateCopyWithImpl;
@useResult
$Res call({
 DealStore? storeMetadata, DealDistance? storeDistance, List<Deal> offers, int currentPage, bool hasMore, StoreDetailsStatus status, String? errorMessage
});


$DealStoreCopyWith<$Res>? get storeMetadata;$DealDistanceCopyWith<$Res>? get storeDistance;

}
/// @nodoc
class _$StoreProfileStateCopyWithImpl<$Res>
    implements $StoreProfileStateCopyWith<$Res> {
  _$StoreProfileStateCopyWithImpl(this._self, this._then);

  final StoreProfileState _self;
  final $Res Function(StoreProfileState) _then;

/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeMetadata = freezed,Object? storeDistance = freezed,Object? offers = null,Object? currentPage = null,Object? hasMore = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
storeMetadata: freezed == storeMetadata ? _self.storeMetadata : storeMetadata // ignore: cast_nullable_to_non_nullable
as DealStore?,storeDistance: freezed == storeDistance ? _self.storeDistance : storeDistance // ignore: cast_nullable_to_non_nullable
as DealDistance?,offers: null == offers ? _self.offers : offers // ignore: cast_nullable_to_non_nullable
as List<Deal>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StoreDetailsStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealStoreCopyWith<$Res>? get storeMetadata {
    if (_self.storeMetadata == null) {
    return null;
  }

  return $DealStoreCopyWith<$Res>(_self.storeMetadata!, (value) {
    return _then(_self.copyWith(storeMetadata: value));
  });
}/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealDistanceCopyWith<$Res>? get storeDistance {
    if (_self.storeDistance == null) {
    return null;
  }

  return $DealDistanceCopyWith<$Res>(_self.storeDistance!, (value) {
    return _then(_self.copyWith(storeDistance: value));
  });
}
}


/// Adds pattern-matching-related methods to [StoreProfileState].
extension StoreProfileStatePatterns on StoreProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreProfileState value)  $default,){
final _that = this;
switch (_that) {
case _StoreProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _StoreProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DealStore? storeMetadata,  DealDistance? storeDistance,  List<Deal> offers,  int currentPage,  bool hasMore,  StoreDetailsStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreProfileState() when $default != null:
return $default(_that.storeMetadata,_that.storeDistance,_that.offers,_that.currentPage,_that.hasMore,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DealStore? storeMetadata,  DealDistance? storeDistance,  List<Deal> offers,  int currentPage,  bool hasMore,  StoreDetailsStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _StoreProfileState():
return $default(_that.storeMetadata,_that.storeDistance,_that.offers,_that.currentPage,_that.hasMore,_that.status,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DealStore? storeMetadata,  DealDistance? storeDistance,  List<Deal> offers,  int currentPage,  bool hasMore,  StoreDetailsStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _StoreProfileState() when $default != null:
return $default(_that.storeMetadata,_that.storeDistance,_that.offers,_that.currentPage,_that.hasMore,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _StoreProfileState implements StoreProfileState {
  const _StoreProfileState({this.storeMetadata, this.storeDistance, final  List<Deal> offers = const [], this.currentPage = 1, this.hasMore = true, this.status = StoreDetailsStatus.initial, this.errorMessage}): _offers = offers;
  

@override final  DealStore? storeMetadata;
@override final  DealDistance? storeDistance;
 final  List<Deal> _offers;
@override@JsonKey() List<Deal> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  StoreDetailsStatus status;
@override final  String? errorMessage;

/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreProfileStateCopyWith<_StoreProfileState> get copyWith => __$StoreProfileStateCopyWithImpl<_StoreProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreProfileState&&(identical(other.storeMetadata, storeMetadata) || other.storeMetadata == storeMetadata)&&(identical(other.storeDistance, storeDistance) || other.storeDistance == storeDistance)&&const DeepCollectionEquality().equals(other._offers, _offers)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,storeMetadata,storeDistance,const DeepCollectionEquality().hash(_offers),currentPage,hasMore,status,errorMessage);

@override
String toString() {
  return 'StoreProfileState(storeMetadata: $storeMetadata, storeDistance: $storeDistance, offers: $offers, currentPage: $currentPage, hasMore: $hasMore, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$StoreProfileStateCopyWith<$Res> implements $StoreProfileStateCopyWith<$Res> {
  factory _$StoreProfileStateCopyWith(_StoreProfileState value, $Res Function(_StoreProfileState) _then) = __$StoreProfileStateCopyWithImpl;
@override @useResult
$Res call({
 DealStore? storeMetadata, DealDistance? storeDistance, List<Deal> offers, int currentPage, bool hasMore, StoreDetailsStatus status, String? errorMessage
});


@override $DealStoreCopyWith<$Res>? get storeMetadata;@override $DealDistanceCopyWith<$Res>? get storeDistance;

}
/// @nodoc
class __$StoreProfileStateCopyWithImpl<$Res>
    implements _$StoreProfileStateCopyWith<$Res> {
  __$StoreProfileStateCopyWithImpl(this._self, this._then);

  final _StoreProfileState _self;
  final $Res Function(_StoreProfileState) _then;

/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeMetadata = freezed,Object? storeDistance = freezed,Object? offers = null,Object? currentPage = null,Object? hasMore = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_StoreProfileState(
storeMetadata: freezed == storeMetadata ? _self.storeMetadata : storeMetadata // ignore: cast_nullable_to_non_nullable
as DealStore?,storeDistance: freezed == storeDistance ? _self.storeDistance : storeDistance // ignore: cast_nullable_to_non_nullable
as DealDistance?,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<Deal>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as StoreDetailsStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealStoreCopyWith<$Res>? get storeMetadata {
    if (_self.storeMetadata == null) {
    return null;
  }

  return $DealStoreCopyWith<$Res>(_self.storeMetadata!, (value) {
    return _then(_self.copyWith(storeMetadata: value));
  });
}/// Create a copy of StoreProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DealDistanceCopyWith<$Res>? get storeDistance {
    if (_self.storeDistance == null) {
    return null;
  }

  return $DealDistanceCopyWith<$Res>(_self.storeDistance!, (value) {
    return _then(_self.copyWith(storeDistance: value));
  });
}
}

// dart format on
