import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class CategoriesSection extends ConsumerWidget {
  const CategoriesSection({super.key});

  static IconData _iconForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('bakery') || lower.contains('bread')) return Icons.bakery_dining;
    if (lower.contains('dairy') || lower.contains('milk')) return Icons.egg_alt;
    if (lower.contains('produce') || lower.contains('fruit') || lower.contains('vegetable')) return Icons.apple;
    if (lower.contains('meat') || lower.contains('poultry')) return Icons.lunch_dining;
    if (lower.contains('beverage') || lower.contains('drink')) return Icons.local_cafe;
    if (lower.contains('snack')) return Icons.cookie;
    if (lower.contains('frozen')) return Icons.ac_unit;
    if (lower.contains('food')) return Icons.restaurant;
    if (lower.contains('grocery') || lower.contains('groceries')) return Icons.shopping_basket;
    if (lower.contains('household') || lower.contains('home') || lower.contains('cleaning')) return Icons.cleaning_services;
    if (lower.contains('personal care') || lower.contains('health') || lower.contains('hair') || lower.contains('oral') || lower.contains('soap')) return Icons.spa;
    if (lower.contains('baby') || lower.contains('pet') || lower.contains('dog') || lower.contains('cat')) return Icons.pets;
    return Icons.category;
  }

  static String? _assetForCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('bakery') || lower.contains('bread')) return 'assets/categories/bakery.jpg';
    if (lower.contains('dairy') || lower.contains('milk') || lower.contains('egg')) return 'assets/categories/dairy.jpg';
    if (lower.contains('produce') || lower.contains('fruit') || lower.contains('vegetable')) return 'assets/categories/produce.jpg';
    if (lower.contains('meat') || lower.contains('poultry') || lower.contains('seafood')) return 'assets/categories/meat.jpg';
    if (lower.contains('beverage') || lower.contains('drink') || lower.contains('coffee') || lower.contains('tea') || lower.contains('juice') || lower.contains('water')) return 'assets/categories/beverage.jpg';
    if (lower.contains('snack') || lower.contains('chips') || lower.contains('cookie') || lower.contains('candy')) return 'assets/categories/snack.jpg';
    if (lower.contains('frozen') || lower.contains('ice cream')) return 'assets/categories/frozen.jpg';
    if (lower.contains('food')) return 'assets/categories/food.jpg';
    if (lower.contains('household') || lower.contains('cleaning') || lower.contains('paper product')) return 'assets/categories/household.jpg';
    if (lower.contains('personal care') || lower.contains('health') || lower.contains('hair care') || lower.contains('oral care') || lower.contains('soap') || lower.contains('body wash')) return 'assets/categories/personal_care.jpg';
    if (lower.contains('pet') || lower.contains('dog food') || lower.contains('cat food') || lower.contains('baby')) return 'assets/categories/pet_supplies.jpg';
    return null;
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
              InteractiveContainer(
                onTap: () => context.push('/categories'),
                child: Text(
                  'See All',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 120,
          child: categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                return Center(
                  child: Text(
                    'No categories available',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              final displayCount = categories.length > 8 ? 8 : categories.length;
              
              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: displayCount + 1, // +1 for "More"
                separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  if (index == displayCount) {
                    return InteractiveContainer(
                      onTap: () => context.push('/categories'),
                      scaleDown: 0.9,
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceVariant,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
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
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fade(
                      duration: AppAnimations.medium, 
                      delay: Duration(milliseconds: 450 + (index * 50)),
                    ).scaleXY(begin: 0.8, end: 1.0);
                  }

                  final category = categories[index];
                  final assetPath = _assetForCategory(category.name);
                  return InteractiveContainer(
                    onTap: () => context.push('/category/${category.id}'),
                    scaleDown: 0.9,
                    child: Container(
                      width: 90,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: assetPath != null
                                ? Image.asset(
                                    assetPath,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )
                                : Container(
                                    color: AppColors.surfaceVariant,
                                    child: Icon(
                                      _iconForCategory(category.name),
                                      color: AppColors.primary,
                                      size: 32,
                                    ),
                                  ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
                            child: Text(
                              category.name,
                              style: AppTypography.label.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().fade(
                    duration: AppAnimations.medium, 
                    delay: Duration(milliseconds: 450 + (index * 50)),
                  ).scaleXY(begin: 0.8, end: 1.0);
                },
              );
            },
            loading: () => ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) => const AppSkeleton(width: 90, height: 120, borderRadius: 20),
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
