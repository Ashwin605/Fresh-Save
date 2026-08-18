import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/notification_preference_models.dart';
import '../../data/repositories/notification_preferences_repository.dart';
import '../../../../core/network/result.dart';

class NotificationPreferencesNotifier
    extends AsyncNotifier<NotificationPreferences> {
  @override
  Future<NotificationPreferences> build() async {
    return _fetch();
  }

  Future<NotificationPreferences> _fetch() async {
    final repo = ref.read(notificationPreferencesRepositoryProvider);
    final result = await repo.getPreferences();
    if (result is Success<NotificationPreferences>) {
      return result.data;
    } else {
      throw Exception('Failed to load preferences');
    }
  }

  Future<void> updatePreferences(NotificationPreferences newPrefs) async {
    final current = state.value;
    if (current == null) return;

    // Optimistic UI update
    state = AsyncValue.data(newPrefs);

    final repo = ref.read(notificationPreferencesRepositoryProvider);
    final result = await repo.updatePreferences(newPrefs);

    if (result is Failure<NotificationPreferences>) {
      // Rollback on failure
      state = AsyncValue.data(current);
      // We could also trigger a snackbar here by throwing an error or letting the UI catch it,
      // but for now we rollback gracefully.
      throw Exception('Failed to update preferences');
    }
  }

  Future<void> togglePush(bool enabled) async {
    if (state.value != null) {
      await updatePreferences(state.value!.copyWith(pushEnabled: enabled));
    }
  }

  Future<void> toggleEmail(bool enabled) async {
    if (state.value != null) {
      await updatePreferences(state.value!.copyWith(emailEnabled: enabled));
    }
  }

  Future<void> toggleInApp(bool enabled) async {
    if (state.value != null) {
      await updatePreferences(state.value!.copyWith(inAppEnabled: enabled));
    }
  }

  Future<void> toggleReservationUpdates(bool enabled) async {
    if (state.value != null) {
      await updatePreferences(
        state.value!.copyWith(reservationUpdates: enabled),
      );
    }
  }

  Future<void> toggleOfferAlerts(bool enabled) async {
    if (state.value != null) {
      await updatePreferences(state.value!.copyWith(offerAlerts: enabled));
    }
  }
}

final notificationPreferencesProvider =
    AsyncNotifierProvider<
      NotificationPreferencesNotifier,
      NotificationPreferences
    >(() {
      return NotificationPreferencesNotifier();
    });
