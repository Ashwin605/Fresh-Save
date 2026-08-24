import 'package:freezed_annotation/freezed_annotation.dart';

part 'owner_product_models.freezed.dart';
part 'owner_product_models.g.dart';

@freezed
abstract class OwnerProductCategory with _$OwnerProductCategory {
  const factory OwnerProductCategory({
    required String id,
    required String name,
    required String slug,
    String? parentId,
  }) = _OwnerProductCategory;

  factory OwnerProductCategory.fromJson(Map<String, dynamic> json) =>
      _$OwnerProductCategoryFromJson(json);
}

@freezed
abstract class OwnerProduct with _$OwnerProduct {
  const factory OwnerProduct({
    required String id,
    required String name,
    required String categoryId,
    String? slug,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    required String status,
    OwnerProductCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _OwnerProduct;

  factory OwnerProduct.fromJson(Map<String, dynamic> json) =>
      _$OwnerProductFromJson(json);
}

@freezed
abstract class OwnerProductPaginatedResponse
    with _$OwnerProductPaginatedResponse {
  const factory OwnerProductPaginatedResponse({
    required bool success,
    required OwnerProductPaginatedData data,
  }) = _OwnerProductPaginatedResponse;

  factory OwnerProductPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$OwnerProductPaginatedResponseFromJson(json);
}

@freezed
abstract class OwnerProductPaginatedData with _$OwnerProductPaginatedData {
  const factory OwnerProductPaginatedData({
    required List<OwnerProduct> items,
    required OwnerProductPaginationInfo pagination,
  }) = _OwnerProductPaginatedData;

  factory OwnerProductPaginatedData.fromJson(Map<String, dynamic> json) =>
      _$OwnerProductPaginatedDataFromJson(json);
}

@freezed
abstract class OwnerProductPaginationInfo with _$OwnerProductPaginationInfo {
  const factory OwnerProductPaginationInfo({
    required int page,
    required int limit,
    required int total,
    required int totalPages,
  }) = _OwnerProductPaginationInfo;

  factory OwnerProductPaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$OwnerProductPaginationInfoFromJson(json);
}
