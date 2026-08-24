import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_radius.dart';
import '../app_network_image.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final String? brand;
  final String? imageUrl;
  final double? originalPrice;
  final double? discountedPrice;
  final String? quantity;
  final String? storeName;
  final String? offerBadge;
  final VoidCallback? onAdd;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    this.brand,
    this.imageUrl,
    this.originalPrice,
    this.discountedPrice,
    this.quantity,
    this.storeName,
    this.offerBadge,
    this.onAdd,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image section
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Container(
                  color: AppColors.surfaceVariant,
                  child: imageUrl != null
                      ? AppNetworkImage(
                          imageUrl: imageUrl!,
                          fit: BoxFit.cover,
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
            
            // Content section
            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  if (offerBadge != null)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Text(
                          offerBadge!,
                          style: AppTypography.label.copyWith(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (brand != null && brand!.isNotEmpty) ...[
                          Text(
                            brand!.toUpperCase(),
                            style: AppTypography.label.copyWith(
                              fontSize: 10,
                              color: AppColors.textDisabled,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                        ],
                        Text(
                          name,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (quantity != null && quantity!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            quantity!,
                            style: AppTypography.label.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (storeName != null && storeName!.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            storeName!,
                            style: AppTypography.label.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 10,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (originalPrice != null && originalPrice! > (discountedPrice ?? 0))
                              Text(
                                '₹${originalPrice!.toStringAsFixed(0)}',
                                style: AppTypography.label.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textDisabled,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            if (discountedPrice != null)
                              Text(
                                '₹${discountedPrice!.toStringAsFixed(0)}',
                                style: AppTypography.title.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              )
                            else if (originalPrice != null)
                              Text(
                                '₹${originalPrice!.toStringAsFixed(0)}',
                                style: AppTypography.title.copyWith(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                ),
                              )
                          ],
                        ),
                        if (onAdd != null)
                          Material(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: onAdd,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Text(
                                  'ADD',
                                  style: AppTypography.label.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
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
          ],
        ),
      ),
    ),
  );
}
}
