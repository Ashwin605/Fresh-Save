import 'package:freezed_annotation/freezed_annotation.dart';

part 'reservation_models.freezed.dart';
part 'reservation_models.g.dart';

enum ReservationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('CONFIRMED')
  confirmed,
  @JsonValue('READY')
  ready,
  @JsonValue('COMPLETED')
  completed,
  @JsonValue('CANCELLED')
  cancelled,
  @JsonValue('EXPIRED')
  expired,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('FAILED')
  failed,
}

@freezed
abstract class ReservationItemRequest with _$ReservationItemRequest {
  const factory ReservationItemRequest({
    required String inventoryId,
    required int quantity,
  }) = _ReservationItemRequest;

  factory ReservationItemRequest.fromJson(Map<String, dynamic> json) =>
      _$ReservationItemRequestFromJson(json);
}

@freezed
abstract class CreateReservationRequest with _$CreateReservationRequest {
  const factory CreateReservationRequest({
    required String storeId,
    required List<ReservationItemRequest> items,
    String? notes,
  }) = _CreateReservationRequest;

  factory CreateReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestFromJson(json);
}

@freezed
abstract class Reservation with _$Reservation {
  const factory Reservation({
    required String id,
    required String customerId,
    required String storeId,
    required String reservationCode,
    String? idempotencyKey,
    required ReservationStatus status,
    @Default(0) double subtotal,
    @Default(0) double totalDiscount,
    @Default(0) double totalAmount,
    DateTime? expiresAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<ReservationItem> items,
  }) = _Reservation;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
}

@freezed
abstract class ReservationItem with _$ReservationItem {
  const factory ReservationItem({
    required String id,
    required String reservationId,
    required String inventoryId,
    required String productId,
    String? offerId,
    required int quantity,
    @Default(0) double originalUnitPrice,
    @Default(0) double discountedUnitPrice,
    @Default(0) double discountAmount,
    @Default(0) double subtotal,
  }) = _ReservationItem;

  factory ReservationItem.fromJson(Map<String, dynamic> json) =>
      _$ReservationItemFromJson(json);
}
