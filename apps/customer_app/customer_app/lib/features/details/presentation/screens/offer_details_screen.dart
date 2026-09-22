import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/chips_badges/expiry_badge.dart';
import '../../../../core/widgets/chips_badges/discount_badge.dart';
import '../../../../core/widgets/chips_badges/distance_badge.dart';
import '../../../../core/widgets/domain/stock_indicator.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
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
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        _buildSliverAppBar(context, deal),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(deal).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.xl),
                _buildPriceSection(deal).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xl),
                _buildStatusSection(deal).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xl),
                _buildStoreSection(context, deal).animate().fade(duration: AppAnimations.medium, delay: 300.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xl),
                if (deal.offer.description != null) ...[
                  _buildDescriptionSection(deal).animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(
                    height: AppSpacing.xxl * 2,
                  ),
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
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InteractiveContainer(
          onTap: () => context.pop(),
          scaleDown: 0.9,
          child: const GlassSurface(
            borderRadius: 100.0,
            child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveContainer(
            onTap: () {},
            scaleDown: 0.9,
            child: const GlassSurface(
              borderRadius: 100.0,
              child: Icon(
                Icons.share_outlined,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            deal.product.image != null
                ? AppNetworkImage(imageUrl: deal.product.image!, fit: BoxFit.cover)
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.fastfood,
                      size: 64,
                      color: AppColors.textDisabled,
                    ),
                  ),
            // Bottom gradient for smooth transition to content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: 0.0),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ],
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
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(deal.product.name, style: AppTypography.headline),
        if (deal.offer.title != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              deal.offer.title!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildPriceSection(DealDetail deal) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
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
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Availability',
                      style: AppTypography.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                StockIndicator(status: deal.inventory.parsedStockStatus),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Expires',
                      style: AppTypography.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                ExpiryBadge(
                  status: deal.inventory.parsedExpiryStatus,
                  label: deal.inventory.expiryStatus,
                ),
              ],
            ),
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
        InteractiveContainer(
          onTap: () {}, // Future Step: Store Details
          scaleDown: 0.98,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
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
                          style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
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
                  )
                else
                  const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
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
          style: AppTypography.body.copyWith(
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyCTA(BuildContext context, DealDetail deal) {
    final isAvailable =
        deal.inventory.parsedStockStatus != StockStatus.soldOut &&
        deal.inventory.parsedExpiryStatus != ExpiryStatus.expired;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
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
    ).animate().slideY(begin: 1.0, end: 0, duration: AppAnimations.medium, curve: Curves.easeOutCubic);
  }
}
