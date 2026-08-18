import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/preferences_storage.dart';

class AppPreferencesState {
  final double searchRadius;
  final bool reducedMotion;
  final String themeMode;

  const AppPreferencesState({
    required this.searchRadius,
    required this.reducedMotion,
    required this.themeMode,
  });

  AppPreferencesState copyWith({
    double? searchRadius,
    bool? reducedMotion,
    String? themeMode,
  }) {
    return AppPreferencesState(
      searchRadius: searchRadius ?? this.searchRadius,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppPreferencesNotifier extends Notifier<AppPreferencesState> {
  @override
  AppPreferencesState build() {
    final storage = ref.watch(preferencesStorageProvider);
    return AppPreferencesState(
      searchRadius: storage.searchRadius,
      reducedMotion: storage.reducedMotion,
      themeMode: storage.themeMode,
    );
  }

  Future<void> updateSearchRadius(double radius) async {
    await ref.read(preferencesStorageProvider).setSearchRadius(radius);
    state = state.copyWith(searchRadius: radius);
  }

  Future<void> toggleReducedMotion(bool enabled) async {
    await ref.read(preferencesStorageProvider).setReducedMotion(enabled);
    state = state.copyWith(reducedMotion: enabled);
  }

  Future<void> updateThemeMode(String mode) async {
    await ref.read(preferencesStorageProvider).setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }
}

final appPreferencesProvider =
    NotifierProvider<AppPreferencesNotifier, AppPreferencesState>(() {
      return AppPreferencesNotifier();
    });
