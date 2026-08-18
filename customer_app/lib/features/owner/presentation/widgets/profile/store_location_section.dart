import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../providers/manage_store_controller.dart';
import '../../providers/owner_state_provider.dart';
import 'section_container.dart';

class StoreLocationSection extends ConsumerWidget {
  const StoreLocationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(ownerStateProvider).activeStore;
    final manageState = ref.watch(manageStoreControllerProvider);

    if (store == null) return const SizedBox.shrink();

    return SectionContainer(
      title: 'Store Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (manageState.isEditMode) ...[
            AppTextField(
              labelText: 'Address',
              maxLines: 2,
              controller: TextEditingController(
                text: manageState.editStoreAddress,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editStoreAddress: v),
            ),
          ] else ...[
            if (store.address != null && store.address!.isNotEmpty)
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(store.address!, style: AppTypography.body),
                  ),
                ],
              )
            else
              Text(
                'No location set',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
