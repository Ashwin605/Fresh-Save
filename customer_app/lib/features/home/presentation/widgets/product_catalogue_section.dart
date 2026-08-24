import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/domain/product_card.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class ProductCatalogueSection extends ConsumerWidget {
  const ProductCatalogueSection({super.key});

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
              Text('Product Catalogue', style: AppTypography.title),
              TextButton(
                onPressed: () => context.push('/products/nearby'),
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
        dealsAsync.when(
          data: (deals) {
            if (deals.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 48, color: AppColors.textDisabled),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No products available nearby yet.',
                        style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Exclude deals that are in the promotional banner (top 5) to avoid duplication
            // But since deals list might be short, let's just show them all for now or skip the first 5
            final catalogDeals = deals.skip(5).toList();
            final displayDeals = catalogDeals.isNotEmpty ? catalogDeals : deals;

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.68,
              ),
              itemCount: displayDeals.length,
              itemBuilder: (context, index) {
                final deal = displayDeals[index];
                return ProductCard(
                  id: deal.id,
                  name: deal.productName,
                  brand: null, // Deals don't have brand directly yet, could add it
                  storeName: deal.storeName,
                  imageUrl: deal.imageUrl,
                  originalPrice: deal.originalPrice,
                  discountedPrice: deal.discountedPrice,
                  offerBadge: '${deal.discountPercent.toStringAsFixed(0)}% OFF',
                  onTap: () => context.push('/offer/${deal.id}'),
                  onAdd: () {
                    // TODO: Implement cart integration
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${deal.productName} to cart')),
                    );
                  },
                );
              },
            );
          },
          loading: () => GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.68,
            ),
            itemCount: 4,
            itemBuilder: (context, index) => const AppSkeleton(
              width: double.infinity,
              height: double.infinity,
              borderRadius: 16,
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
                  Text('Failed to load products', style: AppTypography.bodySmall),
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
