import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/notification_preference_models.dart';
import 'notification_preferences_repository_impl.dart';

final notificationPreferencesRepositoryProvider =
    Provider<NotificationPreferencesRepository>((ref) {
      return ref.watch(notificationPreferencesRepositoryImplProvider);
    });

abstract class NotificationPreferencesRepository {
  Future<Result<NotificationPreferences>> getPreferences();
  Future<Result<NotificationPreferences>> updatePreferences(
    NotificationPreferences preferences,
  );
}
