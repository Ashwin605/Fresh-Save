import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../providers/manage_store_controller.dart';
import '../../providers/owner_state_provider.dart';
import 'section_container.dart';

class StoreDetailsSection extends ConsumerWidget {
  const StoreDetailsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(ownerStateProvider).activeStore;
    final manageState = ref.watch(manageStoreControllerProvider);

    if (store == null) return const SizedBox.shrink();

    return SectionContainer(
      title: 'Store Profile',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (manageState.isEditMode) ...[
            AppTextField(
              labelText: 'Store Name',
              controller: TextEditingController(
                text: manageState.editStoreName,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editStoreName: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Description',
              maxLines: 3,
              controller: TextEditingController(
                text: manageState.editStoreDescription,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editStoreDescription: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Public Phone',
              keyboardType: TextInputType.phone,
              controller: TextEditingController(
                text: manageState.editStorePhone,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editStorePhone: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Public Email',
              keyboardType: TextInputType.emailAddress,
              controller: TextEditingController(
                text: manageState.editStoreEmail,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editStoreEmail: v),
            ),
          ] else ...[
            _ReadOnlyField(label: 'Store Name', value: store.name),
            _ReadOnlyField(label: 'Description', value: store.description),
            _ReadOnlyField(label: 'Public Phone', value: store.phone),
            _ReadOnlyField(label: 'Public Email', value: store.email),
          ],
        ],
      ),
    );
  }
}

class _ReadOnlyField extends StatelessWidget {
  final String label;
  final String? value;

  const _ReadOnlyField({required this.label, this.value});

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label),
          const SizedBox(height: AppSpacing.xs),
          Text(value!, style: AppTypography.body),
        ],
      ),
    );
  }
}
