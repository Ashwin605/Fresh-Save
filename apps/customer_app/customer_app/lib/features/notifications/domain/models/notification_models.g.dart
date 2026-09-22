// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      id: json['id'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      isRead: json['isRead'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'isRead': instance.isRead,
      'createdAt': instance.createdAt.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.reservationCreated: 'RESERVATION_CREATED',
  NotificationType.reservationConfirmed: 'RESERVATION_CONFIRMED',
  NotificationType.reservationRejected: 'RESERVATION_REJECTED',
  NotificationType.reservationCancelled: 'RESERVATION_CANCELLED',
  NotificationType.reservationReady: 'RESERVATION_READY',
  NotificationType.reservationCompleted: 'RESERVATION_COMPLETED',
  NotificationType.reservationExpired: 'RESERVATION_EXPIRED',
  NotificationType.offerActivated: 'OFFER_ACTIVATED',
  NotificationType.offerSoldOut: 'OFFER_SOLD_OUT',
  NotificationType.offerExpired: 'OFFER_EXPIRED',
  NotificationType.inventoryExpiringSoon: 'INVENTORY_EXPIRING_SOON',
  NotificationType.inventoryCritical: 'INVENTORY_CRITICAL',
  NotificationType.inventoryExpired: 'INVENTORY_EXPIRED',
  NotificationType.unknown: 'UNKNOWN',
};

_NotificationQuery _$NotificationQueryFromJson(Map<String, dynamic> json) =>
    _NotificationQuery(
      unread: json['unread'] as bool?,
      type: $enumDecodeNullable(_$NotificationTypeEnumMap, json['type']),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
    );

Map<String, dynamic> _$NotificationQueryToJson(_NotificationQuery instance) =>
    <String, dynamic>{
      'unread': instance.unread,
      'type': _$NotificationTypeEnumMap[instance.type],
      'page': instance.page,
      'limit': instance.limit,
    };
