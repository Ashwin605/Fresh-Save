import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/domain/offer_card.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class NearbyDealsSection extends ConsumerWidget {
  const NearbyDealsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealsAsync = ref.watch(nearbyDealsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Nearby Deals', style: AppTypography.title),
              TextButton(
                onPressed: () => context.push('/deals/nearby'),
                child: Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 290, // Sufficient height for OfferCard
          child: dealsAsync.when(
            data: (deals) {
              if (deals.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_offer_outlined,
                          size: 48,
                          color: AppColors.textDisabled,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'No discounted deals nearby yet.',
                          style: AppTypography.body,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                scrollDirection: Axis.horizontal,
                itemCount: deals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final deal = deals[index];
                  return SizedBox(
                    width: 240, // Fixed width for horizontal scrolling
                    child: OfferCard(
                      productName: deal.productName,
                      storeName: deal.storeName,
                      originalPrice: deal.originalPrice,
                      discountedPrice: deal.discountedPrice,
                      discountPercent: deal.discountPercent,
                      expiryStatus: deal.expiryStatus,
                      stockStatus: deal.stockStatus,
                      imageUrl: deal.imageUrl,
                      onTap: () => context.push('/offer/${deal.id}'),
                    ),
                  );
                },
              );
            },
            loading: () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) =>
                  const AppSkeleton(width: 240, height: 280, borderRadius: 16),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error),
                  const SizedBox(height: 8),
                  Text('Failed to load deals', style: AppTypography.bodySmall),
                  TextButton(
                    onPressed: () => ref.invalidate(nearbyDealsProvider),
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
