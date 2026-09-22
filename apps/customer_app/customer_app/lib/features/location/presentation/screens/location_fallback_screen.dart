import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/inputs/app_text_field.dart';
import '../providers/location_provider.dart';
import '../../data/services/location_service.dart';

class LocationFallbackScreen extends ConsumerStatefulWidget {
  const LocationFallbackScreen({super.key});

  @override
  ConsumerState<LocationFallbackScreen> createState() =>
      _LocationFallbackScreenState();
}

class _LocationFallbackScreenState
    extends ConsumerState<LocationFallbackScreen> {
  final _searchController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    FocusScope.of(context).unfocus();

    try {
      final service = ref.read(locationServiceProvider);
      final loc = await service.forwardGeocode(query);

      if (loc != null) {
        ref.read(locationProvider.notifier).setManualLocation(
              loc.latitude,
              loc.longitude,
              addressName: query,
            );
        if (mounted) context.pop();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not find location. Please try another city name.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Choose Location', style: AppTypography.headline),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your city or locality to discover nearby deals.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _searchController,
              labelText: 'Search for a city',
              prefixIcon: const Icon(Icons.search),
              onSubmitted: (_) => _searchLocation(),
            ),
            const SizedBox(height: AppSpacing.md),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),

            const Spacer(),
            AppButton.primary(
              label: 'Set Location',
              onPressed: _isLoading ? () {} : _searchLocation,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }
}
