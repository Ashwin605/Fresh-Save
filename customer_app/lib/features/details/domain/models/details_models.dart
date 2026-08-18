import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/widgets/chips_badges/expiry_badge.dart';
import '../../../../core/widgets/domain/stock_indicator.dart';

part 'details_models.freezed.dart';
part 'details_models.g.dart';

@freezed
abstract class DealDetail with _$DealDetail {
  const factory DealDetail({
    required String id,
    required DealProduct product,
    required DealOffer offer,
    required DealInventory inventory,
    required DealStore store,
    DealDistance? distance,
    @Default(0) double relevanceScore,
  }) = _DealDetail;

  factory DealDetail.fromJson(Map<String, dynamic> json) =>
      _$DealDetailFromJson(json);
}

@freezed
abstract class DealProduct with _$DealProduct {
  const factory DealProduct({
    required String id,
    required String name,
    String? brand,
    String? image,
    String? unit,
    DealCategory? category,
  }) = _DealProduct;

  factory DealProduct.fromJson(Map<String, dynamic> json) =>
      _$DealProductFromJson(json);
}

@freezed
abstract class DealCategory with _$DealCategory {
  const factory DealCategory({
    required String id,
    required String name,
    String? slug,
  }) = _DealCategory;

  factory DealCategory.fromJson(Map<String, dynamic> json) =>
      _$DealCategoryFromJson(json);
}

@freezed
abstract class DealOffer with _$DealOffer {
  const factory DealOffer({
    String? title,
    String? description,
    required String discountType,
    required double discountValue,
    required double originalPrice,
    required double discountedPrice,
    required double discountAmount,
    required DateTime startsAt,
    required DateTime endsAt,
  }) = _DealOffer;

  factory DealOffer.fromJson(Map<String, dynamic> json) =>
      _$DealOfferFromJson(json);
}

@freezed
abstract class DealInventory with _$DealInventory {
  const DealInventory._();

  const factory DealInventory({
    required String id,
    required int availableQuantity,
    required DateTime expiryDate,
    required String expiryStatus,
  }) = _DealInventory;

  factory DealInventory.fromJson(Map<String, dynamic> json) =>
      _$DealInventoryFromJson(json);

  ExpiryStatus get parsedExpiryStatus {
    switch (expiryStatus) {
      case 'FRESH':
        return ExpiryStatus.fresh;
      case 'EXPIRING_SOON':
        return ExpiryStatus.expiringSoon;
      case 'URGENT':
        return ExpiryStatus.urgent;
      case 'CRITICAL':
        return ExpiryStatus.critical;
      case 'EXPIRED':
        return ExpiryStatus.expired;
      default:
        return ExpiryStatus.fresh;
    }
  }

  StockStatus get parsedStockStatus {
    if (availableQuantity <= 0) return StockStatus.soldOut;
    if (availableQuantity <= 5) return StockStatus.lowStock;
    return StockStatus.available;
  }
}

@freezed
abstract class DealStore with _$DealStore {
  const factory DealStore({
    required String id,
    required String name,
    String? logo,
    String? address,
    String? city,
  }) = _DealStore;

  factory DealStore.fromJson(Map<String, dynamic> json) =>
      _$DealStoreFromJson(json);
}

@freezed
abstract class DealDistance with _$DealDistance {
  const factory DealDistance({required double value, required String unit}) =
      _DealDistance;

  factory DealDistance.fromJson(Map<String, dynamic> json) =>
      _$DealDistanceFromJson(json);
}

@freezed
abstract class ProductDetail with _$ProductDetail {
  const factory ProductDetail({
    required String id,
    required String name,
    String? slug,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    String? categoryId,
    String? status,
    DealCategory? category,
  }) = _ProductDetail;

  factory ProductDetail.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailFromJson(json);
}
