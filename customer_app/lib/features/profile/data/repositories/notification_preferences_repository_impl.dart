import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/notification_preference_models.dart';
import 'notification_preferences_repository.dart';

final notificationPreferencesRepositoryImplProvider =
    Provider<NotificationPreferencesRepository>((ref) {
      return NotificationPreferencesRepositoryImpl(dio: ref.watch(dioProvider));
    });

class NotificationPreferencesRepositoryImpl
    implements NotificationPreferencesRepository {
  final Dio dio;

  NotificationPreferencesRepositoryImpl({required this.dio});

  @override
  Future<Result<NotificationPreferences>> getPreferences() async {
    try {
      // The backend does not currently have this endpoint and it may hang or 404.
      // We will mock the response for now.
      return Result.success(const NotificationPreferences(
        pushEnabled: true,
        emailEnabled: false,
        inAppEnabled: true,
        reservationUpdates: true,
        offerAlerts: true,
      ));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<NotificationPreferences>> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    try {
      // Mock update to immediately succeed with the new preferences
      return Result.success(preferences);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
