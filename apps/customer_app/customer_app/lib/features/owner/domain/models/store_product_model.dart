import 'owner_product_models.dart';

class StoreProduct {
  final String id;
  final String productId;
  final String inventoryId;
  final String storeId;
  final String name;
  final String? slug;
  final String? description;
  final String? brand;
  final String? sku;
  final String? barcode;
  final String? image;
  final String? unit;
  final OwnerProductCategory? category;
  final String? categoryId;
  final double sellingPrice;
  final double originalPrice;
  final int stockQuantity;
  final int reservedQuantity;
  final int availableQuantity;
  final String status; // ACTIVE, INACTIVE
  final String inventoryStatus; // ACTIVE, INACTIVE, OUT_OF_STOCK
  final DateTime? expiryDate;
  final DateTime? manufacturingDate;
  final String? batchNumber;
  final String? expiryStatus;
  final String? timeRemaining;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StoreProduct({
    required this.id,
    required this.productId,
    required this.inventoryId,
    required this.storeId,
    required this.name,
    this.slug,
    this.description,
    this.brand,
    this.sku,
    this.barcode,
    this.image,
    this.unit,
    this.category,
    this.categoryId,
    required this.sellingPrice,
    required this.originalPrice,
    required this.stockQuantity,
    this.reservedQuantity = 0,
    required this.availableQuantity,
    required this.status,
    required this.inventoryStatus,
    this.expiryDate,
    this.manufacturingDate,
    this.batchNumber,
    this.expiryStatus,
    this.timeRemaining,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreProduct.fromJson(Map<String, dynamic> json) {
    return StoreProduct(
      id: json['id'] as String? ?? json['productId'] as String? ?? '',
      productId: json['productId'] as String? ?? json['id'] as String? ?? '',
      inventoryId: json['inventoryId'] as String? ?? '',
      storeId: json['storeId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      brand: json['brand'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      image: json['image'] as String?,
      unit: json['unit'] as String?,
      category: json['category'] != null
          ? OwnerProductCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      categoryId: json['categoryId'] as String?,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? 0.0,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt() ?? 0,
      reservedQuantity: (json['reservedQuantity'] as num?)?.toInt() ?? 0,
      availableQuantity: (json['availableQuantity'] as num?)?.toInt() ??
          ((json['stockQuantity'] as num?)?.toInt() ?? 0),
      status: json['status'] as String? ?? 'ACTIVE',
      inventoryStatus: json['inventoryStatus'] as String? ?? 'ACTIVE',
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)
          : null,
      manufacturingDate: json['manufacturingDate'] != null
          ? DateTime.tryParse(json['manufacturingDate'] as String)
          : null,
      batchNumber: json['batchNumber'] as String?,
      expiryStatus: json['expiryStatus'] as String?,
      timeRemaining: json['timeRemaining'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'inventoryId': inventoryId,
      'storeId': storeId,
      'name': name,
      'slug': slug,
      'description': description,
      'brand': brand,
      'sku': sku,
      'barcode': barcode,
      'image': image,
      'unit': unit,
      'category': category?.toJson(),
      'categoryId': categoryId,
      'sellingPrice': sellingPrice,
      'originalPrice': originalPrice,
      'stockQuantity': stockQuantity,
      'reservedQuantity': reservedQuantity,
      'availableQuantity': availableQuantity,
      'status': status,
      'inventoryStatus': inventoryStatus,
      'expiryDate': expiryDate?.toIso8601String(),
      'manufacturingDate': manufacturingDate?.toIso8601String(),
      'batchNumber': batchNumber,
      'expiryStatus': expiryStatus,
      'timeRemaining': timeRemaining,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  StoreProduct copyWith({
    String? id,
    String? productId,
    String? inventoryId,
    String? storeId,
    String? name,
    String? slug,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    OwnerProductCategory? category,
    String? categoryId,
    double? sellingPrice,
    double? originalPrice,
    int? stockQuantity,
    int? reservedQuantity,
    int? availableQuantity,
    String? status,
    String? inventoryStatus,
    DateTime? expiryDate,
    DateTime? manufacturingDate,
    String? batchNumber,
    String? expiryStatus,
    String? timeRemaining,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoreProduct(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      inventoryId: inventoryId ?? this.inventoryId,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      image: image ?? this.image,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      reservedQuantity: reservedQuantity ?? this.reservedQuantity,
      availableQuantity: availableQuantity ?? this.availableQuantity,
      status: status ?? this.status,
      inventoryStatus: inventoryStatus ?? this.inventoryStatus,
      expiryDate: expiryDate ?? this.expiryDate,
      manufacturingDate: manufacturingDate ?? this.manufacturingDate,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryStatus: expiryStatus ?? this.expiryStatus,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class StoreProductPaginatedResponse {
  final bool success;
  final StoreProductPaginatedData data;

  const StoreProductPaginatedResponse({
    required this.success,
    required this.data,
  });

  factory StoreProductPaginatedResponse.fromJson(Map<String, dynamic> json) {
    return StoreProductPaginatedResponse(
      success: json['success'] as bool? ?? true,
      data: StoreProductPaginatedData.fromJson(
        json['data'] as Map<String, dynamic>? ?? json,
      ),
    );
  }
}

class StoreProductPaginatedData {
  final List<StoreProduct> items;
  final StoreProductPaginationInfo pagination;

  const StoreProductPaginatedData({
    required this.items,
    required this.pagination,
  });

  factory StoreProductPaginatedData.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? [];
    return StoreProductPaginatedData(
      items: rawItems
          .map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? StoreProductPaginationInfo.fromJson(
              json['pagination'] as Map<String, dynamic>,
            )
          : const StoreProductPaginationInfo(
              page: 1,
              limit: 20,
              total: 0,
              totalPages: 1,
            ),
    );
  }
}

class StoreProductPaginationInfo {
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const StoreProductPaginationInfo({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  factory StoreProductPaginationInfo.fromJson(Map<String, dynamic> json) {
    return StoreProductPaginationInfo(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}
