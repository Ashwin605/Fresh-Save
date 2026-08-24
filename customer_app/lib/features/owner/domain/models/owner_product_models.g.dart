// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'owner_product_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OwnerProductCategory _$OwnerProductCategoryFromJson(
  Map<String, dynamic> json,
) => _OwnerProductCategory(
  id: json['id'] as String,
  name: json['name'] as String,
  slug: json['slug'] as String,
  parentId: json['parentId'] as String?,
);

Map<String, dynamic> _$OwnerProductCategoryToJson(
  _OwnerProductCategory instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'slug': instance.slug,
  'parentId': instance.parentId,
};

_OwnerProduct _$OwnerProductFromJson(Map<String, dynamic> json) =>
    _OwnerProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      categoryId: json['categoryId'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      image: json['image'] as String?,
      unit: json['unit'] as String?,
      status: json['status'] as String,
      category: json['category'] == null
          ? null
          : OwnerProductCategory.fromJson(
              json['category'] as Map<String, dynamic>,
            ),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OwnerProductToJson(_OwnerProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'slug': instance.slug,
      'description': instance.description,
      'brand': instance.brand,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'image': instance.image,
      'unit': instance.unit,
      'status': instance.status,
      'category': instance.category,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_OwnerProductPaginatedResponse _$OwnerProductPaginatedResponseFromJson(
  Map<String, dynamic> json,
) => _OwnerProductPaginatedResponse(
  success: json['success'] as bool,
  data: OwnerProductPaginatedData.fromJson(
    json['data'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OwnerProductPaginatedResponseToJson(
  _OwnerProductPaginatedResponse instance,
) => <String, dynamic>{'success': instance.success, 'data': instance.data};

_OwnerProductPaginatedData _$OwnerProductPaginatedDataFromJson(
  Map<String, dynamic> json,
) => _OwnerProductPaginatedData(
  items: (json['items'] as List<dynamic>)
      .map((e) => OwnerProduct.fromJson(e as Map<String, dynamic>))
      .toList(),
  pagination: OwnerProductPaginationInfo.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$OwnerProductPaginatedDataToJson(
  _OwnerProductPaginatedData instance,
) => <String, dynamic>{
  'items': instance.items,
  'pagination': instance.pagination,
};

_OwnerProductPaginationInfo _$OwnerProductPaginationInfoFromJson(
  Map<String, dynamic> json,
) => _OwnerProductPaginationInfo(
  page: (json['page'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _$OwnerProductPaginationInfoToJson(
  _OwnerProductPaginationInfo instance,
) => <String, dynamic>{
  'page': instance.page,
  'limit': instance.limit,
  'total': instance.total,
  'totalPages': instance.totalPages,
};
