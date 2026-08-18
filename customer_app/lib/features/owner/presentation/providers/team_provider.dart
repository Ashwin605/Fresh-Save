import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/team_models.dart';
import '../../data/repositories/team_repository_impl.dart';
import 'owner_state_provider.dart';

class TeamState {
  final bool isLoading;
  final String? error;
  final List<StoreStaff> staff;

  const TeamState({this.isLoading = false, this.error, this.staff = const []});

  TeamState copyWith({
    bool? isLoading,
    String? error,
    List<StoreStaff>? staff,
    bool clearError = false,
  }) {
    return TeamState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      staff: staff ?? this.staff,
    );
  }
}

class TeamNotifier extends Notifier<TeamState> {
  @override
  TeamState build() {
    // Watch active store so the provider rebuilds automatically on change
    final activeStore = ref.watch(
      ownerStateProvider.select((s) => s.activeStore),
    );

    if (activeStore != null) {
      Future.microtask(() => _fetch(activeStore.id));
      return const TeamState(isLoading: true);
    }

    return const TeamState(
      isLoading: false,
      error: 'No active store selected.',
    );
  }

  Future<void> _fetch(String storeId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(teamRepositoryProvider);
    final result = await repo.getStoreStaff(storeId);

    if (result is Success<List<StoreStaff>>) {
      state = state.copyWith(isLoading: false, staff: result.data);
    } else if (result is Failure<List<StoreStaff>>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
    }
  }

  Future<void> refresh() async {
    final activeStore = ref.read(ownerStateProvider).activeStore;
    if (activeStore != null) {
      await _fetch(activeStore.id);
    }
  }

  Future<bool> addStaff(String email) async {
    final activeStore = ref.read(ownerStateProvider).activeStore;
    if (activeStore == null) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(teamRepositoryProvider);
    final result = await repo.addStaffMember(activeStore.id, email);

    if (result is Success<StoreStaff>) {
      // Reload the list to get full populated data
      await _fetch(activeStore.id);
      return true;
    } else if (result is Failure<StoreStaff>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
      return false;
    }
    return false;
  }

  Future<bool> removeStaff(String staffId) async {
    final activeStore = ref.read(ownerStateProvider).activeStore;
    if (activeStore == null) return false;

    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(teamRepositoryProvider);
    final result = await repo.removeStaffMember(activeStore.id, staffId);

    if (result is Success<void>) {
      state = state.copyWith(
        isLoading: false,
        staff: state.staff.where((s) => s.id != staffId).toList(),
      );
      return true;
    } else if (result is Failure<void>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
      return false;
    }
    return false;
  }
}

final teamProvider = NotifierProvider<TeamNotifier, TeamState>(() {
  return TeamNotifier();
});
