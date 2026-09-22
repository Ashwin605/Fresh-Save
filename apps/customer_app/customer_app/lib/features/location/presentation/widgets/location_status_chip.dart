import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/location_models.dart';
import '../providers/location_provider.dart';

class LocationStatusChip extends ConsumerWidget {
  const LocationStatusChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(locationState),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              _buildText(locationState),
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 16,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(LocationState state) {
    if (state.status == LocationStatus.detecting) {
      return const SizedBox(
        width: 14,
        height: 14,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.primary,
        ),
      );
    }

    if (state.status == LocationStatus.available) {
      if (state.location?.source == LocationSource.manual) {
        return const Icon(
          Icons.location_city,
          size: 16,
          color: AppColors.primary,
        );
      }
      return const Icon(Icons.my_location, size: 16, color: AppColors.primary);
    }

    return const Icon(Icons.location_off, size: 16, color: AppColors.error);
  }

  String _buildText(LocationState state) {
    if (state.status == LocationStatus.detecting) {
      return 'Detecting...';
    }

    if (state.status == LocationStatus.available) {
      // Show the reverse-geocoded address name if available
      final addressName = state.location?.addressName;
      if (addressName != null && addressName.isNotEmpty) {
        return addressName;
      }

      // Fallback while reverse geocoding is in progress
      if (state.location?.source == LocationSource.manual) {
        return 'Using selected location';
      }
      return 'Using current location';
    }

    return 'Location unavailable';
  }
}
