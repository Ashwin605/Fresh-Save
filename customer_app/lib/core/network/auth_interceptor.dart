import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage tokenStorage;
  final Dio dio;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequestsQueue = [];

  AuthInterceptor(this.tokenStorage, this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      if (_isRefreshing) {
        _failedRequestsQueue.add({'err': err, 'handler': handler});
        return;
      }

      _isRefreshing = true;

      try {
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken != null) {
          final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));
          final response = await refreshDio.post(
            '/auth/refresh',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccess = response.data['data']['accessToken'];
            final newRefresh = response.data['data']['refreshToken'];
            await tokenStorage.saveTokens(
              accessToken: newAccess,
              refreshToken: newRefresh,
            );

            // Retry original request
            final opts = err.requestOptions;
            opts.headers['Authorization'] = 'Bearer $newAccess';
            final retryResponse = await dio.fetch(opts);
            handler.resolve(retryResponse);

            // Retry queued requests
            for (var req in _failedRequestsQueue) {
              final queuedOpts = (req['err'] as DioException).requestOptions;
              queuedOpts.headers['Authorization'] = 'Bearer $newAccess';
              final queuedRes = await dio.fetch(queuedOpts);
              (req['handler'] as ErrorInterceptorHandler).resolve(queuedRes);
            }
            _failedRequestsQueue.clear();
            _isRefreshing = false;
            return;
          }
        }
      } catch (_) {
        // Fall through to clear tokens
      }

      _isRefreshing = false;
      _failedRequestsQueue.clear();
      await tokenStorage.clearTokens();
    }
    return super.onError(err, handler);
  }
}
