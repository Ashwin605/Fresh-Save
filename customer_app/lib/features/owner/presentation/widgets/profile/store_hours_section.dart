import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../providers/owner_state_provider.dart';
import 'section_container.dart';

class StoreHoursSection extends ConsumerWidget {
  const StoreHoursSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(ownerStateProvider).activeStore;
    if (store == null) return const SizedBox.shrink();

    return SectionContainer(
      title: 'Operating Hours',
      child: store.openingHours != null && store.openingHours!.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: store.openingHours!.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key.toUpperCase(), style: AppTypography.label),
                      Text(entry.value.toString(), style: AppTypography.body),
                    ],
                  ),
                );
              }).toList(),
            )
          : Text(
              'No operating hours set. Editing operating hours requires API validation constraints.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
    );
  }
}
