import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/notification_preference_models.dart';

abstract class NotificationPreferencesRepository {
  Future<Result<NotificationPreference>> getPreferences();
  Future<Result<NotificationPreference>> updatePreferences(
    Map<String, dynamic> data,
  );
}

final notificationPreferencesRepositoryProvider =
    Provider<NotificationPreferencesRepository>((ref) {
      return NotificationPreferencesRepositoryImpl(ref.watch(dioProvider));
    });

class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  final Dio _dio;

  NotificationPreferencesRepositoryImpl(this._dio);

  @override
  Future<Result<NotificationPreference>> getPreferences() async {
    try {
      final response = await _dio.get('/notifications/preferences');
      final data = response.data['data']['preferences'];
      return Result.success(NotificationPreference.fromJson(data));
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<NotificationPreference>> updatePreferences(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _dio.patch(
        '/notifications/preferences',
        data: data,
      );
      final prefData = response.data['data']['preferences'];
      return Result.success(NotificationPreference.fromJson(prefData));
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
