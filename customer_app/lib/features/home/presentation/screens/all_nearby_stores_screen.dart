import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/domain/store_card.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class AllNearbyStoresScreen extends ConsumerWidget {
  const AllNearbyStoresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(nearbyStoresProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Nearby Stores', style: AppTypography.title),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(nearbyStoresProvider);
          await ref.read(nearbyStoresProvider.future);
        },
        child: storesAsync.when(
          data: (stores) {
            if (stores.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.store_outlined,
                      size: 64,
                      color: AppColors.textDisabled.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No stores nearby',
                      style: AppTypography.title.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'We couldn\'t find any stores near your location.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(nearbyStoresProvider),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Refresh'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: stores.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final store = stores[index];
                return StoreCard(
                  storeName: store.name,
                  imageUrl: store.logoUrl,
                  distance: store.distance != null
                      ? '${store.distance!.toStringAsFixed(1)} km'
                      : 'Nearby',
                  rating: store.rating,
                  onTap: () => context.push('/store/${store.id}'),
                );
              },
            );
          },
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) => const AppSkeleton(
              width: double.infinity,
              height: 80,
              borderRadius: 12,
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: 48,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('Failed to load stores', style: AppTypography.body),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(nearbyStoresProvider),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Retry'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
