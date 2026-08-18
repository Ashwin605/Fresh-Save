import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/domain/offer_card.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class AllNearbyDealsScreen extends ConsumerWidget {
  const AllNearbyDealsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(nearbyDealsProvider);

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
        title: Text('Nearby Deals', style: AppTypography.title),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(nearbyDealsProvider);
          await ref.read(nearbyDealsProvider.future);
        },
        child: dealsAsync.when(
          data: (deals) {
            if (deals.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 64,
                      color: AppColors.textDisabled.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No deals nearby',
                      style: AppTypography.title.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Check back later for discounted deals near you.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    FilledButton.icon(
                      onPressed: () => ref.invalidate(nearbyDealsProvider),
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
              itemCount: deals.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final deal = deals[index];
                return OfferCard(
                  productName: deal.productName,
                  storeName: deal.storeName,
                  originalPrice: deal.originalPrice,
                  discountedPrice: deal.discountedPrice,
                  discountPercent: deal.discountPercent,
                  expiryStatus: deal.expiryStatus,
                  stockStatus: deal.stockStatus,
                  imageUrl: deal.imageUrl,
                  onTap: () => context.push('/offer/${deal.id}'),
                );
              },
            );
          },
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: 5,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) => const AppSkeleton(
              width: double.infinity,
              height: 200,
              borderRadius: 16,
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
                Text('Failed to load deals', style: AppTypography.body),
                const SizedBox(height: AppSpacing.sm),
                FilledButton.icon(
                  onPressed: () => ref.invalidate(nearbyDealsProvider),
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
