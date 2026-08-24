import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/chips_badges/app_chip.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  static IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('bakery') || lower.contains('bread')) {
      return Icons.bakery_dining;
    }
    if (lower.contains('dairy') || lower.contains('milk')) return Icons.egg_alt;
    if (lower.contains('produce') || lower.contains('fruit') || lower.contains('vegetable')) {
      return Icons.apple;
    }
    if (lower.contains('meat') || lower.contains('poultry')) {
      return Icons.lunch_dining;
    }
    if (lower.contains('beverage') || lower.contains('drink')) {
      return Icons.local_cafe;
    }
    if (lower.contains('snack')) return Icons.cookie;
    if (lower.contains('frozen')) return Icons.ac_unit;
    if (lower.contains('food')) return Icons.restaurant;
    if (lower.contains('grocery') || lower.contains('groceries')) {
      return Icons.shopping_basket;
    }
    return Icons.category;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: AppTypography.title),
              TextButton(
                onPressed: () => context.push('/categories'),
                child: Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Text(
                      'No categories available',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }

              final displayCount = categories.length > 8 ? 8 : categories.length;
              
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                scrollDirection: Axis.horizontal,
                itemCount: displayCount + 1, // +1 for "More"
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  if (index == displayCount) {
                    return GestureDetector(
                      onTap: () => context.push('/categories'),
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.more_horiz,
                                color: AppColors.primary,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'More',
                              style: AppTypography.label.copyWith(
                                color: AppColors.textPrimary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final category = categories[index];
                  return GestureDetector(
                    onTap: () => context.push('/category/${category.id}'),
                    child: Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _iconForCategory(category.name),
                              color: AppColors.primary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            category.name,
                            style: AppTypography.label.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) =>
                  const AppSkeleton(width: 80, height: 100, borderRadius: 16),
            ),
            error: (error, stack) => Center(
              child: Text(
                'Failed to load categories',
                style: AppTypography.bodySmall.copyWith(color: AppColors.error),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
