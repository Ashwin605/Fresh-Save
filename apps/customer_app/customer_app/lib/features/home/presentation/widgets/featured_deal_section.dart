import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/chips_badges/discount_badge.dart';
import '../providers/home_providers.dart';

class FeaturedDealSection extends ConsumerWidget {
  const FeaturedDealSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dealAsync = ref.watch(featuredDealProvider);

    return dealAsync.when(
      data: (deal) {
        if (deal == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: GestureDetector(
            onTap: () => context.push('/offer/${deal.id}'),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image
                    if (deal.imageUrl != null)
                      AppNetworkImage(
                        imageUrl: deal.imageUrl!,
                        fit: BoxFit.cover,
                        borderRadius: AppRadius.lg,
                      )
                    else
                      Container(color: AppColors.surfaceVariant),

                    // Translucent overlay for text readability
                    Container(color: Colors.black.withValues(alpha: 0.3)),

                    // Top Badge
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: DiscountBadge(
                        discountPercent: deal.discountPercent,
                      ),
                    ),

                    // Featured Label
                    Positioned(
                      top: AppSpacing.md,
                      left: AppSpacing.md,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            color: Colors.white.withValues(alpha: 0.2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Featured',
                                  style: AppTypography.label.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Content
                    Positioned(
                      bottom: AppSpacing.md,
                      left: AppSpacing.md,
                      right: AppSpacing.md,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            deal.productName,
                            style: AppTypography.title.copyWith(
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                deal.storeName,
                                style: AppTypography.bodySmall.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '₹${deal.discountedPrice.toStringAsFixed(2)}',
                                style: AppTypography.title.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: AppSkeleton(
          width: double.infinity,
          height: 200,
          borderRadius: AppRadius.lg,
        ),
      ),
      error: (error, stack) =>
          const SizedBox.shrink(), // Silently fail for featured deal
    );
  }
}
