class DealRecommendation {
  final String offerId;
  final String productId;
  final String productName;
  final String storeName;
  final double discount;
  final double distanceKm;
  final double score;
  final List<String> reasons;

  const DealRecommendation({
    required this.offerId,
    required this.productId,
    required this.productName,
    required this.storeName,
    required this.discount,
    required this.distanceKm,
    required this.score,
    required this.reasons,
  });

  factory DealRecommendation.fromJson(Map<String, dynamic> json) {
    return DealRecommendation(
      offerId: json['offerId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      storeName: json['storeName'] as String,
      discount: (json['discount'] as num).toDouble(),
      distanceKm: (json['distanceKm'] as num).toDouble(),
      score: (json['score'] as num).toDouble(),
      reasons:
          (json['reasons'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'productId': productId,
      'productName': productName,
      'storeName': storeName,
      'discount': discount,
      'distanceKm': distanceKm,
      'score': score,
      'reasons': reasons,
    };
  }
}
