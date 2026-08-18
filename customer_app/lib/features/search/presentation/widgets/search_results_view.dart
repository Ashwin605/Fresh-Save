import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/domain/offer_card.dart';
import '../../../../core/widgets/domain/store_card.dart';
import '../../../../core/widgets/feedback/empty_state_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../providers/search_provider.dart';
import '../../domain/models/search_state.dart';

class SearchResultsView extends ConsumerWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);

    if (state.status == SearchStatus.searching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == SearchStatus.error) {
      return AppErrorView(
        message: state.errorMessage ?? 'Search failed',
        onRetry: () => notifier.executeSearch(state.query),
      );
    }

    if (state.status == SearchStatus.empty) {
      return EmptyStateView(
        icon: Icons.search_off_rounded,
        title: 'No results found',
        description: 'We couldn\'t find anything for "${state.query}". Try a different keyword.',
        actionLabel: 'Clear Search',
        onAction: () => notifier.clearSearch(),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      physics: const BouncingScrollPhysics(),
      children: [
        if (state.deals.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text('Deals', style: AppTypography.title),
          ),
          const SizedBox(height: AppSpacing.sm),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.65,
            ),
            itemCount: state.deals.length,
            itemBuilder: (context, index) {
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
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        if (state.stores.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text('Stores', style: AppTypography.title),
          ),
          const SizedBox(height: AppSpacing.sm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: state.stores.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final store = state.stores[index];
              return StoreCard(
                storeName: store.name,
                imageUrl: store.logoUrl,
                distance: store.distance != null
                    ? '${store.distance!.toStringAsFixed(1)} km'
                    : '',
                rating: store.rating,
                onTap: () => context.push('/store/${store.id}'),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        if (state.products.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Text('Products', style: AppTypography.title),
          ),
          const SizedBox(height: AppSpacing.sm),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: state.products.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ListTile(
                onTap: () => context.push('/product/${product.id}'),
                tileColor: AppColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: product.image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: AppNetworkImage(
                            imageUrl: product.image!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.fastfood,
                          color: AppColors.textDisabled,
                        ),
                ),
                title: Text(product.name, style: AppTypography.body),
                subtitle: Text(
                  product.brand ?? 'Generic',
                  style: AppTypography.bodySmall,
                ),
                trailing: const Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
