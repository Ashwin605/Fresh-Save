import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_models.freezed.dart';
part 'inventory_models.g.dart';

@freezed
abstract class InventoryProduct with _$InventoryProduct {
  const factory InventoryProduct({
    required String name,
    required String brand,
    required String unit,
    String? sku,
    String? barcode,
  }) = _InventoryProduct;

  factory InventoryProduct.fromJson(Map<String, dynamic> json) =>
      _$InventoryProductFromJson(json);
}

@freezed
abstract class OwnerInventoryItem with _$OwnerInventoryItem {
  const factory OwnerInventoryItem({
    required String id,
    required String storeId,
    required String productId,
    String? batchNumber,
    required int stockQuantity,
    required double originalPrice,
    required double sellingPrice,
    DateTime? manufacturingDate,
    required DateTime expiryDate,
    required String status,
    required String expiryStatus,
    required String timeRemaining,
    required InventoryProduct product,
  }) = _OwnerInventoryItem;

  factory OwnerInventoryItem.fromJson(Map<String, dynamic> json) =>
      _$OwnerInventoryItemFromJson(json);
}

@freezed
abstract class AdjustStockRequest with _$AdjustStockRequest {
  const factory AdjustStockRequest({
    required String action, // ADD, REMOVE, SET
    required int quantity,
    String? reason,
    String? movementType,
  }) = _AdjustStockRequest;

  factory AdjustStockRequest.fromJson(Map<String, dynamic> json) =>
      _$AdjustStockRequestFromJson(json);
}

@freezed
abstract class InventoryPaginatedResponse with _$InventoryPaginatedResponse {
  const factory InventoryPaginatedResponse({
    required bool success,
    required InventoryPaginatedData data,
  }) = _InventoryPaginatedResponse;

  factory InventoryPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$InventoryPaginatedResponseFromJson(json);
}

@freezed
abstract class InventoryPaginatedData with _$InventoryPaginatedData {
  const factory InventoryPaginatedData({
    required List<OwnerInventoryItem> items,
    required InventoryPaginationInfo pagination,
  }) = _InventoryPaginatedData;

  factory InventoryPaginatedData.fromJson(Map<String, dynamic> json) =>
      _$InventoryPaginatedDataFromJson(json);
}

@freezed
abstract class InventoryPaginationInfo with _$InventoryPaginationInfo {
  const factory InventoryPaginationInfo({
    required int page,
    required int limit,
    required int total,
    required int totalPages,
  }) = _InventoryPaginationInfo;

  factory InventoryPaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$InventoryPaginationInfoFromJson(json);
}

// Trigger rebuild
