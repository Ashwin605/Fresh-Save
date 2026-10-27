import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../domain/models/home_models.dart';
import '../providers/home_providers.dart';

/// Main category navigation cards displayed prominently below the search bar
/// in a single horizontal row matching the reference screenshot:
/// 1. Groceries
/// 2. Clothing
/// 3. Food
class MainCategoryCards extends ConsumerWidget {
  const MainCategoryCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) => _buildCardsRow(context, categories),
      loading: () => _buildLoadingSkeleton(),
      error: (_, _) => _buildCardsRow(context, const []),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: const [
          Expanded(child: AppSkeleton(width: double.infinity, height: 48, borderRadius: 14)),
          SizedBox(width: 10),
          Expanded(child: AppSkeleton(width: double.infinity, height: 48, borderRadius: 14)),
          SizedBox(width: 10),
          Expanded(child: AppSkeleton(width: double.infinity, height: 48, borderRadius: 14)),
        ],
      ),
    );
  }

  Widget _buildCardsRow(BuildContext context, List<Category> categories) {
    // 1. Resolve Groceries category from backend
    Category? groceriesCategory;
    for (final c in categories) {
      final slug = c.slug?.toLowerCase() ?? '';
      final name = c.name.toLowerCase();
      if (slug == 'groceries' || name == 'groceries') {
        groceriesCategory = c;
        break;
      }
    }
    // Fallback: match produce or grocery-related root category
    if (groceriesCategory == null) {
      for (final c in categories) {
        final slug = c.slug?.toLowerCase() ?? '';
        final name = c.name.toLowerCase();
        if (slug == 'produce' || name.contains('produce') || name.contains('grocery')) {
          groceriesCategory = c;
          break;
        }
      }
    }

    // 2. Resolve Clothing category from backend
    Category? clothingCategory;
    for (final c in categories) {
      final slug = c.slug?.toLowerCase() ?? '';
      final name = c.name.toLowerCase();
      if (slug == 'clothing' || name.contains('cloth') || name.contains('apparel') || name.contains('fashion')) {
        clothingCategory = c;
        break;
      }
    }

    // 3. Resolve Food category from backend
    Category? foodCategory;
    for (final c in categories) {
      final slug = c.slug?.toLowerCase() ?? '';
      final name = c.name.toLowerCase();
      if (slug == 'food' || name == 'food') {
        foodCategory = c;
        break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: _MainCategoryCardItem(
              key: const Key('main_category_groceries'),
              title: 'Groceries',
              icon: Icons.shopping_basket_rounded,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF2E7D32),
              onTap: () => _handleNavigation(
                context,
                title: 'Groceries',
                category: groceriesCategory,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MainCategoryCardItem(
              key: const Key('main_category_clothing'),
              title: 'Clothing',
              icon: Icons.checkroom_rounded,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF2563EB),
              onTap: () => _handleNavigation(
                context,
                title: 'Clothing',
                category: clothingCategory,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _MainCategoryCardItem(
              key: const Key('main_category_food'),
              title: 'Food',
              icon: Icons.restaurant_rounded,
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFEA580C),
              onTap: () => _handleNavigation(
                context,
                title: 'Food',
                category: foodCategory,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleNavigation(
    BuildContext context, {
    required String title,
    required Category? category,
  }) {
    if (category != null) {
      // Reuses existing category discovery architecture (/category/:id)
      context.push('/category/${category.id}');
    } else {
      // Graceful fallback to search screen to query backend catalog by title
      context.push('/search?query=$title');
    }
  }
}

class _MainCategoryCardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _MainCategoryCardItem({
    super.key,
    required this.title,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        splashColor: iconColor.withValues(alpha: 0.1),
        highlightColor: iconColor.withValues(alpha: 0.05),
        child: Ink(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 15,
                      color: iconColor,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
