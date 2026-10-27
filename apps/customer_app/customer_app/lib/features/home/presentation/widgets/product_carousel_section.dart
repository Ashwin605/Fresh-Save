import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/domain/reference_product_card.dart';
import 'section_header.dart';
import 'view_all_button.dart';

class ProductCarouselItem {
  final String id;
  final String name;
  final String? imageUrl;
  final double? originalPrice;
  final double? discountedPrice;
  final double? discountPercent;
  final double? savingsAmount;
  final String? variantCount;

  const ProductCarouselItem({
    required this.id,
    required this.name,
    this.imageUrl,
    this.originalPrice,
    this.discountedPrice,
    this.discountPercent,
    this.savingsAmount,
    this.variantCount,
  });
}

/// Horizontal product carousel with reference product cards and full-width "View All >" button.
class ProductCarouselSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ProductCarouselItem> items;
  final VoidCallback onViewAll;

  const ProductCarouselSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          subtitle: subtitle,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 258,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return ReferenceProductCard(
                id: item.id,
                name: item.name,
                imageUrl: item.imageUrl,
                originalPrice: item.originalPrice,
                discountedPrice: item.discountedPrice,
                discountPercent: item.discountPercent,
                savingsAmount: item.savingsAmount,
                variantCount: item.variantCount,
                onTap: () {
                  context.push('/offer/${item.id}');
                },
                onAdd: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${item.name} to cart'),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ViewAllButton(
          onTap: onViewAll,
        ),
      ],
    );
  }
}
