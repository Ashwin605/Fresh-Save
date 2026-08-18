import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/chips_badges/app_chip.dart';
import '../../../home/presentation/providers/home_providers.dart'; // For categories
import '../providers/discovery_provider.dart';
import '../../domain/models/discovery_state.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late DiscoveryFilters _tempFilters;

  @override
  void initState() {
    super.initState();
    _tempFilters = ref.read(discoveryProvider).filters;
  }

  void _applyFilters() {
    ref.read(discoveryProvider.notifier).updateFilters(_tempFilters);
    context.pop();
  }

  void _resetFilters() {
    setState(() {
      _tempFilters = const DiscoveryFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filters', style: AppTypography.title),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Reset',
                  style: AppTypography.body.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Distance
          Text('Distance', style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [1.0, 3.0, 5.0, 10.0].map((dist) {
              final isSelected = _tempFilters.radius == dist;
              return AppChip(
                label: '${dist.toInt()} km',
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _tempFilters = _tempFilters.copyWith(
                      radius: isSelected ? null : dist,
                    );
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Discount
          Text('Discount', style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [10.0, 25.0, 50.0, 75.0].map((discount) {
              final isSelected = _tempFilters.minDiscount == discount;
              return AppChip(
                label: '${discount.toInt()}%+ off',
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _tempFilters = _tempFilters.copyWith(
                      minDiscount: isSelected ? null : discount,
                    );
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Categories
          Text('Categories', style: AppTypography.label),
          const SizedBox(height: AppSpacing.sm),
          ref
              .watch(categoriesProvider)
              .when(
                data: (categories) {
                  return Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.sm,
                    children: categories.map((cat) {
                      final isSelected = _tempFilters.categoryId == cat.id;
                      return AppChip(
                        label: cat.name,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _tempFilters = _tempFilters.copyWith(
                                categoryId: null,
                                categoryName: null,
                              );
                            } else {
                              _tempFilters = _tempFilters.copyWith(
                                categoryId: cat.id,
                                categoryName: cat.name,
                              );
                            }
                          });
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) =>
                    const Text('Failed to load categories'),
              ),
          const SizedBox(height: AppSpacing.xl),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(label: 'Apply', onPressed: _applyFilters),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
