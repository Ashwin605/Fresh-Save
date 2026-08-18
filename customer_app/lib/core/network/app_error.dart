import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

@freezed
sealed class AppError with _$AppError {
  const AppError._();

  const factory AppError.network({String? message}) = NetworkError;
  const factory AppError.timeout({String? message}) = TimeoutError;
  const factory AppError.unauthorized({String? message}) = UnauthorizedError;
  const factory AppError.forbidden({String? message}) = ForbiddenError;
  const factory AppError.notFound({String? message}) = NotFoundError;
  const factory AppError.conflict({String? message}) = ConflictError;
  const factory AppError.validation({
    String? message,
    Map<String, dynamic>? errors,
  }) = ValidationError;
  const factory AppError.rateLimited({String? message}) = RateLimitedError;
  const factory AppError.server({String? message}) = ServerError;
  const factory AppError.serviceUnavailable({String? message}) =
      ServiceUnavailableError;
  const factory AppError.unknown({String? message}) = UnknownError;
}
