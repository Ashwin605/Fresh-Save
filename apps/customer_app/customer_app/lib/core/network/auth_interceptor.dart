import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthInterceptor extends Interceptor {
  final Dio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final token = await user.getIdToken(false);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      } catch (e) {
        // If getting token fails, we just continue without auth header
        // and let the backend return 401.
      }
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // If the backend returns 401, we could force refresh the token here.
    // However, Firebase SDK automatically refreshes tokens under the hood
    // when they expire (within 5 minutes of expiration).
    // If we specifically get a 401, we can try to force a refresh once:
    if (err.response?.statusCode == 401) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          // Force refresh
          final newToken = await user.getIdToken(true);
          if (newToken != null) {
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newToken';
            final retryResponse = await dio.fetch(opts);
            return handler.resolve(retryResponse);
          }
        } catch (_) {
          // Fall through
        }
      }
    }
    return super.onError(err, handler);
  }
}
