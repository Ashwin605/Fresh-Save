// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryProduct _$InventoryProductFromJson(Map<String, dynamic> json) =>
    _InventoryProduct(
      name: json['name'] as String,
      brand: json['brand'] as String,
      unit: json['unit'] as String,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
    );

Map<String, dynamic> _$InventoryProductToJson(_InventoryProduct instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'unit': instance.unit,
      'sku': instance.sku,
      'barcode': instance.barcode,
    };

_OwnerInventoryItem _$OwnerInventoryItemFromJson(Map<String, dynamic> json) =>
    _OwnerInventoryItem(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      productId: json['productId'] as String,
      batchNumber: json['batchNumber'] as String?,
      stockQuantity: (json['stockQuantity'] as num).toInt(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      sellingPrice: (json['sellingPrice'] as num).toDouble(),
      manufacturingDate: json['manufacturingDate'] == null
          ? null
          : DateTime.parse(json['manufacturingDate'] as String),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      status: json['status'] as String,
      expiryStatus: json['expiryStatus'] as String,
      timeRemaining: json['timeRemaining'] as String,
      product: InventoryProduct.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OwnerInventoryItemToJson(_OwnerInventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'storeId': instance.storeId,
      'productId': instance.productId,
      'batchNumber': instance.batchNumber,
      'stockQuantity': instance.stockQuantity,
      'originalPrice': instance.originalPrice,
      'sellingPrice': instance.sellingPrice,
      'manufacturingDate': instance.manufacturingDate?.toIso8601String(),
      'expiryDate': instance.expiryDate.toIso8601String(),
      'status': instance.status,
      'expiryStatus': instance.expiryStatus,
      'timeRemaining': instance.timeRemaining,
      'product': instance.product,
    };

_AdjustStockRequest _$AdjustStockRequestFromJson(Map<String, dynamic> json) =>
    _AdjustStockRequest(
      action: json['action'] as String,
      quantity: (json['quantity'] as num).toInt(),
      reason: json['reason'] as String?,
      movementType: json['movementType'] as String?,
    );

Map<String, dynamic> _$AdjustStockRequestToJson(_AdjustStockRequest instance) =>
    <String, dynamic>{
      'action': instance.action,
      'quantity': instance.quantity,
      'reason': instance.reason,
      'movementType': instance.movementType,
    };

_InventoryPaginatedResponse _$InventoryPaginatedResponseFromJson(
  Map<String, dynamic> json,
) => _InventoryPaginatedResponse(
  success: json['success'] as bool,
  data: InventoryPaginatedData.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$InventoryPaginatedResponseToJson(
  _InventoryPaginatedResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_InventoryPaginatedData _$InventoryPaginatedDataFromJson(
  Map<String, dynamic> json,
) => _InventoryPaginatedData(
  items: (json['items'] as List<dynamic>)
      .map((e) => OwnerInventoryItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: InventoryPaginationInfo.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$InventoryPaginatedDataToJson(
  _InventoryPaginatedData instance,
) => <String, dynamic>{
  'items': instance.items,
  'pagination': instance.pagination,
};

_InventoryPaginationInfo _$InventoryPaginationInfoFromJson(
  Map<String, dynamic> json,
) => _InventoryPaginationInfo(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$InventoryPaginationInfoToJson(
  _InventoryPaginationInfo instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
};
