import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../app_network_image.dart';

/// Product card matching the reference screenshots exactly.
/// White card with border, product image, save badge, + ADD button,
/// product name, green price badge, strikethrough original price,
/// and gold "Earn X coins" row.
class ReferenceProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String? imageUrl;
  final double? originalPrice;
  final double? discountedPrice;
  final double? discountPercent;
  final double? savingsAmount;
  final String? variantCount;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;
  final double? width;

  const ReferenceProductCard({
    super.key,
    required this.id,
    required this.name,
    this.imageUrl,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercent,
    this.savingsAmount,
    this.variantCount,
    this.onAdd,
    this.onTap,
    this.width = 130,
  });

  double get _effectiveSavings {
    if (savingsAmount != null && savingsAmount! > 0) return savingsAmount!;
    if (originalPrice != null && discountedPrice != null && originalPrice! > discountedPrice!) {
      return originalPrice! - discountedPrice!;
    }
    return 0;
  }

  double get _earnCoins {
    final price = discountedPrice ?? originalPrice ?? 0;
    return (price * 0.1 * 10).round() / 10; // ~10% as loyalty coins
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image container with save badge & ADD button
            AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                children: [
                  // Product image
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                      child: Container(
                        color: Colors.white,
                        child: imageUrl != null
                            ? Padding(
                                padding: const EdgeInsets.all(8),
                                child: AppNetworkImage(
                                  imageUrl: imageUrl!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  size: 40,
                                  color: AppColors.textDisabled,
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Save badge (top-left)
                  if (_effectiveSavings > 0)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.saveBadgeGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle, size: 10, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              discountPercent != null && discountPercent! > 0
                                  ? '${discountPercent!.toStringAsFixed(0)}% off'
                                  : 'Save ₹${_effectiveSavings.toStringAsFixed(_effectiveSavings == _effectiveSavings.roundToDouble() ? 0 : 2)}',
                              style: AppTypography.caption.copyWith(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // + ADD button (bottom-center of image)
                  if (onAdd != null)
                    Positioned(
                      bottom: 0,
                      left: 12,
                      right: 12,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: onAdd,
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.addButtonRed, width: 1.2),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '+ ADD',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.addButtonRed,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (variantCount != null)
                                  Text(
                                    variantCount!,
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.textSecondary,
                                      fontSize: 9,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product name
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                name,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Price row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Green price badge
                  if (discountedPrice != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.priceGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '₹${discountedPrice!.toStringAsFixed(discountedPrice! == discountedPrice!.roundToDouble() ? 0 : 2)}',
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else if (originalPrice != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.priceGreen,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '₹${originalPrice!.toStringAsFixed(originalPrice! == originalPrice!.roundToDouble() ? 0 : 2)}',
                        style: AppTypography.label.copyWith(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  // Strikethrough original price
                  if (originalPrice != null && discountedPrice != null && originalPrice! > discountedPrice!) ...[
                    const SizedBox(width: 6),
                    Text(
                      '₹${originalPrice!.toStringAsFixed(0)}',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textDisabled,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.textDisabled,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Earn coins row
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
              child: Row(
                children: [
                  // Gold coin icon
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.coinGold,
                          AppColors.coinGold.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'F',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _earnCoins == _earnCoins.roundToDouble()
                          ? 'Earn ${_earnCoins.toInt()} coins'
                          : 'Earn ${_earnCoins.toStringAsFixed(1)} coins',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.priceGreen,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
