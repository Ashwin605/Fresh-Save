import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/chips_badges/app_chip.dart';
import '../../../../core/widgets/layout/app_bottom_sheet.dart';
import '../providers/discovery_provider.dart';
import '../../domain/models/discovery_state.dart';
import 'filter_bottom_sheet.dart';
import 'sort_bottom_sheet.dart';
import 'dart:ui';

class DiscoveryControlsBar extends ConsumerWidget {
  const DiscoveryControlsBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoveryProvider);
    final notifier = ref.read(discoveryProvider.notifier);

    return SliverPersistentHeader(
      pinned: true,
      delegate: _DiscoveryControlsDelegate(
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: AppColors.background.withAlpha(220),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    child: Row(
                      children: [
                        // Filter Button
                        _ControlButton(
                          icon: Icons.tune,
                          label: 'Filters',
                          isActive: state.filters.hasActiveFilters,
                          onTap: () {
                            AppBottomSheet.show(
                              context: context,
                              child: const FilterBottomSheet(),
                            );
                          },
                        ),
                        const SizedBox(width: AppSpacing.sm),

                        // Sort Button
                        _ControlButton(
                          icon: Icons.swap_vert,
                          label: _getSortLabel(state.sort),
                          isActive: state.sort != DiscoverySort.relevance,
                          onTap: () {
                            AppBottomSheet.show(
                              context: context,
                              child: const SortBottomSheet(),
                            );
                          },
                        ),

                        // Active Filters (if any)
                        if (state.filters.radius != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _ActiveFilterChip(
                            label: 'Within ${state.filters.radius!.toInt()} km',
                            onRemove: () => notifier.updateFilters(
                              state.filters.copyWith(radius: null),
                            ),
                          ),
                        ],
                        if (state.filters.categoryName != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _ActiveFilterChip(
                            label: state.filters.categoryName!,
                            onRemove: () => notifier.updateFilters(
                              state.filters.copyWith(
                                categoryId: null,
                                categoryName: null,
                              ),
                            ),
                          ),
                        ],
                        if (state.filters.minDiscount != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _ActiveFilterChip(
                            label:
                                '${state.filters.minDiscount!.toInt()}%+ off',
                            onRemove: () => notifier.updateFilters(
                              state.filters.copyWith(minDiscount: null),
                            ),
                          ),
                        ],
                        if (state.filters.expiryWithinHours != null) ...[
                          const SizedBox(width: AppSpacing.sm),
                          _ActiveFilterChip(
                            label: state.filters.expiryWithinHours! <= 24
                                ? 'Expiring soon'
                                : 'Any expiry',
                            onRemove: () => notifier.updateFilters(
                              state.filters.copyWith(expiryWithinHours: null),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getSortLabel(DiscoverySort sort) {
    switch (sort) {
      case DiscoverySort.relevance:
        return 'Relevance';
      case DiscoverySort.distance:
        return 'Nearest';
      case DiscoverySort.discount:
        return 'Highest Discount';
      case DiscoverySort.price:
        return 'Lowest Price';
      case DiscoverySort.expiry:
        return 'Expiring Soon';
      case DiscoverySort.newest:
        return 'Newest';
    }
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isActive ? AppColors.primary : AppColors.surfaceVariant,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? Colors.white : AppColors.textPrimary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.label.copyWith(
                color: isActive ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _ActiveFilterChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return AppChip(
      label: label,
      isSelected: true,
      onTap: onRemove,
      icon: Icons.close,
    );
  }
}

class _DiscoveryControlsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _DiscoveryControlsDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => 56;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
