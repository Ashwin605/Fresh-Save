class Coupon {
  final String id;
  final String code;
  final String title;
  final String? description;
  final String discountType; // 'PERCENTAGE' or 'FIXED_AMOUNT'
  final double discountValue;
  final double? minimumOrderAmount;
  final double? maximumDiscountAmount;
  final DateTime expiryDate;
  final ShopInfo? shop;

  const Coupon({
    required this.id,
    required this.code,
    required this.title,
    this.description,
    required this.discountType,
    required this.discountValue,
    this.minimumOrderAmount,
    this.maximumDiscountAmount,
    required this.expiryDate,
    this.shop,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] as String,
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      discountType: json['discountType'] as String,
      discountValue: (json['discountValue'] as num).toDouble(),
      minimumOrderAmount: (json['minimumOrderAmount'] as num?)?.toDouble(),
      maximumDiscountAmount: (json['maximumDiscountAmount'] as num?)?.toDouble(),
      expiryDate: DateTime.parse(json['expiryDate'] as String),
      shop: json['shop'] != null ? ShopInfo.fromJson(json['shop']) : null,
    );
  }
}

class ShopInfo {
  final String id;
  final String name;

  const ShopInfo({required this.id, required this.name});

  factory ShopInfo.fromJson(Map<String, dynamic> json) {
    return ShopInfo(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
