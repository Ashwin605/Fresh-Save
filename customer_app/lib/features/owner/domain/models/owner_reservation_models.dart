import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../reservations/domain/models/reservation_models.dart'
    show ReservationStatus;
import 'inventory_models.dart';

export '../../../reservations/domain/models/reservation_models.dart'
    show ReservationStatus;

part 'owner_reservation_models.freezed.dart';
part 'owner_reservation_models.g.dart';

@freezed
abstract class ReservationCustomer with _$ReservationCustomer {
  const factory ReservationCustomer({
    required String id,
    required String name,
    String? phone,
  }) = _ReservationCustomer;

  factory ReservationCustomer.fromJson(Map<String, dynamic> json) =>
      _$ReservationCustomerFromJson(json);
}

@freezed
abstract class OwnerReservationItem with _$OwnerReservationItem {
  const factory OwnerReservationItem({
    required String id,
    required String reservationId,
    required String inventoryId,
    required String productId,
    String? offerId,
    required int quantity,
    required double originalUnitPrice,
    required double discountedUnitPrice,
    required double discountAmount,
    required double subtotal,
    InventoryProduct? product,
  }) = _OwnerReservationItem;

  factory OwnerReservationItem.fromJson(Map<String, dynamic> json) =>
      _$OwnerReservationItemFromJson(json);
}

@freezed
abstract class OwnerReservation with _$OwnerReservation {
  const factory OwnerReservation({
    required String id,
    required String customerId,
    required String storeId,
    required String reservationCode,
    String? idempotencyKey,
    required ReservationStatus status,
    required double subtotal,
    required double totalDiscount,
    required double totalAmount,
    required DateTime reservedAt,
    required DateTime expiresAt,
    DateTime? confirmedAt,
    DateTime? readyAt,
    DateTime? completedAt,
    DateTime? cancelledAt,
    DateTime? rejectedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? pickupInfo,
    String? notes,
    String? cancellationReason,
    String? rejectionReason,
    ReservationCustomer? customer,
    @Default([]) List<OwnerReservationItem> items,
  }) = _OwnerReservation;

  factory OwnerReservation.fromJson(Map<String, dynamic> json) =>
      _$OwnerReservationFromJson(json);
}

@freezed
abstract class OwnerReservationPaginatedResponse
    with _$OwnerReservationPaginatedResponse {
  const factory OwnerReservationPaginatedResponse({
    required List<OwnerReservation> items,
    required OwnerReservationPaginationMeta meta,
  }) = _OwnerReservationPaginatedResponse;

  factory OwnerReservationPaginatedResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$OwnerReservationPaginatedResponseFromJson(json);
}

@freezed
abstract class OwnerReservationPaginationMeta
    with _$OwnerReservationPaginationMeta {
  const OwnerReservationPaginationMeta._();
  const factory OwnerReservationPaginationMeta({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _OwnerReservationPaginationMeta;

  bool get hasNextPage => page < totalPages;

  factory OwnerReservationPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$OwnerReservationPaginationMetaFromJson(json);
}
