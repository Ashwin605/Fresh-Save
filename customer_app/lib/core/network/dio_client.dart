import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_interceptor.dart';
import '../storage/token_storage.dart';
import 'app_error.dart';
import 'network_status_provider.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Ref ref;
  final int maxRetries;

  RetryInterceptor({required this.dio, required this.ref, this.maxRetries = 3});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // If a request succeeds, we are online
    ref.read(networkStatusProvider.notifier).markOnline();
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isNetworkIssue = _isNetworkIssue(err);
    if (isNetworkIssue) {
      ref.read(networkStatusProvider.notifier).markOffline();
    } else {
      // If we got a real backend error (like 400, 401, etc.), we are online
      ref.read(networkStatusProvider.notifier).markOnline();
    }

    final extra = err.requestOptions.extra;
    final retryCount = extra['retryCount'] ?? 0;

    final isIdempotent =
        err.requestOptions.method == 'GET' ||
        err.requestOptions.method == 'PUT' ||
        err.requestOptions.method == 'DELETE';

    final isRetryableError = _isRetryableError(err);

    if (isIdempotent && isRetryableError && retryCount < maxRetries) {
      final delay = Duration(
        milliseconds: 500 * (1 << retryCount),
      ); // Exponential backoff: 500ms, 1s, 2s
      await Future.delayed(delay);

      final opts = err.requestOptions;
      opts.extra = {...opts.extra, 'retryCount': retryCount + 1};

      try {
        final retryResponse = await dio.fetch(opts);
        return handler.resolve(retryResponse);
      } catch (e) {
        if (e is DioException) {
          return onError(e, handler); // Recurse to check again
        }
      }
    }

    return super.onError(err, handler);
  }

  bool _isNetworkIssue(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }

  bool _isRetryableError(DioException err) {
    if (_isNetworkIssue(err)) {
      return true;
    }
    final statusCode = err.response?.statusCode;
    if (statusCode == 500 ||
        statusCode == 502 ||
        statusCode == 503 ||
        statusCode == 504 ||
        statusCode == 429) {
      return true;
    }
    return false;
  }
}

/// Interceptor that unwraps the backend's TransformInterceptor envelope.
/// The backend wraps all responses as { statusCode, message, data, timestamp }.
/// This interceptor strips the envelope so `response.data` contains the actual payload.
class UnwrapInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final raw = response.data;
    if (raw is Map<String, dynamic> && raw.containsKey('data')) {
      response.data = raw['data'];
    }
    super.onResponse(response, handler);
  }
}

final dioProvider = Provider<Dio>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: const bool.hasEnvironment('API_URL') 
          ? const String.fromEnvironment('API_URL') 
          : 'https://fresh-save-api.onrender.com/api/v1',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  dio.interceptors.add(AuthInterceptor(tokenStorage, dio));
  dio.interceptors.add(RetryInterceptor(dio: dio, ref: ref));
  dio.interceptors.add(UnwrapInterceptor());

  return dio;
});

class ApiErrorHandler {
  /// Extract the human-readable message from the backend error response.
  static String? _extractMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String) return msg;
      if (msg is List && msg.isNotEmpty) return msg.first.toString();
    }
    return null;
  }

  static AppError handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const AppError.timeout(message: 'Connection timed out');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final serverMessage = _extractMessage(error);
          if (statusCode == 401) return AppError.unauthorized(message: serverMessage);
          if (statusCode == 403) return AppError.forbidden(message: serverMessage);
          if (statusCode == 404) return AppError.notFound(message: serverMessage);
          if (statusCode == 409) {
            return AppError.conflict(
              message: serverMessage ?? 'This information conflicts with existing data.',
            );
          }
          if (statusCode == 422) {
            return AppError.validation(message: serverMessage ?? 'Validation failed');
          }
          if (statusCode == 429) {
            return const AppError.rateLimited(
              message: 'Too many requests. Please try again shortly.',
            );
          }
          if (statusCode == 503) return const AppError.serviceUnavailable();
          return AppError.server(message: serverMessage ?? 'Server error: $statusCode');
        default:
          return const AppError.network(message: 'Network error occurred');
      }
    }
    return AppError.unknown(message: error.toString());
  }
}
