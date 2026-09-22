import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_reservation_models.dart';
import '../../data/repositories/owner_reservation_repository_provider.dart';
import 'owner_state_provider.dart';

class OwnerReservationListFilter {
  final ReservationStatus? status;
  final String? reservationCode;

  const OwnerReservationListFilter({this.status, this.reservationCode});

  OwnerReservationListFilter copyWith({
    ReservationStatus? status,
    bool clearStatus = false,
    String? reservationCode,
    bool clearReservationCode = false,
  }) {
    return OwnerReservationListFilter(
      status: clearStatus ? null : status ?? this.status,
      reservationCode: clearReservationCode
          ? null
          : reservationCode ?? this.reservationCode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OwnerReservationListFilter &&
        other.status == status &&
        other.reservationCode == reservationCode;
  }

  @override
  int get hashCode => status.hashCode ^ reservationCode.hashCode;
}

class OwnerReservationListState {
  final List<OwnerReservation> reservations;
  final bool isLoading;
  final bool isPaginating;
  final String? error;
  final OwnerReservationListFilter filter;
  final OwnerReservationPaginationMeta? meta;

  const OwnerReservationListState({
    this.reservations = const [],
    this.isLoading = false,
    this.isPaginating = false,
    this.error,
    this.filter = const OwnerReservationListFilter(),
    this.meta,
  });

  OwnerReservationListState copyWith({
    List<OwnerReservation>? reservations,
    bool? isLoading,
    bool? isPaginating,
    String? error,
    bool clearError = false,
    OwnerReservationListFilter? filter,
    OwnerReservationPaginationMeta? meta,
  }) {
    return OwnerReservationListState(
      reservations: reservations ?? this.reservations,
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      error: clearError ? null : error ?? this.error,
      filter: filter ?? this.filter,
      meta: meta ?? this.meta,
    );
  }
}

class OwnerReservationListController
    extends Notifier<OwnerReservationListState> {
  Timer? _debounceTimer;

  @override
  OwnerReservationListState build() {
    // Reload when active store changes
    ref.listen(ownerStateProvider.select((state) => state.activeStore?.id), (
      prev,
      next,
    ) {
      if (next != null && next != prev) {
        // Clear previous store data to prevent leakage
        state = state.copyWith(reservations: [], meta: null);
        refresh();
      }
    });

    // Initial load
    Future.microtask(() => _fetchReservations(isInitial: true));

    return const OwnerReservationListState(isLoading: true);
  }

  Future<void> _fetchReservations({
    bool isInitial = false,
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    final storeId = ref.read(ownerStateProvider).activeStore?.id;
    if (storeId == null) {
      state = state.copyWith(
        error: 'No active store selected',
        isLoading: false,
        isPaginating: false,
      );
      return;
    }

    if (isInitial || isRefresh) {
      state = state.copyWith(isLoading: true, clearError: true);
    } else if (isLoadMore) {
      state = state.copyWith(isPaginating: true, clearError: true);
    }

    final page = isLoadMore ? (state.meta?.page ?? 0) + 1 : 1;
    final repository = ref.read(ownerReservationRepositoryProvider);

    final result = await repository.getStoreReservations(
      storeId: storeId,
      page: page,
      status: state.filter.status,
      reservationCode: state.filter.reservationCode,
    );

    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          reservations: isLoadMore
              ? [...state.reservations, ...data.items]
              : data.items,
          meta: data.meta,
          isLoading: false,
          isPaginating: false,
        );
      case Failure(:final error):
        state = state.copyWith(
          error: error.message,
          isLoading: false,
          isPaginating: false,
        );
    }
  }

  Future<void> refresh() => _fetchReservations(isRefresh: true);

  Future<void> loadMore() async {
    if (state.isLoading || state.isPaginating) return;
    if (state.meta == null || !state.meta!.hasNextPage) return;
    await _fetchReservations(isLoadMore: true);
  }

  void updateFilter(OwnerReservationListFilter filter) {
    if (state.filter == filter) return;
    state = state.copyWith(filter: filter);
    _fetchReservations(isInitial: true);
  }

  void searchByCode(String code) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final updatedFilter = state.filter.copyWith(
        reservationCode: code.isEmpty ? null : code,
        clearReservationCode: code.isEmpty,
      );
      updateFilter(updatedFilter);
    });
  }

  void setStatusFilter(ReservationStatus? status) {
    final updatedFilter = state.filter.copyWith(
      status: status,
      clearStatus: status == null,
    );
    updateFilter(updatedFilter);
  }
}

final ownerReservationListProvider =
    NotifierProvider<OwnerReservationListController, OwnerReservationListState>(
      () => OwnerReservationListController(),
    );
