import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../providers/manage_store_controller.dart';
import '../providers/owner_state_provider.dart';
import '../widgets/profile/store_identity_section.dart';
import '../widgets/profile/business_info_section.dart';
import '../widgets/profile/store_details_section.dart';
import '../widgets/profile/store_location_section.dart';
import '../widgets/profile/store_hours_section.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OwnerManageStoreScreen extends ConsumerWidget {
  const OwnerManageStoreScreen({super.key});

  Future<bool> _onWillPop(BuildContext context, WidgetRef ref) async {
    final state = ref.read(manageStoreControllerProvider);
    if (state.hasUnsavedChanges) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
            'You have unsaved changes. Do you want to discard them?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continue Editing'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Discard',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ),
      );
      return discard ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerState = ref.watch(ownerStateProvider);
    final manageState = ref.watch(manageStoreControllerProvider);

    ref.listen<ManageStoreState>(manageStoreControllerProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        AppSnackbar.show(
          context,
          message: next.error!,
          variant: SnackbarVariant.error,
        );
      }
    });

    return PopScope(
      canPop: !manageState.hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context, ref);
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('Manage Store', style: AppTypography.title),
          backgroundColor: AppColors.surface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () async {
              if (!manageState.hasUnsavedChanges) {
                Navigator.of(context).pop();
                return;
              }
              final shouldPop = await _onWillPop(context, ref);
              if (shouldPop && context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          actions: [
            if (!manageState.isEditMode)
              IconButton(
                icon: const Icon(Icons.edit, color: AppColors.primary),
                onPressed: () => ref
                    .read(manageStoreControllerProvider.notifier)
                    .enterEditMode(),
              )
            else
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: () => ref
                    .read(manageStoreControllerProvider.notifier)
                    .cancelEdit(),
              ),
          ],
        ),
        body: (ownerState.business == null || ownerState.activeStore == null)
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      children: [
                        StoreIdentitySection(),
                        const SizedBox(height: AppSpacing.xl),
                        BusinessInfoSection(),
                        const SizedBox(height: AppSpacing.xl),
                        StoreDetailsSection(),
                        const SizedBox(height: AppSpacing.xl),
                        StoreLocationSection(),
                        const SizedBox(height: AppSpacing.xl),
                        StoreHoursSection(),
                      ].animate(interval: 50.ms).fade(duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
                    ),
                  ),
                  if (manageState.isEditMode)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            offset: const Offset(0, -4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: AppButton.primary(
                          label: 'Save Changes',
                          isLoading: manageState.isSaving,
                          onPressed: () async {
                            final success = await ref
                                .read(manageStoreControllerProvider.notifier)
                                .saveChanges();
                            if (success && context.mounted) {
                              AppSnackbar.show(
                                context,
                                message: 'Changes saved successfully',
                                variant: SnackbarVariant.success,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
