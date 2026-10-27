import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/home_providers.dart';
import '../../domain/models/home_models.dart';

/// Side-by-side featured category banners driven by REAL categories from the backend.
class FeaturedCategoryPromos extends ConsumerWidget {
  const FeaturedCategoryPromos({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.length < 2) return const SizedBox.shrink();

        // Select 2 categories from backend (preferably Home/Kitchen and Personal Care, or top 2)
        Category? cat1 = categories.cast<Category?>().firstWhere(
          (c) => c?.name.toLowerCase().contains('kitchen') == true || c?.name.toLowerCase().contains('home') == true,
          orElse: () => null,
        );
        Category? cat2 = categories.cast<Category?>().firstWhere(
          (c) => (c?.name.toLowerCase().contains('care') == true || c?.name.toLowerCase().contains('beauty') == true) && c?.id != cat1?.id,
          orElse: () => null,
        );

        final firstCat = cat1 ?? categories[0];
        final secondCat = cat2 ?? (categories.length > 1 ? categories[1] : null);

        if (secondCat == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: _FeaturedPromoCard(
                  title: firstCat.name,
                  titleColor: const Color(0xFF2D5A27),
                  bgColor: const Color(0xFFF0FDF4),
                  borderColor: const Color(0xFFBBF7D0),
                  arrowColor: const Color(0xFF16A34A),
                  imageUrl: firstCat.image,
                  icon: Icons.kitchen_outlined,
                  onTap: () => context.push('/category/${firstCat.id}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FeaturedPromoCard(
                  title: secondCat.name,
                  titleColor: const Color(0xFF9D174D),
                  bgColor: const Color(0xFFFDF2F8),
                  borderColor: const Color(0xFFFBCFE8),
                  arrowColor: const Color(0xFFDB2777),
                  imageUrl: secondCat.image,
                  icon: Icons.spa_outlined,
                  onTap: () => context.push('/category/${secondCat.id}'),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _FeaturedPromoCard extends StatelessWidget {
  final String title;
  final Color titleColor;
  final Color bgColor;
  final Color borderColor;
  final Color arrowColor;
  final String? imageUrl;
  final IconData icon;
  final VoidCallback onTap;

  const _FeaturedPromoCard({
    required this.title,
    required this.titleColor,
    required this.bgColor,
    required this.borderColor,
    required this.arrowColor,
    this.imageUrl,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 125,
        padding: const EdgeInsets.fromLTRB(10, 10, 8, 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: titleColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                SizedBox(
                  height: 65,
                  width: double.infinity,
                  child: imageUrl != null && imageUrl!.isNotEmpty
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomLeft,
                          errorBuilder: (_, _, _) => Icon(
                            icon,
                            size: 36,
                            color: titleColor.withValues(alpha: 0.5),
                          ),
                        )
                      : Icon(
                          icon,
                          size: 36,
                          color: titleColor.withValues(alpha: 0.5),
                        ),
                ),
              ],
            ),
            Positioned(
              right: 2,
              bottom: 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: arrowColor,
                  boxShadow: [
                    BoxShadow(
                      color: arrowColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
