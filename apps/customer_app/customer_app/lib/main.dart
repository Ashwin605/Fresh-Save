import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/theme/app_theme.dart';
import 'app/router/app_router.dart';
import 'core/storage/shared_prefs_provider.dart';
import 'core/storage/preferences_storage.dart';
import 'core/error/global_error_boundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // In production, send to crashlytics/sentry here
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    // In production, send to crashlytics/sentry here
    return true;
  };

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        preferencesStorageProvider.overrideWithValue(
          PreferencesStorage(sharedPrefs),
        ),
      ],
      child: const FreshSaveApp(),
    ),
  );
}

class FreshSaveApp extends ConsumerWidget {
  const FreshSaveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'FreshSave',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return GlobalErrorBoundary(child: child ?? const SizedBox());
      },
    );
  }
}
