import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/chips_badges/expiry_badge.dart';
import '../../../../core/widgets/chips_badges/discount_badge.dart';
import '../../../../core/widgets/chips_badges/distance_badge.dart';
import '../../../../core/widgets/domain/stock_indicator.dart';
import '../providers/details_providers.dart';
import '../../domain/models/details_models.dart';

class OfferDetailsScreen extends ConsumerWidget {
  final String offerId;

  const OfferDetailsScreen({super.key, required this.offerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerAsync = ref.watch(offerDetailsProvider(offerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: offerAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => AppErrorView(
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.invalidate(offerDetailsProvider(offerId)),
        ),
        data: (deal) => _buildContent(context, deal),
      ),
      bottomNavigationBar: offerAsync.hasValue
          ? _buildStickyCTA(context, offerAsync.value!)
          : null,
    );
  }

  Widget _buildContent(BuildContext context, DealDetail deal) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context, deal),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(deal),
                const SizedBox(height: AppSpacing.xl),
                _buildPriceSection(deal),
                const SizedBox(height: AppSpacing.xl),
                _buildStatusSection(deal),
                const SizedBox(height: AppSpacing.xl),
                _buildStoreSection(context, deal),
                const SizedBox(height: AppSpacing.xl),
                if (deal.offer.description != null) ...[
                  _buildDescriptionSection(deal),
                  const SizedBox(
                    height: AppSpacing.xxl * 2,
                  ), // Space for bottom CTA
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, DealDetail deal) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GlassSurface(
          borderRadius: 100.0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GlassSurface(
            borderRadius: 100.0,
            child: IconButton(
              icon: const Icon(
                Icons.share_outlined,
                color: AppColors.textPrimary,
              ),
              onPressed: () {},
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: deal.product.image != null
            ? AppNetworkImage(imageUrl: deal.product.image!, fit: BoxFit.cover)
            : Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.fastfood,
                  size: 64,
                  color: AppColors.textDisabled,
                ),
              ),
      ),
    );
  }

  Widget _buildHeader(DealDetail deal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (deal.product.brand != null)
          Text(
            deal.product.brand!.toUpperCase(),
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(deal.product.name, style: AppTypography.headline),
        const SizedBox(height: AppSpacing.sm),
        if (deal.offer.title != null)
          Text(
            deal.offer.title!,
            style: AppTypography.body.copyWith(color: AppColors.primary),
          ),
      ],
    );
  }

  Widget _buildPriceSection(DealDetail deal) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${deal.offer.originalPrice.toStringAsFixed(2)}',
                    style: AppTypography.title.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: AppColors.textDisabled,
                    ),
                  ),
                  Text(
                    '₹${deal.offer.discountedPrice.toStringAsFixed(2)}',
                    style: AppTypography.display.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              DiscountBadge(discountPercent: deal.offer.discountValue),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              'You save ₹${deal.offer.discountAmount.toStringAsFixed(2)}!',
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(DealDetail deal) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Availability',
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              StockIndicator(status: deal.inventory.parsedStockStatus),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Expires',
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              ExpiryBadge(
                status: deal.inventory.parsedExpiryStatus,
                label: deal.inventory.expiryStatus,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoreSection(BuildContext context, DealDetail deal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available at', style: AppTypography.title),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: () {}, // Future Step: Store Details
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: deal.store.logo != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: AppNetworkImage(
                            imageUrl: deal.store.logo!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.storefront,
                          color: AppColors.textSecondary,
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(deal.store.name, style: AppTypography.title),
                      if (deal.store.address != null)
                        Text(
                          deal.store.address!,
                          style: AppTypography.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (deal.distance != null)
                  DistanceBadge(
                    distanceText:
                        '${deal.distance!.value.toStringAsFixed(1)} ${deal.distance!.unit}',
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(DealDetail deal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About this deal', style: AppTypography.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          deal.offer.description ?? '',
          style: AppTypography.body.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStickyCTA(BuildContext context, DealDetail deal) {
    final isAvailable =
        deal.inventory.parsedStockStatus != StockStatus.soldOut &&
        deal.inventory.parsedExpiryStatus != ExpiryStatus.expired;

    return GlassSurface(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            label: isAvailable ? 'Reserve Now' : 'Unavailable',
            variant: AppButtonVariant.primary,
            onPressed: isAvailable
                ? () {
                    context.push('/reservation/review/${deal.id}');
                  }
                : null,
          ),
        ),
      ),
    );
  }
}
