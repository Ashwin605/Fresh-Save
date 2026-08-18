import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_radius.dart';
import '../../providers/owner_state_provider.dart';

class StoreIdentitySection extends ConsumerWidget {
  const StoreIdentitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(ownerStateProvider).activeStore;
    if (store == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cover Image
          Container(
            height: 120,
            color: AppColors.surfaceVariant,
            child: store.coverImage != null
                ? Image.network(store.coverImage!, fit: BoxFit.cover)
                : const Center(
                    child: Icon(
                      Icons.image,
                      color: AppColors.textDisabled,
                      size: 48,
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                // Logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 3),
                  ),
                  child: store.logo != null
                      ? ClipOval(
                          child: Image.network(store.logo!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Icon(
                            Icons.store,
                            color: AppColors.textDisabled,
                          ),
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.name, style: AppTypography.title),
                      const SizedBox(height: AppSpacing.xs),
                      _buildStatusBadge(store.status),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        color = AppColors.success;
      case 'SUSPENDED':
        color = AppColors.error;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTypography.label.copyWith(color: color, fontSize: 10),
      ),
    );
  }
}
