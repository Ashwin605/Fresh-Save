import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../../core/network/result.dart';
import '../../../domain/models/owner_product_models.dart';
import '../../../data/repositories/owner_product_repository_provider.dart';
import '../../providers/owner_product_list_provider.dart';
import 'package:go_router/go_router.dart';

class AddProductDialog extends ConsumerStatefulWidget {
  final OwnerProductCategory category;

  const AddProductDialog({super.key, required this.category});

  @override
  ConsumerState<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends ConsumerState<AddProductDialog> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _brandController = TextEditingController();
  final _unitController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _brandController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    
    final result = await ref.read(ownerProductRepositoryProvider).createProduct(
      name: name,
      categoryId: widget.category.id,
      description: _descController.text.trim(),
      brand: _brandController.text.trim(),
      unit: _unitController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      result.map(
        success: (success) {
          ref.invalidate(ownerProductListProvider); // Reload products
          context.pop(success.data);
        },
        failure: (failure) {
          AppSnackbar.show(context, message: failure.error.message ?? 'Failed to create product', variant: SnackbarVariant.error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${widget.category.name}', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _nameController,
              labelText: 'Product Name',
              hintText: 'e.g. Organic Milk',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _brandController,
              labelText: 'Brand (Optional)',
              hintText: 'e.g. Amul',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _unitController,
              labelText: 'Unit (Optional)',
              hintText: 'e.g. 1L, 500g',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _descController,
              labelText: 'Description (Optional)',
              maxLines: 2,
            ),
          ],
        ),
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
