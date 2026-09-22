import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../location/domain/models/location_models.dart';

class LocationExplanationScreen extends ConsumerWidget {
  const LocationExplanationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

    // Reactively route based on location state
    ref.listen<LocationState>(locationProvider, (previous, next) {
      if (next.status == LocationStatus.available) {
        context.push('/onboarding/location-success');
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassSurface(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: const Icon(
                        Icons.location_on_outlined,
                        size: 48,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Find deals near you',
                      style: AppTypography.display.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      'FreshSave needs your location to discover nearby stores offering discounted products and calculate exact distances.',
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                    _buildStatusArea(context, ref, locationState),
                  ],
                ),
              ),

              if (locationState.status != LocationStatus.detecting)
                AppButton.primary(
                  label: _getPrimaryLabel(locationState.status),
                  onPressed: () {
                    final notifier = ref.read(locationProvider.notifier);
                    if (locationState.status ==
                        LocationStatus.servicesDisabled) {
                      notifier.openSettingsForServicesDisabled();
                    } else if (locationState.status ==
                        LocationStatus.deniedForever) {
                      notifier.openSettingsForDeniedForever();
                    } else {
                      notifier.requestPermissionAndAcquire();
                    }
                  },
                ),

              if (locationState.status == LocationStatus.denied ||
                  locationState.status == LocationStatus.deniedForever ||
                  locationState.status == LocationStatus.error) ...[
                const SizedBox(height: AppSpacing.md),
                AppButton.glass(
                  label: 'Choose Location Manually',
                  onPressed: () =>
                      context.push('/onboarding/location-fallback'),
                ),
              ],

              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  String _getPrimaryLabel(LocationStatus status) {
    if (status == LocationStatus.servicesDisabled) {
      return 'Turn on Location Services';
    }
    if (status == LocationStatus.deniedForever) return 'Open Settings';
    if (status == LocationStatus.error) return 'Try Again';
    return 'Use My Location';
  }

  Widget _buildStatusArea(
    BuildContext context,
    WidgetRef ref,
    LocationState state,
  ) {
    if (state.status == LocationStatus.detecting) {
      return Center(
        child: Column(
          children: [
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Acquiring location...', style: AppTypography.body),
          ],
        ),
      );
    }

    if (state.errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: AppColors.error),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                state.errorMessage!,
                style: AppTypography.body.copyWith(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
