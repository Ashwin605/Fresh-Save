import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../network/network_status_provider.dart';

class GlobalErrorBoundary extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalErrorBoundary({super.key, required this.child});

  @override
  ConsumerState<GlobalErrorBoundary> createState() =>
      _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends ConsumerState<GlobalErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();
    // In a real app, you would listen to an error stream here if you want to catch
    // async errors that aren't caught by the framework.
    // However, since we're using a builder in MaterialApp, we can catch rendering errors
    // below this widget. But for flutter framework errors, they are caught by FlutterError.onError
    // We will rely on main.dart for global unhandled errors, and this widget for UI boundary.
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorDetails?.exceptionAsString() ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _errorDetails = null;
                    });
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Global offline banner for customer app (Owner shell has its own, but we can put it here for both!)
    final networkStatus = ref.watch(networkStatusProvider);
    final isOffline = networkStatus == NetworkStatus.offline;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          if (isOffline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  color: AppColors.error,
                  padding: EdgeInsets.only(
                    top: MediaQuery.paddingOf(context).top + 4,
                    bottom: 4,
                  ),
                  child: const Text(
                    'You\'re offline. Some information may be outdated.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
