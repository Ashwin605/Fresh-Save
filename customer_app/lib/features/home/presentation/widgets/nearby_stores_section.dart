import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../../../core/widgets/domain/store_card.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class NearbyStoresSection extends ConsumerWidget {
  const NearbyStoresSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storesAsync = ref.watch(nearbyStoresProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nearby Stores', style: AppTypography.title),
              InteractiveContainer(
                onTap: () => context.push('/stores/nearby'),
                child: Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fade(duration: AppAnimations.medium, delay: 600.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: AppSpacing.sm),
        storesAsync.when(
          data: (stores) {
            if (stores.isEmpty) return const SizedBox.shrink();

            final displayStores = stores.take(5).toList();

            return SizedBox(
              height: 220,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: displayStores.length,
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final store = displayStores[index];
                  return SizedBox(
                    width: 260,
                    child: StoreCard(
                      storeName: store.name,
                      imageUrl: store.logoUrl,
                      distance: store.distance != null
                          ? '${store.distance!.toStringAsFixed(1)} km'
                          : 'Nearby',
                      rating: store.rating,
                      onTap: () => context.push('/store/${store.id}'),
                    ),
                  ).animate().fade(
                    duration: AppAnimations.medium,
                    delay: Duration(milliseconds: 650 + (index * 100)),
                  ).slideX(begin: 0.1, end: 0);
                },
              ),
            );
          },
          loading: () => SizedBox(
            height: 220,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => const AppSkeleton(
                width: 260,
                height: 220,
                borderRadius: 16,
              ),
            ),
          ),
          error: (error, stack) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(height: 8),
                  Text('Failed to load stores', style: AppTypography.bodySmall),
                  TextButton(
                    onPressed: () => ref.invalidate(nearbyStoresProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
