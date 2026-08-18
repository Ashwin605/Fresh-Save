import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_radius.dart';
import '../layout/app_card.dart';
import '../chips_badges/discount_badge.dart';
import '../chips_badges/expiry_badge.dart';
import 'stock_indicator.dart';
import '../app_network_image.dart';

class OfferCard extends StatelessWidget {
  final String productName;
  final String storeName;
  final double originalPrice;
  final double discountedPrice;
  final double discountPercent;
  final ExpiryStatus expiryStatus;
  final StockStatus stockStatus;
  final String? imageUrl;
  final String? distance;
  final VoidCallback? onTap;

  const OfferCard({
    super.key,
    required this.productName,
    required this.storeName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.expiryStatus,
    required this.stockStatus,
    this.imageUrl,
    this.distance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      variant: AppCardVariant.elevated,
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Header
          Stack(
            children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.lg),
                    topRight: Radius.circular(AppRadius.lg),
                  ),
                ),
                child: imageUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(AppRadius.lg),
                          topRight: Radius.circular(AppRadius.lg),
                        ),
                        child: AppNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.fastfood_outlined,
                          size: 48,
                          color: AppColors.textDisabled,
                        ),
                      ),
              ),
              Positioned(
                top: AppSpacing.sm,
                right: AppSpacing.sm,
                child: DiscountBadge(discountPercent: discountPercent),
              ),
            ],
          ),

          // Content Area
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: AppTypography.title.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${discountedPrice.toStringAsFixed(2)}',
                          style: AppTypography.title.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          '₹${originalPrice.toStringAsFixed(2)}',
                          style: AppTypography.label.copyWith(
                            color: AppColors.textDisabled,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        storeName,
                        style: AppTypography.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (distance != null)
                      Text(
                        distance!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    ExpiryBadge(status: expiryStatus, label: _expiryLabel()),
                    const Spacer(),
                    StockIndicator(status: stockStatus),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _expiryLabel() {
    switch (expiryStatus) {
      case ExpiryStatus.fresh:
        return 'Fresh';
      case ExpiryStatus.expiringSoon:
        return 'Expiring Soon';
      case ExpiryStatus.urgent:
        return 'Expires Today';
      case ExpiryStatus.critical:
        return 'Expires in Hours';
      case ExpiryStatus.expired:
        return 'Expired';
    }
  }
}
