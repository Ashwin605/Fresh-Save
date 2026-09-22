// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_reservation_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReservationCustomer _$ReservationCustomerFromJson(Map<String, dynamic> json) =>
    _ReservationCustomer(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$ReservationCustomerToJson(
  _ReservationCustomer instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone': instance.phone,
};

_OwnerReservationItem _$OwnerReservationItemFromJson(
  Map<String, dynamic> json,
) => _OwnerReservationItem(
  id: json['id'] as String,
  reservationId: json['reservationId'] as String,
  inventoryId: json['inventoryId'] as String,
  productId: json['productId'] as String,
  offerId: json['offerId'] as String?,
  quantity: (json['quantity'] as num).toInt(),
  originalUnitPrice: (json['originalUnitPrice'] as num).toDouble(),
  discountedUnitPrice: (json['discountedUnitPrice'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num).toDouble(),
  subtotal: (json['subtotal'] as num).toDouble(),
  product: json['product'] == null
      ? null
      : InventoryProduct.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OwnerReservationItemToJson(
  _OwnerReservationItem instance,
) => <String, dynamic>{
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
  'product': instance.product,
};

_OwnerReservation _$OwnerReservationFromJson(
  Map<String, dynamic> json,
) => _OwnerReservation(
  id: json['id'] as String,
  customerId: json['customerId'] as String,
  storeId: json['storeId'] as String,
  reservationCode: json['reservationCode'] as String,
  idempotencyKey: json['idempotencyKey'] as String?,
  status: $enumDecode(_$ReservationStatusEnumMap, json['status']),
  subtotal: (json['subtotal'] as num).toDouble(),
  totalDiscount: (json['totalDiscount'] as num).toDouble(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  reservedAt: DateTime.parse(json['reservedAt'] as String),
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  confirmedAt: json['confirmedAt'] == null
      ? null
      : DateTime.parse(json['confirmedAt'] as String),
  readyAt: json['readyAt'] == null
      ? null
      : DateTime.parse(json['readyAt'] as String),
  completedAt: json['completedAt'] == null
      ? null
      : DateTime.parse(json['completedAt'] as String),
  cancelledAt: json['cancelledAt'] == null
      ? null
      : DateTime.parse(json['cancelledAt'] as String),
  rejectedAt: json['rejectedAt'] == null
      ? null
      : DateTime.parse(json['rejectedAt'] as String),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  pickupInfo: json['pickupInfo'] as Map<String, dynamic>?,
  notes: json['notes'] as String?,
  cancellationReason: json['cancellationReason'] as String?,
  rejectionReason: json['rejectionReason'] as String?,
  customer: json['customer'] == null
      ? null
      : ReservationCustomer.fromJson(json['customer'] as Map<String, dynamic>),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OwnerReservationItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$OwnerReservationToJson(_OwnerReservation instance) =>
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
      'reservedAt': instance.reservedAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'confirmedAt': instance.confirmedAt?.toIso8601String(),
      'readyAt': instance.readyAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'cancelledAt': instance.cancelledAt?.toIso8601String(),
      'rejectedAt': instance.rejectedAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'pickupInfo': instance.pickupInfo,
      'notes': instance.notes,
      'cancellationReason': instance.cancellationReason,
      'rejectionReason': instance.rejectionReason,
      'customer': instance.customer,
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

_OwnerReservationPaginatedResponse _$OwnerReservationPaginatedResponseFromJson(
  Map<String, dynamic> json,
) => _OwnerReservationPaginatedResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => OwnerReservation.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: OwnerReservationPaginationMeta.fromJson(
    json['meta'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OwnerReservationPaginatedResponseToJson(
  _OwnerReservationPaginatedResponse instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};

_OwnerReservationPaginationMeta _$OwnerReservationPaginationMetaFromJson(
  Map<String, dynamic> json,
) => _OwnerReservationPaginationMeta(
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$OwnerReservationPaginationMetaToJson(
  _OwnerReservationPaginationMeta instance,
) => <String, dynamic>{
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
};
