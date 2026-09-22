import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/domain/offer_card.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../providers/discovery_provider.dart';
import '../../domain/models/discovery_state.dart';

class DiscoveryResults extends ConsumerWidget {
  const DiscoveryResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoveryProvider);
    final notifier = ref.read(discoveryProvider.notifier);

    if (state.status == DiscoveryStatus.error && state.deals.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.sm),
              Text('Couldn\'t load nearby deals.', style: AppTypography.title),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  state.errorMessage!,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Retry',
                onPressed: () => notifier.fetchInitial(),
              ),
            ],
          ),
        ),
      );
    }

    if (state.status == DiscoveryStatus.loading && state.deals.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 0.65,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => const AppSkeleton(
              width: double.infinity,
              height: 280,
              borderRadius: 16,
            ),
            childCount: 6,
          ),
        ),
      );
    }

    if (state.deals.isEmpty) {
      final hasFilters = state.filters.hasActiveFilters;
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 48,
                color: AppColors.textDisabled,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                hasFilters
                    ? 'No deals match these filters.'
                    : 'No discounted deals nearby yet.',
                style: AppTypography.title,
              ),
              const SizedBox(height: AppSpacing.md),
              if (hasFilters)
                AppButton(
                  label: 'Clear Filters',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => notifier.clearFilters(),
                )
              else
                AppButton(
                  label: 'Change Location',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.push('/location-selector'),
                ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
        bottom: 100,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            if (index == state.deals.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final deal = state.deals[index];
            return OfferCard(
              productName: deal.productName,
              storeName: deal.storeName,
              originalPrice: deal.originalPrice,
              discountedPrice: deal.discountedPrice,
              discountPercent: deal.discountPercent,
              expiryStatus: deal.expiryStatus,
              stockStatus: deal.stockStatus,
              imageUrl: deal.imageUrl,
              distance: deal.distance != null
                  ? '${deal.distance!.toStringAsFixed(1)} km'
                  : null,
              onTap: () => context.push('/offer/${deal.id}'),
            );
          },
          childCount:
              state.deals.length +
              (state.status == DiscoveryStatus.loadingMore ? 1 : 0),
        ),
      ),
    );
  }
}
