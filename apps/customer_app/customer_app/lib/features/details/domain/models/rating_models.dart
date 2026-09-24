class ShopRating {
  final String id;
  final int rating;
  final String? review;
  final String customerName;
  final DateTime createdAt;

  const ShopRating({
    required this.id,
    required this.rating,
    this.review,
    required this.customerName,
    required this.createdAt,
  });

  factory ShopRating.fromJson(Map<String, dynamic> json) {
    return ShopRating(
      id: json['id'] as String,
      rating: json['rating'] as int,
      review: json['review'] as String?,
      customerName: json['customer']?['name'] as String? ?? 'Anonymous',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class ShopRatingSummary {
  final double averageRating;
  final int totalRatings;
  final Map<String, int> distribution;

  const ShopRatingSummary({
    required this.averageRating,
    required this.totalRatings,
    required this.distribution,
  });

  factory ShopRatingSummary.fromJson(Map<String, dynamic> json) {
    final dist = json['distribution'] as Map<String, dynamic>? ?? {};
    return ShopRatingSummary(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: json['totalRatings'] as int? ?? 0,
      distribution: {
        '5': dist['5'] as int? ?? 0,
        '4': dist['4'] as int? ?? 0,
        '3': dist['3'] as int? ?? 0,
        '2': dist['2'] as int? ?? 0,
        '1': dist['1'] as int? ?? 0,
      },
    );
  }
}
