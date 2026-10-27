import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';
import '../../domain/models/home_models.dart';
import 'section_header.dart';

/// 4x2 category grid driven entirely by REAL categories from the backend database.
class PackagedFoodCategoriesGrid extends ConsumerWidget {
  const PackagedFoodCategoriesGrid({super.key});

  static IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('chip') || lower.contains('snack')) return Icons.cookie_outlined;
    if (lower.contains('drink') || lower.contains('juice') || lower.contains('beverage')) return Icons.local_drink_outlined;
    if (lower.contains('biscuit') || lower.contains('bakery') || lower.contains('bread')) return Icons.bakery_dining_outlined;
    if (lower.contains('sweet') || lower.contains('candy') || lower.contains('chocolate')) return Icons.cake_outlined;
    if (lower.contains('coffee') || lower.contains('tea')) return Icons.coffee_outlined;
    if (lower.contains('noodle') || lower.contains('pasta')) return Icons.ramen_dining_outlined;
    if (lower.contains('rice') || lower.contains('grain') || lower.contains('atta') || lower.contains('flour')) return Icons.rice_bowl_outlined;
    if (lower.contains('cook') || lower.contains('meal')) return Icons.dinner_dining_outlined;
    if (lower.contains('dairy') || lower.contains('milk')) return Icons.egg_alt_outlined;
    if (lower.contains('produce') || lower.contains('fruit') || lower.contains('vegetable')) return Icons.apple_outlined;
    return Icons.category_outlined;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox.shrink(); // Hide cleanly if no categories are configured
        }

        // Flatten top-level and subcategories to get up to 8 real categories for the grid
        final List<Category> displayCategories = [];
        for (final cat in categories) {
          if (cat.children.isNotEmpty) {
            displayCategories.addAll(cat.children);
          } else {
            displayCategories.add(cat);
          }
        }

        final items = displayCategories.take(8).toList();
        if (items.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(
              title: 'Categories & Packaged Food',
            ),
            const SizedBox(height: AppSpacing.sm),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.72,
                ),
                itemBuilder: (context, index) {
                  final cat = items[index];
                  return _RealCategoryCard(category: cat);
                },
              ),
            ),
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) => const AppSkeleton(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 12,
          ),
        ),
      ),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _RealCategoryCard extends StatelessWidget {
  final Category category;

  const _RealCategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/category/${category.id}');
      },
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: category.image != null && category.image!.isNotEmpty
                    ? AppNetworkImage(
                        imageUrl: category.image!,
                        fit: BoxFit.contain,
                      )
                    : Center(
                        child: Icon(
                          PackagedFoodCategoriesGrid._iconForCategory(category.name),
                          size: 28,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
              height: 1.15,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
