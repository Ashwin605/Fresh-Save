import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_models.freezed.dart';
part 'notification_models.g.dart';

enum NotificationType {
  @JsonValue('RESERVATION_CREATED')
  reservationCreated,
  @JsonValue('RESERVATION_CONFIRMED')
  reservationConfirmed,
  @JsonValue('RESERVATION_REJECTED')
  reservationRejected,
  @JsonValue('RESERVATION_CANCELLED')
  reservationCancelled,
  @JsonValue('RESERVATION_READY')
  reservationReady,
  @JsonValue('RESERVATION_COMPLETED')
  reservationCompleted,
  @JsonValue('RESERVATION_EXPIRED')
  reservationExpired,

  @JsonValue('OFFER_ACTIVATED')
  offerActivated,
  @JsonValue('OFFER_SOLD_OUT')
  offerSoldOut,
  @JsonValue('OFFER_EXPIRED')
  offerExpired,

  @JsonValue('INVENTORY_EXPIRING_SOON')
  inventoryExpiringSoon,
  @JsonValue('INVENTORY_CRITICAL')
  inventoryCritical,
  @JsonValue('INVENTORY_EXPIRED')
  inventoryExpired,

  @JsonValue('UNKNOWN')
  unknown,
}

@freezed
abstract class AppNotification with _$AppNotification {
  const factory AppNotification({
    required String id,
    required NotificationType type,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
    required bool isRead,
    required DateTime createdAt,
    DateTime? readAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);
}

@freezed
abstract class NotificationQuery with _$NotificationQuery {
  const factory NotificationQuery({
    bool? unread,
    NotificationType? type,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _NotificationQuery;

  factory NotificationQuery.fromJson(Map<String, dynamic> json) =>
      _$NotificationQueryFromJson(json);
}
