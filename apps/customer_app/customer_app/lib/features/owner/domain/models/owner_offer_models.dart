import 'package:freezed_annotation/freezed_annotation.dart';
import 'inventory_models.dart';

part 'owner_offer_models.freezed.dart';
part 'owner_offer_models.g.dart';

enum OfferStatus {
  @JsonValue('DRAFT')
  draft,
  @JsonValue('SCHEDULED')
  scheduled,
  @JsonValue('ACTIVE')
  active,
  @JsonValue('PAUSED')
  paused,
  @JsonValue('EXPIRED')
  expired,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('SOLD_OUT')
  soldOut,
}

enum DiscountType {
  @JsonValue('PERCENTAGE')
  percentage,
  @JsonValue('FIXED_AMOUNT')
  fixedAmount,
}

@freezed
abstract class OwnerOffer with _$OwnerOffer {
  const factory OwnerOffer({
    required String id,
    required String inventoryId,
    String? title,
    String? description,
    required DiscountType discountType,
    required double discountValue,
    required double originalPriceSnapshot,
    required double discountAmount,
    required double discountedPrice,
    required DateTime startsAt,
    required DateTime endsAt,
    required OfferStatus status,
    OfferStatus? effectiveStatus, // Provided dynamically by backend
    required String createdById,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? deletedAt,

    // Relationship
    OwnerInventoryItem? inventory,
  }) = _OwnerOffer;

  factory OwnerOffer.fromJson(Map<String, dynamic> json) =>
      _$OwnerOfferFromJson(json);
}

@freezed
abstract class OwnerOfferPaginatedResponse with _$OwnerOfferPaginatedResponse {
  const factory OwnerOfferPaginatedResponse({
    required List<OwnerOffer> items,
    required OwnerOfferPaginationMeta meta,
  }) = _OwnerOfferPaginatedResponse;

  factory OwnerOfferPaginatedResponse.fromJson(Map<String, dynamic> json) =>
      _$OwnerOfferPaginatedResponseFromJson(json);
}

@freezed
abstract class OwnerOfferPaginationMeta with _$OwnerOfferPaginationMeta {
  const factory OwnerOfferPaginationMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
    required bool hasNextPage,
    required bool hasPreviousPage,
  }) = _OwnerOfferPaginationMeta;

  factory OwnerOfferPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$OwnerOfferPaginationMetaFromJson(json);
}

@freezed
abstract class CreateOfferRequest with _$CreateOfferRequest {
  const factory CreateOfferRequest({
    String? title,
    String? description,
    required DiscountType discountType,
    required double discountValue,
    required String startsAt, // ISO 8601
    required String endsAt, // ISO 8601
  }) = _CreateOfferRequest;

  factory CreateOfferRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOfferRequestFromJson(json);
}

@freezed
abstract class UpdateOfferRequest with _$UpdateOfferRequest {
  const factory UpdateOfferRequest({
    String? title,
    String? description,
    DiscountType? discountType,
    double? discountValue,
    String? startsAt,
    String? endsAt,
  }) = _UpdateOfferRequest;

  factory UpdateOfferRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOfferRequestFromJson(json);
}
