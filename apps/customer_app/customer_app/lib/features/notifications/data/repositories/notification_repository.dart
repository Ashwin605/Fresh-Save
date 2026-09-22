import '../../../../core/network/result.dart';
import '../../domain/models/notification_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_repository_impl.dart';

abstract class NotificationRepository {
  Future<Result<List<AppNotification>>> getNotifications({
    int page = 1,
    int limit = 20,
    bool? unread,
    NotificationType? type,
    String? cursor,
    Map<String, dynamic>? filters,
  });
  Future<Result<int>> getUnreadCount();
  Future<Result<void>> markAsRead(String id);
  Future<Result<void>> markAllAsRead();
  Future<Result<void>> deleteNotification(String id);
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(ref);
});
