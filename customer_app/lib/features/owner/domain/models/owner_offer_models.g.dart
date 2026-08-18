// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_offer_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerOffer _$OwnerOfferFromJson(Map<String, dynamic> json) => _OwnerOffer(
  id: json['id'] as String,
  inventoryId: json['inventoryId'] as String,
  title: json['title'] as String?,
  description: json['description'] as String?,
  discountType: $enumDecode(_$DiscountTypeEnumMap, json['discountType']),
  discountValue: (json['discountValue'] as num).toDouble(),
  originalPriceSnapshot: (json['originalPriceSnapshot'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num).toDouble(),
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
  status: $enumDecode(_$OfferStatusEnumMap, json['status']),
  effectiveStatus: $enumDecodeNullable(
    _$OfferStatusEnumMap,
    json['effectiveStatus'],
  ),
  createdById: json['createdById'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
  inventory: json['inventory'] == null
      ? null
      : OwnerInventoryItem.fromJson(json['inventory'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OwnerOfferToJson(_OwnerOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'inventoryId': instance.inventoryId,
      'title': instance.title,
      'description': instance.description,
      'discountType': _$DiscountTypeEnumMap[instance.discountType]!,
      'discountValue': instance.discountValue,
      'originalPriceSnapshot': instance.originalPriceSnapshot,
      'discountAmount': instance.discountAmount,
      'discountedPrice': instance.discountedPrice,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
      'status': _$OfferStatusEnumMap[instance.status]!,
      'effectiveStatus': _$OfferStatusEnumMap[instance.effectiveStatus],
      'createdById': instance.createdById,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'inventory': instance.inventory,
    };

const _$DiscountTypeEnumMap = {
  DiscountType.percentage: 'PERCENTAGE',
  DiscountType.fixedAmount: 'FIXED_AMOUNT',
};

const _$OfferStatusEnumMap = {
  OfferStatus.draft: 'DRAFT',
  OfferStatus.scheduled: 'SCHEDULED',
  OfferStatus.active: 'ACTIVE',
  OfferStatus.paused: 'PAUSED',
  OfferStatus.expired: 'EXPIRED',
  OfferStatus.cancelled: 'CANCELLED',
  OfferStatus.soldOut: 'SOLD_OUT',
};

_OwnerOfferPaginatedResponse _$OwnerOfferPaginatedResponseFromJson(
  Map<String, dynamic> json,
) => _OwnerOfferPaginatedResponse(
  items: (json['items'] as List<dynamic>)
      .map((e) => OwnerOffer.fromJson(e as Map<String, dynamic>))
      .toList(),
  meta: OwnerOfferPaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OwnerOfferPaginatedResponseToJson(
  _OwnerOfferPaginatedResponse instance,
) => <String, dynamic>{'items': instance.items, 'meta': instance.meta};

_OwnerOfferPaginationMeta _$OwnerOfferPaginationMetaFromJson(
  Map<String, dynamic> json,
) => _OwnerOfferPaginationMeta(
  total: (json['total'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
  hasNextPage: json['hasNextPage'] as bool,
  hasPreviousPage: json['hasPreviousPage'] as bool,
);

Map<String, dynamic> _$OwnerOfferPaginationMetaToJson(
  _OwnerOfferPaginationMeta instance,
) => <String, dynamic>{
  'total': instance.total,
  'page': instance.page,
  'limit': instance.limit,
  'totalPages': instance.totalPages,
  'hasNextPage': instance.hasNextPage,
  'hasPreviousPage': instance.hasPreviousPage,
};

_CreateOfferRequest _$CreateOfferRequestFromJson(Map<String, dynamic> json) =>
    _CreateOfferRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      discountType: $enumDecode(_$DiscountTypeEnumMap, json['discountType']),
      discountValue: (json['discountValue'] as num).toDouble(),
      startsAt: json['startsAt'] as String,
      endsAt: json['endsAt'] as String,
    );

Map<String, dynamic> _$CreateOfferRequestToJson(_CreateOfferRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'discountType': _$DiscountTypeEnumMap[instance.discountType]!,
      'discountValue': instance.discountValue,
      'startsAt': instance.startsAt,
      'endsAt': instance.endsAt,
    };

_UpdateOfferRequest _$UpdateOfferRequestFromJson(Map<String, dynamic> json) =>
    _UpdateOfferRequest(
      title: json['title'] as String?,
      description: json['description'] as String?,
      discountType: $enumDecodeNullable(
        _$DiscountTypeEnumMap,
        json['discountType'],
      ),
      discountValue: (json['discountValue'] as num?)?.toDouble(),
      startsAt: json['startsAt'] as String?,
      endsAt: json['endsAt'] as String?,
    );

Map<String, dynamic> _$UpdateOfferRequestToJson(_UpdateOfferRequest instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'discountType': _$DiscountTypeEnumMap[instance.discountType],
      'discountValue': instance.discountValue,
      'startsAt': instance.startsAt,
      'endsAt': instance.endsAt,
    };
