import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/layout/app_card.dart';
import '../../../domain/models/owner_offer_models.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class OfferManagementCard extends StatelessWidget {
  final OwnerOffer offer;

  const OfferManagementCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
    );
    final isExpired = offer.status == OfferStatus.expired;
    final isSoldOut = offer.status == OfferStatus.soldOut;
    final isPaused = offer.status == OfferStatus.paused;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        variant: AppCardVariant.outlined,
        padding: const EdgeInsets.all(AppSpacing.md),
        onTap: () {
          context.push('/owner/offers/${offer.id}');
        },
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        offer.title ?? offer.inventory?.product.name ?? 'Offer',
                        style: AppTypography.title.copyWith(fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _buildImage(),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                currencyFormatter.format(offer.discountedPrice),
                                style: AppTypography.title.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                currencyFormatter.format(
                                  offer.originalPriceSnapshot,
                                ),
                                style: AppTypography.bodySmall.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withAlpha(20),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  offer.discountType == DiscountType.percentage
                                      ? '${offer.discountValue.toStringAsFixed(0)}% OFF'
                                      : '-${currencyFormatter.format(offer.discountAmount)}',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              const Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${offer.inventory?.stockQuantity ?? 0} available',
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 16,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  'Ends ${DateFormat('MMM d, h:mm a').format(offer.endsAt.toLocal())}',
                                  style: AppTypography.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isExpired || isSoldOut || isPaused) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isExpired
                          ? 'This offer has expired.'
                          : isSoldOut
                          ? 'This offer is sold out.'
                          : 'This offer is currently paused.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(
        Icons.local_offer_outlined,
        color: AppColors.textDisabled,
        size: 32,
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;

    switch (offer.status) {
      case OfferStatus.active:
        color = AppColors.success;
        text = 'Active';
        break;
      case OfferStatus.scheduled:
        color = AppColors.info;
        text = 'Scheduled';
        break;
      case OfferStatus.paused:
        color = AppColors.warning;
        text = 'Paused';
        break;
      case OfferStatus.soldOut:
        color = AppColors.textSecondary;
        text = 'Sold Out';
        break;
      case OfferStatus.expired:
        color = AppColors.error;
        text = 'Expired';
        break;
      case OfferStatus.cancelled:
        color = AppColors.error;
        text = 'Cancelled';
        break;
      case OfferStatus.draft:
        color = AppColors.textSecondary;
        text = 'Draft';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
