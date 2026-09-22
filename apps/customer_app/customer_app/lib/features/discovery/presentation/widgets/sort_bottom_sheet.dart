import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/discovery_provider.dart';
import '../../domain/models/discovery_state.dart';

class SortBottomSheet extends ConsumerWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSort = ref.watch(discoveryProvider).sort;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sort by', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          _SortOption(
            label: 'Relevance',
            value: DiscoverySort.relevance,
            groupValue: currentSort,
            onChanged: (val) {
              ref.read(discoveryProvider.notifier).updateSort(val!);
              context.pop();
            },
          ),
          _SortOption(
            label: 'Nearest',
            value: DiscoverySort.distance,
            groupValue: currentSort,
            onChanged: (val) {
              ref.read(discoveryProvider.notifier).updateSort(val!);
              context.pop();
            },
          ),
          _SortOption(
            label: 'Highest Discount',
            value: DiscoverySort.discount,
            groupValue: currentSort,
            onChanged: (val) {
              ref.read(discoveryProvider.notifier).updateSort(val!);
              context.pop();
            },
          ),
          _SortOption(
            label: 'Lowest Price',
            value: DiscoverySort.price,
            groupValue: currentSort,
            onChanged: (val) {
              ref.read(discoveryProvider.notifier).updateSort(val!);
              context.pop();
            },
          ),
          _SortOption(
            label: 'Expiring Soon',
            value: DiscoverySort.expiry,
            groupValue: currentSort,
            onChanged: (val) {
              ref.read(discoveryProvider.notifier).updateSort(val!);
              context.pop();
            },
          ),
          _SortOption(
            label: 'Newest',
            value: DiscoverySort.newest,
            groupValue: currentSort,
            onChanged: (val) {
              ref.read(discoveryProvider.notifier).updateSort(val!);
              context.pop();
            },
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String label;
  final DiscoverySort value;
  final DiscoverySort groupValue;
  final ValueChanged<DiscoverySort?> onChanged;

  const _SortOption({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RadioListTile<DiscoverySort>(
      title: Text(label, style: AppTypography.body),
      value: value,
      // ignore: deprecated_member_use
      groupValue: groupValue,
      // ignore: deprecated_member_use
      onChanged: onChanged,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
    );
  }
}
