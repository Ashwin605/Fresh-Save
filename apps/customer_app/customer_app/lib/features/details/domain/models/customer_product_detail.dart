import 'details_models.dart';

/// Represents a store-level inventory item for a product with pricing and discount details.
class ProductInventoryOption {
  final String id;
  final int stockQuantity;
  final int reservedQuantity;
  final double sellingPrice;
  final double originalPrice;
  final DateTime expiryDate;
  final String storeId;
  final String storeName;
  final String? storeLogo;
  final String? storeAddress;
  final String? storeCity;
  final String? offerId;
  final double? discountedPrice;
  final double? discountValue;
  final String? discountType;

  const ProductInventoryOption({
    required this.id,
    required this.stockQuantity,
    required this.reservedQuantity,
    required this.sellingPrice,
    required this.originalPrice,
    required this.expiryDate,
    required this.storeId,
    required this.storeName,
    this.storeLogo,
    this.storeAddress,
    this.storeCity,
    this.offerId,
    this.discountedPrice,
    this.discountValue,
    this.discountType,
  });

  bool get isInStock => stockQuantity - reservedQuantity > 0;
  int get availableQuantity => (stockQuantity - reservedQuantity).clamp(0, 9999);

  double get effectivePrice => discountedPrice ?? sellingPrice;
  bool get hasDiscount => discountedPrice != null && discountedPrice! < originalPrice;
  double get savingsAmount => hasDiscount ? (originalPrice - effectivePrice) : 0.0;
  double get discountPercentage {
    if (discountValue != null && discountValue! > 0) return discountValue!;
    if (originalPrice > 0 && hasDiscount) {
      return ((originalPrice - effectivePrice) / originalPrice) * 100;
    }
    return 0.0;
  }

  factory ProductInventoryOption.fromJson(Map<String, dynamic> json) {
    final store = json['store'] as Map<String, dynamic>? ?? {};
    final offers = json['offers'] as List?;
    final firstOffer = (offers != null && offers.isNotEmpty)
        ? offers.first as Map<String, dynamic>?
        : null;

    final sPrice = double.tryParse(json['sellingPrice']?.toString() ?? '0') ?? 0.0;
    final oPrice = double.tryParse(json['originalPrice']?.toString() ?? '0') ?? 0.0;

    return ProductInventoryOption(
      id: json['id'] as String,
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      reservedQuantity: json['reservedQuantity'] as int? ?? 0,
      sellingPrice: sPrice,
      originalPrice: oPrice > 0 ? oPrice : sPrice,
      expiryDate: DateTime.tryParse(json['expiryDate']?.toString() ?? '') ?? DateTime.now(),
      storeId: store['id'] as String? ?? '',
      storeName: store['name'] as String? ?? 'FreshSave Partner',
      storeLogo: store['logoUrl'] as String?,
      storeAddress: store['address'] as String?,
      storeCity: store['city'] as String?,
      offerId: firstOffer?['id'] as String?,
      discountedPrice: firstOffer != null
          ? (double.tryParse(firstOffer['discountedPrice']?.toString() ?? '') ?? sPrice)
          : null,
      discountValue: firstOffer != null
          ? (double.tryParse(firstOffer['discountValue']?.toString() ?? '') ?? 0.0)
          : null,
      discountType: firstOffer?['discountType'] as String?,
    );
  }
}

/// Product details model including store inventory, pricing, and availability.
class CustomerProductDetail {
  final ProductDetail product;
  final List<ProductInventoryOption> inventory;

  const CustomerProductDetail({
    required this.product,
    this.inventory = const [],
  });

  bool get hasActiveInventory => inventory.any((inv) => inv.isInStock);

  ProductInventoryOption? get primaryOption {
    if (inventory.isEmpty) return null;
    // Prefer in-stock inventory with discount, then in-stock, then first
    final inStockWithDiscount = inventory.where((i) => i.isInStock && i.hasDiscount);
    if (inStockWithDiscount.isNotEmpty) return inStockWithDiscount.first;
    final inStock = inventory.where((i) => i.isInStock);
    if (inStock.isNotEmpty) return inStock.first;
    return inventory.first;
  }

  factory CustomerProductDetail.fromJson(Map<String, dynamic> json) {
    final product = ProductDetail.fromJson(json);
    final invList = json['inventory'] as List?;
    final inventory = invList != null
        ? invList
            .map((e) => ProductInventoryOption.fromJson(e as Map<String, dynamic>))
            .toList()
        : <ProductInventoryOption>[];

    return CustomerProductDetail(
      product: product,
      inventory: inventory,
    );
  }
}
