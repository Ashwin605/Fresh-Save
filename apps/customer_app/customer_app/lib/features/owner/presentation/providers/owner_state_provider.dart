import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/store_owner_models.dart';

import '../../data/repositories/owner_repository_impl.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';

enum OwnerContextState {
  initial,
  loading,
  noBusiness,
  noStore,
  hasStore,
  error,
}

class OwnerState {
  final OwnerContextState contextState;
  final OwnerBusiness? business;
  final List<OwnerStore> stores;
  final OwnerStore? activeStore;
  final DashboardMetrics? dashboardMetrics;
  final String? error;

  OwnerState({
    this.contextState = OwnerContextState.initial,
    this.business,
    this.stores = const [],
    this.activeStore,
    this.dashboardMetrics,
    this.error,
  });

  OwnerState copyWith({
    OwnerContextState? contextState,
    OwnerBusiness? business,
    List<OwnerStore>? stores,
    OwnerStore? activeStore,
    DashboardMetrics? dashboardMetrics,
    String? error,
    bool clearError = false,
  }) {
    return OwnerState(
      contextState: contextState ?? this.contextState,
      business: business ?? this.business,
      stores: stores ?? this.stores,
      activeStore: activeStore ?? this.activeStore,
      dashboardMetrics: dashboardMetrics ?? this.dashboardMetrics,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class OwnerNotifier extends Notifier<OwnerState> {
  @override
  OwnerState build() {
    // Automatically load context when authenticated as owner
    final authStatus = ref.watch(authStateProvider).status;
    if (authStatus == AuthStatus.authenticated) {
      Future.microtask(() => loadOwnerContext());
    }
    return OwnerState();
  }

  Future<void> loadOwnerContext() async {
    print('loadOwnerContext: starting');
    state = state.copyWith(
      contextState: OwnerContextState.loading,
      clearError: true,
    );
    final repo = ref.read(ownerRepositoryProvider);

    final businessResult = await repo.getMyBusiness();

    switch (businessResult) {
      case Success(:final data):
        print('loadOwnerContext: Success getting business');
        state = state.copyWith(business: data);
        await _loadStores(data.id);
      case Failure(:final error):
        print('loadOwnerContext: Failure getting business: ${error.message}');
        if (error.message?.contains('No business found') == true) {
          state = state.copyWith(contextState: OwnerContextState.noBusiness);
        } else {
          state = state.copyWith(
            contextState: OwnerContextState.error,
            error: error.message,
          );
        }
    }
  }

  Future<void> _loadStores(String businessId) async {
    print('[AUTH] _loadStores: starting for $businessId');
    final repo = ref.read(ownerRepositoryProvider);
    final storesResult = await repo.getBusinessStores(businessId);

    switch (storesResult) {
      case Success(:final data):
        print('[AUTH] _loadStores: Success, found ${data.length} stores');
        if (data.isNotEmpty) {
          state = state.copyWith(
            stores: data,
            activeStore: data.first,
            contextState: OwnerContextState.hasStore,
          );
          // Load dashboard metrics AFTER navigation — don't block it
          // ignore: unawaited_futures
          loadDashboardMetrics(data.first.id);
        } else {
          state = state.copyWith(
            contextState: OwnerContextState.noStore,
            stores: [],
          );
        }
      case Failure(:final error):
        state = state.copyWith(
          contextState: OwnerContextState.error,
          error: error.message,
        );
    }
  }

  Future<void> loadDashboardMetrics(String storeId) async {
    // We do not change contextState here, as they already have a store.
    state = state.copyWith(clearError: true);
    final repo = ref.read(ownerRepositoryProvider);
    final result = await repo.getDashboardMetrics(storeId);

    switch (result) {
      case Success(:final data):
        state = state.copyWith(dashboardMetrics: data);
      case Failure(:final error):
        state = state.copyWith(error: error.message);
    }
  }

  Future<void> switchActiveStore(OwnerStore store) async {
    state = state.copyWith(activeStore: store, dashboardMetrics: null);
    await loadDashboardMetrics(store.id);
  }

  Future<void> updateBusiness(UpdateBusinessRequest request) async {
    final businessId = state.business?.id;
    if (businessId == null) return;

    final repo = ref.read(ownerRepositoryProvider);
    final result = await repo.updateBusiness(businessId, request);

    switch (result) {
      case Success(:final data):
        state = state.copyWith(business: data, clearError: true);
      case Failure(:final error):
        throw error;
    }
  }

  Future<void> updateStore(UpdateStoreRequest request) async {
    final storeId = state.activeStore?.id;
    if (storeId == null) return;

    final repo = ref.read(ownerRepositoryProvider);
    final result = await repo.updateStore(storeId, request);

    switch (result) {
      case Success(:final data):
        final updatedStores = state.stores
            .map((s) => s.id == data.id ? data : s)
            .toList();
        state = state.copyWith(
          activeStore: data,
          stores: updatedStores,
          clearError: true,
        );
      case Failure(:final error):
        throw error;
    }
  }
}

final ownerStateProvider = NotifierProvider<OwnerNotifier, OwnerState>(() {
  return OwnerNotifier();
});
