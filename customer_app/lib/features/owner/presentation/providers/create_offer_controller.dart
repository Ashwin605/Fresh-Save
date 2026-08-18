import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/owner_offer_models.dart';
import '../../domain/models/inventory_models.dart';
import '../../data/repositories/owner_offer_repository_provider.dart';
import 'owner_offer_list_provider.dart';
import '../../../../../core/network/result.dart';

class CreateOfferState {
  final OwnerInventoryItem? selectedInventory;
  final DiscountType discountType;
  final double discountValue;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final String title;
  final String description;
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  CreateOfferState({
    this.selectedInventory,
    this.discountType = DiscountType.percentage,
    this.discountValue = 0,
    this.startsAt,
    this.endsAt,
    this.title = '',
    this.description = '',
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  CreateOfferState copyWith({
    OwnerInventoryItem? selectedInventory,
    DiscountType? discountType,
    double? discountValue,
    DateTime? startsAt,
    DateTime? endsAt,
    String? title,
    String? description,
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return CreateOfferState(
      selectedInventory: selectedInventory ?? this.selectedInventory,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      title: title ?? this.title,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class CreateOfferController extends Notifier<CreateOfferState> {
  @override
  CreateOfferState build() {
    return CreateOfferState();
  }

  void selectInventory(OwnerInventoryItem inventory) {
    state = state.copyWith(selectedInventory: inventory, error: null);
  }

  void updatePricing(DiscountType type, double value) {
    state = state.copyWith(discountType: type, discountValue: value);
  }

  void updateDates(DateTime startsAt, DateTime endsAt) {
    state = state.copyWith(startsAt: startsAt, endsAt: endsAt);
  }

  void updateDetails(String title, String description) {
    state = state.copyWith(title: title, description: description);
  }

  Future<void> submit() async {
    if (state.isLoading) return; // Prevent double-tap

    if (state.selectedInventory == null ||
        state.startsAt == null ||
        state.endsAt == null) {
      state = state.copyWith(error: 'Please complete all required fields.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final repository = ref.read(ownerOfferRepositoryProvider);
    final request = CreateOfferRequest(
      title: state.title.isNotEmpty ? state.title : null,
      description: state.description.isNotEmpty ? state.description : null,
      discountType: state.discountType,
      discountValue: state.discountValue,
      startsAt: state.startsAt!.toUtc().toIso8601String(),
      endsAt: state.endsAt!.toUtc().toIso8601String(),
    );

    final result = await repository.createOffer(
      state.selectedInventory!.id,
      request,
    );

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false, isSuccess: true);
        ref.invalidate(ownerOfferListProvider);
      case Failure(:final error):
        state = state.copyWith(
          isLoading: false,
          error: error.message ?? 'Failed to create offer',
        );
    }
  }
}

final createOfferControllerProvider =
    NotifierProvider<CreateOfferController, CreateOfferState>(
      CreateOfferController.new,
    );
