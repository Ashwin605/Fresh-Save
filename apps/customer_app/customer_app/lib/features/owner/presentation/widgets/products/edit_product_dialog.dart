import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../../core/network/result.dart';
import '../../../domain/models/owner_product_models.dart';
import '../../../data/repositories/owner_product_repository_provider.dart';
import '../../providers/owner_product_detail_provider.dart';
import '../../providers/owner_product_list_provider.dart';

class EditProductDialog extends ConsumerStatefulWidget {
  final OwnerProduct product;

  const EditProductDialog({super.key, required this.product});

  @override
  ConsumerState<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends ConsumerState<EditProductDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _brandController;
  late final TextEditingController _unitController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _imageController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description ?? '');
    _brandController = TextEditingController(text: widget.product.brand ?? '');
    _unitController = TextEditingController(text: widget.product.unit ?? '');
    _skuController = TextEditingController(text: widget.product.sku ?? '');
    _barcodeController = TextEditingController(text: widget.product.barcode ?? '');
    _imageController = TextEditingController(text: widget.product.image ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _brandController.dispose();
    _unitController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      AppSnackbar.show(context, message: 'Product name cannot be empty', variant: SnackbarVariant.error);
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(ownerProductRepositoryProvider).updateProduct(
      widget.product.id,
      name: name,
      brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
      unit: _unitController.text.trim().isEmpty ? null : _unitController.text.trim(),
      description: _descController.text.trim().isEmpty ? null : _descController.text.trim(),
      sku: _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty ? null : _barcodeController.text.trim(),
      image: _imageController.text.trim().isEmpty ? null : _imageController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      result.map(
        success: (success) {
          ref.invalidate(ownerProductDetailProvider(widget.product.id));
          ref.invalidate(ownerProductListProvider);
          AppSnackbar.show(context, message: 'Product updated successfully', variant: SnackbarVariant.success);
          context.pop(success.data);
        },
        failure: (failure) {
          AppSnackbar.show(context, message: failure.error.message ?? 'Failed to update product', variant: SnackbarVariant.error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _nameController,
              labelText: 'Product Name',
              hintText: 'e.g. Organic Milk',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _brandController,
              labelText: 'Brand',
              hintText: 'e.g. Amul',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _unitController,
              labelText: 'Unit / Package Size',
              hintText: 'e.g. 500g, 1L, 1 pack',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _skuController,
              labelText: 'SKU (Optional)',
              hintText: 'Stock Keeping Unit',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _barcodeController,
              labelText: 'Barcode (Optional)',
              hintText: 'Barcode / EAN number',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _imageController,
              labelText: 'Image URL (Optional)',
              hintText: 'https://...',
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: _descController,
              labelText: 'Description',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Save Changes',
              isLoading: _isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
