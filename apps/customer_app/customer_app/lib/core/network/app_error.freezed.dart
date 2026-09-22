// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppError {

 String? get message;
/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppErrorCopyWith<AppError> get copyWith => _$AppErrorCopyWithImpl<AppError>(this as AppError, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError(message: $message)';
}


}

/// @nodoc
abstract mixin class $AppErrorCopyWith<$Res>  {
  factory $AppErrorCopyWith(AppError value, $Res Function(AppError) _then) = _$AppErrorCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$AppErrorCopyWithImpl<$Res>
    implements $AppErrorCopyWith<$Res> {
  _$AppErrorCopyWithImpl(this._self, this._then);

  final AppError _self;
  final $Res Function(AppError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? message = freezed,}) {
  return _then(_self.copyWith(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AppError].
extension AppErrorPatterns on AppError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkError value)?  network,TResult Function( TimeoutError value)?  timeout,TResult Function( UnauthorizedError value)?  unauthorized,TResult Function( ForbiddenError value)?  forbidden,TResult Function( NotFoundError value)?  notFound,TResult Function( ConflictError value)?  conflict,TResult Function( ValidationError value)?  validation,TResult Function( RateLimitedError value)?  rateLimited,TResult Function( ServerError value)?  server,TResult Function( ServiceUnavailableError value)?  serviceUnavailable,TResult Function( UnknownError value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that);case TimeoutError() when timeout != null:
return timeout(_that);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that);case ForbiddenError() when forbidden != null:
return forbidden(_that);case NotFoundError() when notFound != null:
return notFound(_that);case ConflictError() when conflict != null:
return conflict(_that);case ValidationError() when validation != null:
return validation(_that);case RateLimitedError() when rateLimited != null:
return rateLimited(_that);case ServerError() when server != null:
return server(_that);case ServiceUnavailableError() when serviceUnavailable != null:
return serviceUnavailable(_that);case UnknownError() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkError value)  network,required TResult Function( TimeoutError value)  timeout,required TResult Function( UnauthorizedError value)  unauthorized,required TResult Function( ForbiddenError value)  forbidden,required TResult Function( NotFoundError value)  notFound,required TResult Function( ConflictError value)  conflict,required TResult Function( ValidationError value)  validation,required TResult Function( RateLimitedError value)  rateLimited,required TResult Function( ServerError value)  server,required TResult Function( ServiceUnavailableError value)  serviceUnavailable,required TResult Function( UnknownError value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkError():
return network(_that);case TimeoutError():
return timeout(_that);case UnauthorizedError():
return unauthorized(_that);case ForbiddenError():
return forbidden(_that);case NotFoundError():
return notFound(_that);case ConflictError():
return conflict(_that);case ValidationError():
return validation(_that);case RateLimitedError():
return rateLimited(_that);case ServerError():
return server(_that);case ServiceUnavailableError():
return serviceUnavailable(_that);case UnknownError():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkError value)?  network,TResult? Function( TimeoutError value)?  timeout,TResult? Function( UnauthorizedError value)?  unauthorized,TResult? Function( ForbiddenError value)?  forbidden,TResult? Function( NotFoundError value)?  notFound,TResult? Function( ConflictError value)?  conflict,TResult? Function( ValidationError value)?  validation,TResult? Function( RateLimitedError value)?  rateLimited,TResult? Function( ServerError value)?  server,TResult? Function( ServiceUnavailableError value)?  serviceUnavailable,TResult? Function( UnknownError value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that);case TimeoutError() when timeout != null:
return timeout(_that);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that);case ForbiddenError() when forbidden != null:
return forbidden(_that);case NotFoundError() when notFound != null:
return notFound(_that);case ConflictError() when conflict != null:
return conflict(_that);case ValidationError() when validation != null:
return validation(_that);case RateLimitedError() when rateLimited != null:
return rateLimited(_that);case ServerError() when server != null:
return server(_that);case ServiceUnavailableError() when serviceUnavailable != null:
return serviceUnavailable(_that);case UnknownError() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? message)?  network,TResult Function( String? message)?  timeout,TResult Function( String? message)?  unauthorized,TResult Function( String? message)?  forbidden,TResult Function( String? message)?  notFound,TResult Function( String? message)?  conflict,TResult Function( String? message,  Map<String, dynamic>? errors)?  validation,TResult Function( String? message)?  rateLimited,TResult Function( String? message)?  server,TResult Function( String? message)?  serviceUnavailable,TResult Function( String? message)?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that.message);case TimeoutError() when timeout != null:
return timeout(_that.message);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that.message);case ForbiddenError() when forbidden != null:
return forbidden(_that.message);case NotFoundError() when notFound != null:
return notFound(_that.message);case ConflictError() when conflict != null:
return conflict(_that.message);case ValidationError() when validation != null:
return validation(_that.message,_that.errors);case RateLimitedError() when rateLimited != null:
return rateLimited(_that.message);case ServerError() when server != null:
return server(_that.message);case ServiceUnavailableError() when serviceUnavailable != null:
return serviceUnavailable(_that.message);case UnknownError() when unknown != null:
return unknown(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? message)  network,required TResult Function( String? message)  timeout,required TResult Function( String? message)  unauthorized,required TResult Function( String? message)  forbidden,required TResult Function( String? message)  notFound,required TResult Function( String? message)  conflict,required TResult Function( String? message,  Map<String, dynamic>? errors)  validation,required TResult Function( String? message)  rateLimited,required TResult Function( String? message)  server,required TResult Function( String? message)  serviceUnavailable,required TResult Function( String? message)  unknown,}) {final _that = this;
switch (_that) {
case NetworkError():
return network(_that.message);case TimeoutError():
return timeout(_that.message);case UnauthorizedError():
return unauthorized(_that.message);case ForbiddenError():
return forbidden(_that.message);case NotFoundError():
return notFound(_that.message);case ConflictError():
return conflict(_that.message);case ValidationError():
return validation(_that.message,_that.errors);case RateLimitedError():
return rateLimited(_that.message);case ServerError():
return server(_that.message);case ServiceUnavailableError():
return serviceUnavailable(_that.message);case UnknownError():
return unknown(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? message)?  network,TResult? Function( String? message)?  timeout,TResult? Function( String? message)?  unauthorized,TResult? Function( String? message)?  forbidden,TResult? Function( String? message)?  notFound,TResult? Function( String? message)?  conflict,TResult? Function( String? message,  Map<String, dynamic>? errors)?  validation,TResult? Function( String? message)?  rateLimited,TResult? Function( String? message)?  server,TResult? Function( String? message)?  serviceUnavailable,TResult? Function( String? message)?  unknown,}) {final _that = this;
switch (_that) {
case NetworkError() when network != null:
return network(_that.message);case TimeoutError() when timeout != null:
return timeout(_that.message);case UnauthorizedError() when unauthorized != null:
return unauthorized(_that.message);case ForbiddenError() when forbidden != null:
return forbidden(_that.message);case NotFoundError() when notFound != null:
return notFound(_that.message);case ConflictError() when conflict != null:
return conflict(_that.message);case ValidationError() when validation != null:
return validation(_that.message,_that.errors);case RateLimitedError() when rateLimited != null:
return rateLimited(_that.message);case ServerError() when server != null:
return server(_that.message);case ServiceUnavailableError() when serviceUnavailable != null:
return serviceUnavailable(_that.message);case UnknownError() when unknown != null:
return unknown(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class NetworkError extends AppError {
  const NetworkError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkErrorCopyWith<NetworkError> get copyWith => _$NetworkErrorCopyWithImpl<NetworkError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.network(message: $message)';
}


}

/// @nodoc
abstract mixin class $NetworkErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $NetworkErrorCopyWith(NetworkError value, $Res Function(NetworkError) _then) = _$NetworkErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$NetworkErrorCopyWithImpl<$Res>
    implements $NetworkErrorCopyWith<$Res> {
  _$NetworkErrorCopyWithImpl(this._self, this._then);

  final NetworkError _self;
  final $Res Function(NetworkError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(NetworkError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TimeoutError extends AppError {
  const TimeoutError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeoutErrorCopyWith<TimeoutError> get copyWith => _$TimeoutErrorCopyWithImpl<TimeoutError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.timeout(message: $message)';
}


}

/// @nodoc
abstract mixin class $TimeoutErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $TimeoutErrorCopyWith(TimeoutError value, $Res Function(TimeoutError) _then) = _$TimeoutErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$TimeoutErrorCopyWithImpl<$Res>
    implements $TimeoutErrorCopyWith<$Res> {
  _$TimeoutErrorCopyWithImpl(this._self, this._then);

  final TimeoutError _self;
  final $Res Function(TimeoutError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(TimeoutError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnauthorizedError extends AppError {
  const UnauthorizedError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedErrorCopyWith<UnauthorizedError> get copyWith => _$UnauthorizedErrorCopyWithImpl<UnauthorizedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.unauthorized(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $UnauthorizedErrorCopyWith(UnauthorizedError value, $Res Function(UnauthorizedError) _then) = _$UnauthorizedErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnauthorizedErrorCopyWithImpl<$Res>
    implements $UnauthorizedErrorCopyWith<$Res> {
  _$UnauthorizedErrorCopyWithImpl(this._self, this._then);

  final UnauthorizedError _self;
  final $Res Function(UnauthorizedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(UnauthorizedError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ForbiddenError extends AppError {
  const ForbiddenError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForbiddenErrorCopyWith<ForbiddenError> get copyWith => _$ForbiddenErrorCopyWithImpl<ForbiddenError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForbiddenError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.forbidden(message: $message)';
}


}

/// @nodoc
abstract mixin class $ForbiddenErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ForbiddenErrorCopyWith(ForbiddenError value, $Res Function(ForbiddenError) _then) = _$ForbiddenErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ForbiddenErrorCopyWithImpl<$Res>
    implements $ForbiddenErrorCopyWith<$Res> {
  _$ForbiddenErrorCopyWithImpl(this._self, this._then);

  final ForbiddenError _self;
  final $Res Function(ForbiddenError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ForbiddenError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class NotFoundError extends AppError {
  const NotFoundError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundErrorCopyWith<NotFoundError> get copyWith => _$NotFoundErrorCopyWithImpl<NotFoundError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.notFound(message: $message)';
}


}

/// @nodoc
abstract mixin class $NotFoundErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $NotFoundErrorCopyWith(NotFoundError value, $Res Function(NotFoundError) _then) = _$NotFoundErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$NotFoundErrorCopyWithImpl<$Res>
    implements $NotFoundErrorCopyWith<$Res> {
  _$NotFoundErrorCopyWithImpl(this._self, this._then);

  final NotFoundError _self;
  final $Res Function(NotFoundError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(NotFoundError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ConflictError extends AppError {
  const ConflictError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictErrorCopyWith<ConflictError> get copyWith => _$ConflictErrorCopyWithImpl<ConflictError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.conflict(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConflictErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ConflictErrorCopyWith(ConflictError value, $Res Function(ConflictError) _then) = _$ConflictErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ConflictErrorCopyWithImpl<$Res>
    implements $ConflictErrorCopyWith<$Res> {
  _$ConflictErrorCopyWithImpl(this._self, this._then);

  final ConflictError _self;
  final $Res Function(ConflictError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ConflictError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ValidationError extends AppError {
  const ValidationError({this.message, final  Map<String, dynamic>? errors}): _errors = errors,super._();
  

@override final  String? message;
 final  Map<String, dynamic>? _errors;
 Map<String, dynamic>? get errors {
  final value = _errors;
  if (value == null) return null;
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationErrorCopyWith<ValidationError> get copyWith => _$ValidationErrorCopyWithImpl<ValidationError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other._errors, _errors));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(_errors));

@override
String toString() {
  return 'AppError.validation(message: $message, errors: $errors)';
}


}

/// @nodoc
abstract mixin class $ValidationErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ValidationErrorCopyWith(ValidationError value, $Res Function(ValidationError) _then) = _$ValidationErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message, Map<String, dynamic>? errors
});




}
/// @nodoc
class _$ValidationErrorCopyWithImpl<$Res>
    implements $ValidationErrorCopyWith<$Res> {
  _$ValidationErrorCopyWithImpl(this._self, this._then);

  final ValidationError _self;
  final $Res Function(ValidationError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,Object? errors = freezed,}) {
  return _then(ValidationError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,errors: freezed == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

/// @nodoc


class RateLimitedError extends AppError {
  const RateLimitedError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RateLimitedErrorCopyWith<RateLimitedError> get copyWith => _$RateLimitedErrorCopyWithImpl<RateLimitedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RateLimitedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.rateLimited(message: $message)';
}


}

/// @nodoc
abstract mixin class $RateLimitedErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $RateLimitedErrorCopyWith(RateLimitedError value, $Res Function(RateLimitedError) _then) = _$RateLimitedErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$RateLimitedErrorCopyWithImpl<$Res>
    implements $RateLimitedErrorCopyWith<$Res> {
  _$RateLimitedErrorCopyWithImpl(this._self, this._then);

  final RateLimitedError _self;
  final $Res Function(RateLimitedError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(RateLimitedError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServerError extends AppError {
  const ServerError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerErrorCopyWith<ServerError> get copyWith => _$ServerErrorCopyWithImpl<ServerError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.server(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServerErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ServerErrorCopyWith(ServerError value, $Res Function(ServerError) _then) = _$ServerErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ServerErrorCopyWithImpl<$Res>
    implements $ServerErrorCopyWith<$Res> {
  _$ServerErrorCopyWithImpl(this._self, this._then);

  final ServerError _self;
  final $Res Function(ServerError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ServerError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ServiceUnavailableError extends AppError {
  const ServiceUnavailableError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceUnavailableErrorCopyWith<ServiceUnavailableError> get copyWith => _$ServiceUnavailableErrorCopyWithImpl<ServiceUnavailableError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUnavailableError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.serviceUnavailable(message: $message)';
}


}

/// @nodoc
abstract mixin class $ServiceUnavailableErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $ServiceUnavailableErrorCopyWith(ServiceUnavailableError value, $Res Function(ServiceUnavailableError) _then) = _$ServiceUnavailableErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$ServiceUnavailableErrorCopyWithImpl<$Res>
    implements $ServiceUnavailableErrorCopyWith<$Res> {
  _$ServiceUnavailableErrorCopyWithImpl(this._self, this._then);

  final ServiceUnavailableError _self;
  final $Res Function(ServiceUnavailableError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(ServiceUnavailableError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UnknownError extends AppError {
  const UnknownError({this.message}): super._();
  

@override final  String? message;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnknownErrorCopyWith<UnknownError> get copyWith => _$UnknownErrorCopyWithImpl<UnknownError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AppError.unknown(message: $message)';
}


}

/// @nodoc
abstract mixin class $UnknownErrorCopyWith<$Res> implements $AppErrorCopyWith<$Res> {
  factory $UnknownErrorCopyWith(UnknownError value, $Res Function(UnknownError) _then) = _$UnknownErrorCopyWithImpl;
@override @useResult
$Res call({
 String? message
});




}
/// @nodoc
class _$UnknownErrorCopyWithImpl<$Res>
    implements $UnknownErrorCopyWith<$Res> {
  _$UnknownErrorCopyWithImpl(this._self, this._then);

  final UnknownError _self;
  final $Res Function(UnknownError) _then;

/// Create a copy of AppError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(UnknownError(
message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
