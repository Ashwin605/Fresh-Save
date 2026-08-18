import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_reservation_models.dart';
import '../../data/repositories/owner_reservation_repository_provider.dart';
import 'owner_reservation_list_provider.dart';
import 'owner_state_provider.dart';

class OwnerReservationActionState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const OwnerReservationActionState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  OwnerReservationActionState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return OwnerReservationActionState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class OwnerReservationActionController
    extends Notifier<OwnerReservationActionState> {
  @override
  OwnerReservationActionState build() {
    return const OwnerReservationActionState();
  }

  Future<void> _performAction(
    Future<Result<OwnerReservation>> Function() action,
  ) async {
    if (state.isLoading) return; // Prevent double-tap

    state = state.copyWith(isLoading: true, clearError: true, isSuccess: false);

    final result = await action();

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false, isSuccess: true);
        ref.invalidate(ownerReservationListProvider);
        final storeId = ref.read(ownerStateProvider).activeStore?.id;
        if (storeId != null) {
          ref.read(ownerStateProvider.notifier).loadDashboardMetrics(storeId);
        }
      case Failure(:final error):
        state = state.copyWith(isLoading: false, error: error.message);
    }
  }

  Future<void> confirmReservation(String reservationId) async {
    final repository = ref.read(ownerReservationRepositoryProvider);
    await _performAction(() => repository.confirmReservation(reservationId));
  }

  Future<void> rejectReservation(
    String reservationId, {
    required String reason,
  }) async {
    final repository = ref.read(ownerReservationRepositoryProvider);
    await _performAction(
      () => repository.rejectReservation(reservationId, reason: reason),
    );
  }

  Future<void> markReady(String id) async {
    await _performAction(
      () => ref.read(ownerReservationRepositoryProvider).markReady(id),
    );
  }

  Future<void> completePickup(String id) async {
    await _performAction(
      () =>
          ref.read(ownerReservationRepositoryProvider).completeReservation(id),
    );
  }
}

final ownerReservationActionProvider =
    NotifierProvider<
      OwnerReservationActionController,
      OwnerReservationActionState
    >(() => OwnerReservationActionController());

// Detail provider for single reservation
final ownerReservationDetailProvider = FutureProvider.autoDispose
    .family<OwnerReservation, String>((ref, id) async {
      // Ideally, the backend would have a GET /reservations/:id endpoint, but it wasn't listed in the controller.
      // We will instead try to find it in the current list.
      final listState = ref.read(ownerReservationListProvider);
      final found = listState.reservations
          .where((element) => element.id == id)
          .firstOrNull;
      if (found != null) return found;

      // If not found in cache, we could fetch from the backend if there was a getById endpoint.
      // For now, throw an exception since we only access detail from the list screen.
      throw Exception('Reservation not found');
    });
