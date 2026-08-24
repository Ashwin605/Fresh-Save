import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/chips_badges/app_chip.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../providers/search_provider.dart';

class SearchInitialView extends ConsumerWidget {
  const SearchInitialView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearches = ref.watch(
      searchProvider.select((s) => s.recentSearches),
    );

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      physics: const BouncingScrollPhysics(),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Searches', style: AppTypography.title),
                InteractiveContainer(
                  onTap: () => ref
                      .read(searchProvider.notifier)
                      .clearAllRecentSearches(),
                  child: Text(
                    'Clear All',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.1, end: 0),
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: recentSearches.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.sm),
                  child: AppChip(
                    label: entry.value,
                    isSelected: false,
                    onTap: () {
                      ref.read(searchProvider.notifier).executeSearch(entry.value);
                    },
                  ),
                ).animate().fade(
                  duration: AppAnimations.medium,
                  delay: Duration(milliseconds: 100 + (entry.key * 50)),
                ).slideX(begin: 0.1, end: 0);
              }).toList(),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text('Browse Categories', style: AppTypography.title),
        ).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.1, end: 0),
        const SizedBox(height: AppSpacing.md),
        ref
            .watch(categoriesProvider)
            .when(
              data: (categories) {
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    return InteractiveContainer(
                      onTap: () => context.push('/category/${cat.id}'),
                      scaleDown: 0.95,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            if (cat.icon != null) ...[
                              Text(
                                cat.icon!,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                            ],
                            Expanded(
                              child: Text(
                                cat.name,
                                style: AppTypography.bodySmall.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right_rounded,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ).animate().fade(
                      duration: AppAnimations.medium,
                      delay: Duration(milliseconds: 300 + (index * 50)),
                    ).slideY(begin: 0.1, end: 0);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  const Center(child: Text('Failed to load categories')),
            ),
      ],
    );
  }
}
