import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../providers/manage_store_controller.dart';
import '../../providers/owner_state_provider.dart';
import 'section_container.dart';

class BusinessInfoSection extends ConsumerWidget {
  const BusinessInfoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(ownerStateProvider).business;
    final manageState = ref.watch(manageStoreControllerProvider);

    if (business == null) return const SizedBox.shrink();

    return SectionContainer(
      title: 'Business Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (manageState.isEditMode) ...[
            AppTextField(
              labelText: 'Business Name',
              controller: TextEditingController(
                text: manageState.editBusinessName,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editBusinessName: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Legal Name',
              controller: TextEditingController(
                text: manageState.editLegalName,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editLegalName: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Business Type',
              controller: TextEditingController(
                text: manageState.editBusinessType,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editBusinessType: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Contact Email',
              keyboardType: TextInputType.emailAddress,
              controller: TextEditingController(
                text: manageState.editBusinessEmail,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editBusinessEmail: v),
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              labelText: 'Contact Phone',
              keyboardType: TextInputType.phone,
              controller: TextEditingController(
                text: manageState.editBusinessPhone,
              ),
              onChanged: (v) => ref
                  .read(manageStoreControllerProvider.notifier)
                  .updateField(editBusinessPhone: v),
            ),
          ] else ...[
            _ReadOnlyField(label: 'Business Name', value: business.name),
            _ReadOnlyField(label: 'Legal Name', value: business.legalName),
            _ReadOnlyField(
              label: 'Business Type',
              value: business.businessType,
            ),
            _ReadOnlyField(
              label: 'Contact Email',
              value: business.contactEmail,
            ),
            _ReadOnlyField(
              label: 'Contact Phone',
              value: business.contactPhone,
            ),
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
