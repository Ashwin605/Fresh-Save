import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/notification_models.dart';
import 'notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final Ref _ref;
  Dio get _dio => _ref.read(dioProvider);

  NotificationRepositoryImpl(this._ref);

  @override
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unread,
    NotificationType? type,
    String? cursor,
    Map<String, dynamic>? filters,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};
      if (unread != null) queryParams['unread'] = unread;
      if (type != null) {
        queryParams['type'] = type.name
            .replaceAllMapped(RegExp(r'[A-Z]'), (match) => '_${match.group(0)}')
            .toUpperCase();
      }
      if (cursor != null) queryParams['cursor'] = cursor;
      if (filters != null) queryParams.addAll(filters);

      final response = await _dio.get(
        '/notifications',
        queryParameters: queryParams,
      );

      if (response.data != null && response.data['success'] == true) {
        final items = (response.data['data']['items'] as List)
            .map((json) => AppNotification.fromJson(json))
            .toList();
        return Result.success(items);
      }
      return const Result.failure(
        AppError.server(message: 'Invalid response from server'),
      );
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<int>> getUnreadCount() async {
    try {
      final response = await _dio.get('/notifications/unread-count');

      if (response.data != null && response.data['success'] == true) {
        return Result.success(response.data['data'] as int);
      }
      return const Result.failure(AppError.server(message: 'Invalid response'));
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String id) async {
    try {
      await _dio.post('/notifications/$id/read');
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAllAsRead() async {
    try {
      await _dio.post('/notifications/read-all');
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteNotification(String id) async {
    try {
      await _dio.delete('/notifications/$id');
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
