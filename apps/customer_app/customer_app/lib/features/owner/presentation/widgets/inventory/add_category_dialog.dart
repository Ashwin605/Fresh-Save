import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../providers/category_list_provider.dart';
import 'package:go_router/go_router.dart';

class AddCategoryDialog extends ConsumerStatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  ConsumerState<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends ConsumerState<AddCategoryDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    final category = await ref.read(categoryListProvider.notifier).createCategory(
      name,
      _descController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (mounted) {
      if (category != null) {
        context.pop(category); // Return new category
      } else {
        AppSnackbar.show(context, message: 'Failed to create category', variant: SnackbarVariant.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            controller: _nameController,
            labelText: 'Category Name',
            hintText: 'e.g. Dairy',
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _descController,
            labelText: 'Description (Optional)',
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => context.pop(),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        AppButton(
          label: 'Create',
          isLoading: _isLoading,
          onPressed: _submit,
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }
}
