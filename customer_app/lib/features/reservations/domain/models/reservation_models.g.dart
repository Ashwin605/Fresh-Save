// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReservationItemRequest _$ReservationItemRequestFromJson(
  Map<String, dynamic> json,
) => _ReservationItemRequest(
  inventoryId: json['inventoryId'] as String,
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$ReservationItemRequestToJson(
  _ReservationItemRequest instance,
) => <String, dynamic>{
  'inventoryId': instance.inventoryId,
  'quantity': instance.quantity,
};

_CreateReservationRequest _$CreateReservationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateReservationRequest(
  storeId: json['storeId'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => ReservationItemRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$CreateReservationRequestToJson(
  _CreateReservationRequest instance,
) => <String, dynamic>{
  'storeId': instance.storeId,
  'items': instance.items,
  'notes': instance.notes,
};

_Reservation _$ReservationFromJson(Map<String, dynamic> json) => _Reservation(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  storeId: json['storeId'] as String,
  reservationCode: json['reservationCode'] as String,
  idempotencyKey: json['idempotencyKey'] as String?,
  status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
  subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
  totalDiscount: (json['totalDiscount'] as num?)?.toDouble() ?? 0,
  totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
  expiresAt: json['expiresAt'] == null
      ? null
      : DateTime.parse(json['expiresAt'] as String),
  notes: json['notes'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => ReservationItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ReservationToJson(_Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'storeId': instance.storeId,
      'reservationCode': instance.reservationCode,
      'idempotencyKey': instance.idempotencyKey,
      'status': _$ReservationStatusEnumMap[instance.status]!,
      'subtotal': instance.subtotal,
      'totalDiscount': instance.totalDiscount,
      'totalAmount': instance.totalAmount,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
    };

const _$ReservationStatusEnumMap = {
  ReservationStatus.pending: 'PENDING',
  ReservationStatus.confirmed: 'CONFIRMED',
  ReservationStatus.ready: 'READY',
  ReservationStatus.completed: 'COMPLETED',
  ReservationStatus.cancelled: 'CANCELLED',
  ReservationStatus.expired: 'EXPIRED',
  ReservationStatus.rejected: 'REJECTED',
  ReservationStatus.failed: 'FAILED',
};

_ReservationItem _$ReservationItemFromJson(Map<String, dynamic> json) =>
    _ReservationItem(
      id: json['id'] as String,
      reservationId: json['reservationId'] as String,
      inventoryId: json['inventoryId'] as String,
      productId: json['productId'] as String,
      offerId: json['offerId'] as String?,
      quantity: (json['quantity'] as num).toInt(),
      originalUnitPrice: (json['originalUnitPrice'] as num?)?.toDouble() ?? 0,
      discountedUnitPrice:
          (json['discountedUnitPrice'] as num?)?.toDouble() ?? 0,
      discountAmount: (json['discountAmount'] as num?)?.toDouble() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$ReservationItemToJson(_ReservationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reservationId': instance.reservationId,
      'inventoryId': instance.inventoryId,
      'productId': instance.productId,
      'offerId': instance.offerId,
      'quantity': instance.quantity,
      'originalUnitPrice': instance.originalUnitPrice,
      'discountedUnitPrice': instance.discountedUnitPrice,
      'discountAmount': instance.discountAmount,
      'subtotal': instance.subtotal,
    };
