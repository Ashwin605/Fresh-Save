import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final preferencesStorageProvider = Provider<PreferencesStorage>((ref) {
  throw UnimplementedError(
    'preferencesStorageProvider must be overridden in main',
  );
});

class PreferencesStorage {
  final SharedPreferences _prefs;

  PreferencesStorage(this._prefs);

  static const _keySearchRadius = 'pref_search_radius';
  static const _keyReducedMotion = 'pref_reduced_motion';
  static const _keyTheme = 'pref_theme';

  // --- Search Radius ---
  double get searchRadius =>
      _prefs.getDouble(_keySearchRadius) ?? 5.0; // Default 5 km

  Future<void> setSearchRadius(double radius) async {
    await _prefs.setDouble(_keySearchRadius, radius);
  }

  // --- Reduced Motion ---
  bool get reducedMotion => _prefs.getBool(_keyReducedMotion) ?? false;

  Future<void> setReducedMotion(bool enabled) async {
    await _prefs.setBool(_keyReducedMotion, enabled);
  }

  // --- Theme ---
  String get themeMode => _prefs.getString(_keyTheme) ?? 'system';

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_keyTheme, mode);
  }
}
