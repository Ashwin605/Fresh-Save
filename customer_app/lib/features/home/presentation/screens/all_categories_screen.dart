import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../providers/home_providers.dart';

class AllCategoriesScreen extends ConsumerWidget {
  const AllCategoriesScreen({super.key});

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

  static Color _colorForIndex(int index) {
    const palette = [
      Color(0xFF2B5C4B), // primary green
      Color(0xFFD4A373), // warm tan
      Color(0xFF6B8F71), // sage
      Color(0xFF8B5E3C), // brown
      Color(0xFF5B7F95), // steel blue
      Color(0xFFA0522D), // sienna
      Color(0xFF4A826D), // teal
      Color(0xFF9B6B9E), // muted purple
    ];
    return palette[index % palette.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('All Categories', style: AppTypography.title),
        centerTitle: false,
      ),
      body: categoriesAsync.when(
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: AppColors.textDisabled.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No categories yet',
                    style: AppTypography.title.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Categories will appear here once available.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.6,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final color = _colorForIndex(index);
              final icon = _iconForCategory(category.name);

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/category/${category.id}'),
                  splashColor: color.withValues(alpha: 0.1),
                  highlightColor: color.withValues(alpha: 0.05),
                  child: Ink(
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
                    child: Stack(
                      children: [
                        // Subtle background accent
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            icon,
                            size: 100,
                            color: color.withValues(alpha: 0.05),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(icon, color: color, size: 24),
                              ),
                              Text(
                                category.name,
                                style: AppTypography.title.copyWith(
                                  fontSize: 16,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.6,
          ),
          itemCount: 6,
          itemBuilder: (context, index) => const AppSkeleton(
            width: double.infinity,
            height: double.infinity,
            borderRadius: 16,
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: AppSpacing.md),
              Text('Failed to load categories', style: AppTypography.body),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: () => ref.invalidate(categoriesProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
