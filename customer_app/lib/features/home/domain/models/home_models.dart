import '../../../../core/widgets/chips_badges/expiry_badge.dart';
import '../../../../core/widgets/domain/stock_indicator.dart';

class Category {
  final String id;
  final String name;
  final String? slug;
  final String? description;
  final String? icon;
  final String? image;
  final List<Category> children;

  const Category({
    required this.id,
    required this.name,
    this.slug,
    this.description,
    this.icon,
    this.image,
    this.children = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    final childrenJson = json['children'] as List?;
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String?,
      description: json['description'] as String?,
      icon: json['icon'] as String?,
      image: json['image'] as String?,
      children: childrenJson
              ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Flatten this category and its children into a single list.
  List<Category> get flattened => [this, ...children];
}

class Deal {
  final String id;
  final String productName;
  final String storeName;
  final String storeId;
  final double originalPrice;
  final double discountedPrice;
  final double discountPercent;
  final ExpiryStatus expiryStatus;
  final StockStatus stockStatus;
  final String? imageUrl;
  final double? distance;
  final int? remainingQuantity;
  final String? storeLogo;
  final String? storeAddress;
  final String? storeCity;

  const Deal({
    required this.id,
    required this.productName,
    required this.storeName,
    required this.storeId,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.expiryStatus,
    required this.stockStatus,
    this.imageUrl,
    this.distance,
    this.remainingQuantity,
    this.storeLogo,
    this.storeAddress,
    this.storeCity,
  });

  factory Deal.fromJson(Map<String, dynamic> json) {
    // Parse nested objects safely
    final product = json['product'] as Map<String, dynamic>? ?? {};
    final store = json['store'] as Map<String, dynamic>? ?? {};
    final offer = json['offer'] as Map<String, dynamic>? ?? {};
    final inventory = json['inventory'] as Map<String, dynamic>? ?? {};
    final distanceObj = json['distance'] as Map<String, dynamic>? ?? {};

    // Convert numeric prices safely
    final oPrice =
        double.tryParse(offer['originalPrice']?.toString() ?? '0') ?? 0.0;
    final dPrice =
        double.tryParse(offer['discountedPrice']?.toString() ?? '0') ?? 0.0;
    final dPercent =
        double.tryParse(offer['discountValue']?.toString() ?? '0') ?? 0.0;

    // Helper to calculate expiry status
    final endsAtStr = offer['endsAt'] as String?;
    final endsAt = endsAtStr != null
        ? DateTime.parse(endsAtStr)
        : DateTime.now();
    final expiryStatus = _calculateExpiry(endsAt);

    // Stock
    final qty = inventory['availableQuantity'] as int? ?? 10;
    final stockStatus = _calculateStock(qty);

    return Deal(
      id: json['id'] as String,
      productName: product['name'] as String? ?? 'Unknown Product',
      storeName: store['name'] as String? ?? 'Unknown Store',
      storeId: store['id'] as String? ?? '',
      originalPrice: oPrice,
      discountedPrice: dPrice,
      discountPercent: dPercent,
      expiryStatus: expiryStatus,
      stockStatus: stockStatus,
      imageUrl: product['image'] as String?,
      distance: (distanceObj['value'] as num?)?.toDouble(),
      remainingQuantity: qty,
      storeLogo: store['logo'] as String?,
      storeAddress: store['address'] as String?,
      storeCity: store['city'] as String?,
    );
  }

  static ExpiryStatus _calculateExpiry(DateTime endsAt) {
    final now = DateTime.now();
    final diff = endsAt.difference(now);
    if (diff.isNegative) return ExpiryStatus.expired;
    if (diff.inHours <= 12) return ExpiryStatus.critical;
    if (diff.inHours <= 24) return ExpiryStatus.urgent;
    if (diff.inDays <= 3) return ExpiryStatus.expiringSoon;
    return ExpiryStatus.fresh;
  }

  static StockStatus _calculateStock(int quantity) {
    if (quantity <= 0) return StockStatus.soldOut;
    if (quantity <= 5) return StockStatus.lowStock;
    return StockStatus.available;
  }
}

class Store {
  final String id;
  final String name;
  final String? logoUrl;
  final double rating;
  final double? distance;
  final int activeOffers;

  const Store({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.rating,
    this.distance,
    required this.activeOffers,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    final distanceObj = json['distance'] as Map<String, dynamic>? ?? {};
    return Store(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Store',
      logoUrl: json['logo'] as String?,
      rating:
          (json['rating'] as num?)?.toDouble() ??
          4.0, // Backend might not send rating yet
      distance: (distanceObj['value'] as num?)?.toDouble(),
      activeOffers: (json['activeDealCount'] as int?) ?? (json['activeOffers'] as int?) ?? 0,
    );
  }
}

class Product {
  final String id;
  final String name;
  final String? brand;
  final String? image;

  const Product({required this.id, required this.name, this.brand, this.image});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown Product',
      brand: json['brand'] as String?,
      image: json['image'] as String?,
    );
  }
}
