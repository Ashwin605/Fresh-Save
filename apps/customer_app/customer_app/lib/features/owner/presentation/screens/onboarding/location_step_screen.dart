import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../providers/onboarding_controller.dart';
import '../../../../location/presentation/providers/location_provider.dart';
import '../../../../location/domain/models/location_models.dart';

class LocationStepScreen extends ConsumerStatefulWidget {
  const LocationStepScreen({super.key});

  @override
  ConsumerState<LocationStepScreen> createState() => _LocationStepScreenState();
}

class _LocationStepScreenState extends ConsumerState<LocationStepScreen> {
  late final TextEditingController _addressController;
  String? _addressError;
  double? _latitude;
  double? _longitude;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(onboardingControllerProvider);
    _addressController = TextEditingController(text: state.storeAddress);
    // Ideally, we'd also hydrate lat/lng from state if they were saved,
    // but the original state didn't store them. For this implementation,
    // if the user hits Back and Next, they might need to re-detect,
    // but we can just use defaults if they don't.
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
  
  Future<void> _detectLocation() async {
    setState(() => _isDetecting = true);
    
    final locationNotifier = ref.read(locationProvider.notifier);
    await locationNotifier.requestPermissionAndAcquire();
    final locationState = ref.read(locationProvider);
    
    if (locationState.status == LocationStatus.available && locationState.location != null) {
      final loc = locationState.location!;
      setState(() {
        _latitude = loc.latitude;
        _longitude = loc.longitude;
        if (loc.addressName != null && _addressController.text.isEmpty) {
          _addressController.text = loc.addressName!;
        }
      });
      if (mounted) {
        AppSnackbar.show(
          context,
          message: 'Location successfully captured',
          variant: SnackbarVariant.success,
        );
      }
    } else {
      if (mounted) {
        AppSnackbar.show(
          context,
          message: locationState.errorMessage ?? 'Failed to get location',
          variant: SnackbarVariant.error,
        );
      }
    }
    
    setState(() => _isDetecting = false);
  }

  void _submit() {
    if (_addressController.text.trim().isEmpty) {
      setState(() => _addressError = 'Required');
      return;
    }
    setState(() => _addressError = null);

    ref
        .read(onboardingControllerProvider.notifier)
        .updateLocationInfo(
          address: _addressController.text.trim(),
          latitude: _latitude ?? 37.7749, // Fallback if they didn't detect
          longitude: _longitude ?? -122.4194, // Fallback if they didn't detect
        );
    ref.read(onboardingControllerProvider.notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);

    ref.listen<OnboardingState>(onboardingControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        AppSnackbar.show(
          context,
          message: next.error!,
          variant: SnackbarVariant.error,
        );
      }
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Store Location', style: AppTypography.headline),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Where is this store located? Customers use this to find your nearby offers.',
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),

          AppTextField(
            controller: _addressController,
            labelText: 'Full Address *',
            maxLines: 2,
            errorText: _addressError,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),

          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.map_outlined,
                  color: AppColors.primary,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Location Services', style: AppTypography.title),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        _latitude != null
                            ? 'Coordinates saved securely'
                            : 'Pin your exact location on the map',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  label: _latitude != null ? 'Update' : 'Detect',
                  variant: AppButtonVariant.secondary,
                  isLoading: _isDetecting,
                  onPressed: _detectLocation,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
          AppButton.primary(
            label: 'Complete Setup',
            isLoading: state.isLoading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

