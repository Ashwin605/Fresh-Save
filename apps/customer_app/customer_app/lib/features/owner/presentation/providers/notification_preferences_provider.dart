import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../notifications/domain/models/notification_preference_models.dart';
import '../../../notifications/data/repositories/notification_preferences_repository.dart';

class NotificationPreferencesState {
  final bool isLoading;
  final String? error;
  final NotificationPreference? preferences;

  const NotificationPreferencesState({
    this.isLoading = false,
    this.error,
    this.preferences,
  });

  NotificationPreferencesState copyWith({
    bool? isLoading,
    String? error,
    NotificationPreference? preferences,
    bool clearError = false,
  }) {
    return NotificationPreferencesState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      preferences: preferences ?? this.preferences,
    );
  }
}

class NotificationPreferencesNotifier
    extends Notifier<NotificationPreferencesState> {
  @override
  NotificationPreferencesState build() {
    Future.microtask(() => _fetch());
    return const NotificationPreferencesState(isLoading: true);
  }

  Future<void> _fetch() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(notificationPreferencesRepositoryProvider);
    final result = await repo.getPreferences();

    if (result is Success<NotificationPreference>) {
      state = state.copyWith(isLoading: false, preferences: result.data);
    } else if (result is Failure<NotificationPreference>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
    }
  }

  Future<void> refresh() async {
    await _fetch();
  }

  Future<bool> updatePreference(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final repo = ref.read(notificationPreferencesRepositoryProvider);

    // Optimistic UI update or just wait for network
    final result = await repo.updatePreferences(data);

    if (result is Success<NotificationPreference>) {
      state = state.copyWith(isLoading: false, preferences: result.data);
      return true;
    } else if (result is Failure<NotificationPreference>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
      return false;
    }
    return false;
  }
}

final notificationPreferencesProvider =
    NotifierProvider<
      NotificationPreferencesNotifier,
      NotificationPreferencesState
    >(() {
      return NotificationPreferencesNotifier();
    });
