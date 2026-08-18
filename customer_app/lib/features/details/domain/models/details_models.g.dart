// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DealDetail _$DealDetailFromJson(Map<String, dynamic> json) => _DealDetail(
  id: json['id'] as String,
  product: DealProduct.fromJson(json['product'] as Map<String, dynamic>),
  offer: DealOffer.fromJson(json['offer'] as Map<String, dynamic>),
  inventory: DealInventory.fromJson(json['inventory'] as Map<String, dynamic>),
  store: DealStore.fromJson(json['store'] as Map<String, dynamic>),
  distance: json['distance'] == null
      ? null
      : DealDistance.fromJson(json['distance'] as Map<String, dynamic>),
  relevanceScore: (json['relevanceScore'] as num?)?.toDouble() ?? 0,
);

Map<String, dynamic> _$DealDetailToJson(_DealDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
      'offer': instance.offer,
      'inventory': instance.inventory,
      'store': instance.store,
      'distance': instance.distance,
      'relevanceScore': instance.relevanceScore,
    };

_DealProduct _$DealProductFromJson(Map<String, dynamic> json) => _DealProduct(
  id: json['id'] as String,
  name: json['name'] as String,
  brand: json['brand'] as String?,
  image: json['image'] as String?,
  unit: json['unit'] as String?,
  category: json['category'] == null
      ? null
      : DealCategory.fromJson(json['category'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DealProductToJson(_DealProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'brand': instance.brand,
      'image': instance.image,
      'unit': instance.unit,
      'category': instance.category,
    };

_DealCategory _$DealCategoryFromJson(Map<String, dynamic> json) =>
    _DealCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
    );

Map<String, dynamic> _$DealCategoryToJson(_DealCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
    };

_DealOffer _$DealOfferFromJson(Map<String, dynamic> json) => _DealOffer(
  title: json['title'] as String?,
  description: json['description'] as String?,
  discountType: json['discountType'] as String,
  discountValue: (json['discountValue'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discountedPrice: (json['discountedPrice'] as num).toDouble(),
  discountAmount: (json['discountAmount'] as num).toDouble(),
  startsAt: DateTime.parse(json['startsAt'] as String),
  endsAt: DateTime.parse(json['endsAt'] as String),
);

Map<String, dynamic> _$DealOfferToJson(_DealOffer instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'discountType': instance.discountType,
      'discountValue': instance.discountValue,
      'originalPrice': instance.originalPrice,
      'discountedPrice': instance.discountedPrice,
      'discountAmount': instance.discountAmount,
      'startsAt': instance.startsAt.toIso8601String(),
      'endsAt': instance.endsAt.toIso8601String(),
    };

_DealInventory _$DealInventoryFromJson(Map<String, dynamic> json) =>
    _DealInventory(
      id: json['id'] as String,
      availableQuantity: (json['availableQuantity'] as num).toInt(),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      expiryStatus: json['expiryStatus'] as String,
    );

Map<String, dynamic> _$DealInventoryToJson(_DealInventory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'availableQuantity': instance.availableQuantity,
      'expiryDate': instance.expiryDate.toIso8601String(),
      'expiryStatus': instance.expiryStatus,
    };

_DealStore _$DealStoreFromJson(Map<String, dynamic> json) => _DealStore(
  id: json['id'] as String,
  name: json['name'] as String,
  logo: json['logo'] as String?,
  address: json['address'] as String?,
  city: json['city'] as String?,
);

Map<String, dynamic> _$DealStoreToJson(_DealStore instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'address': instance.address,
      'city': instance.city,
    };

_DealDistance _$DealDistanceFromJson(Map<String, dynamic> json) =>
    _DealDistance(
      value: (json['value'] as num).toDouble(),
      unit: json['unit'] as String,
    );

Map<String, dynamic> _$DealDistanceToJson(_DealDistance instance) =>
    <String, dynamic>{'value': instance.value, 'unit': instance.unit};

_ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) =>
    _ProductDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      image: json['image'] as String?,
      unit: json['unit'] as String?,
      categoryId: json['categoryId'] as String?,
      status: json['status'] as String?,
      category: json['category'] == null
          ? null
          : DealCategory.fromJson(json['category'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProductDetailToJson(_ProductDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'brand': instance.brand,
      'sku': instance.sku,
      'barcode': instance.barcode,
      'image': instance.image,
      'unit': instance.unit,
      'categoryId': instance.categoryId,
      'status': instance.status,
      'category': instance.category,
    };
