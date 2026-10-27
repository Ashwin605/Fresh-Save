import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../domain/models/owner_product_models.dart';
import '../providers/category_list_provider.dart';
import '../providers/owner_state_provider.dart';
import '../providers/owner_product_list_provider.dart';
import '../providers/inventory_list_provider.dart';
import '../../data/repositories/owner_product_repository_provider.dart';
import '../../../../../core/network/result.dart';
import '../../../../../core/network/image_url_resolver.dart';

class OwnerAddProductScreen extends ConsumerStatefulWidget {
  const OwnerAddProductScreen({super.key});

  @override
  ConsumerState<OwnerAddProductScreen> createState() =>
      _OwnerAddProductScreenState();
}

class _OwnerAddProductScreenState extends ConsumerState<OwnerAddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _brandController = TextEditingController();
  final _unitController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _stockQuantityController = TextEditingController(text: '10');
  final _batchNumberController = TextEditingController();
  final _imageUrlController = TextEditingController();

  // Selection state
  OwnerProductCategory? _selectedCategory;
  OwnerProductCategory? _selectedSubcategory;
  DateTime? _expiryDate;
  DateTime? _mfgDate;

  // Image Upload state
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _brandController.dispose();
    _unitController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _sellingPriceController.dispose();
    _originalPriceController.dispose();
    _stockQuantityController.dispose();
    _batchNumberController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (picked == null) return;

      setState(() {
        _pickedImage = picked;
        _isUploadingImage = true;
      });

      final repo = ref.read(ownerProductRepositoryProvider);
      final filename = picked.name.isNotEmpty ? picked.name : 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Result<String> uploadResult;
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        uploadResult = await repo.uploadProductImage(
          fileBytes: bytes,
          filename: filename,
        );
      } else {
        uploadResult = await repo.uploadProductImage(
          filePath: picked.path,
          filename: filename,
        );
      }

      setState(() => _isUploadingImage = false);

      uploadResult.when(
        success: (url) {
          setState(() {
            _uploadedImageUrl = url;
            _imageUrlController.text = url;
          });
          if (mounted) {
            AppSnackbar.show(
              context,
              message: 'Product image uploaded successfully!',
              variant: SnackbarVariant.success,
            );
          }
        },
        failure: (error) {
          if (mounted) {
            AppSnackbar.show(
              context,
              message: error.message ?? 'Image upload failed. You may also enter an image URL manually.',
              variant: SnackbarVariant.error,
            );
          }
        },
      );
    } catch (e) {
      setState(() => _isUploadingImage = false);
      if (mounted) {
        AppSnackbar.show(
          context,
          message: 'Error selecting image: $e',
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isExpiry) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isExpiry
          ? (_expiryDate ?? now.add(const Duration(days: 30)))
          : (_mfgDate ?? now.subtract(const Duration(days: 5))),
      firstDate: isExpiry ? now : DateTime(2000),
      lastDate: DateTime(now.year + 10),
    );

    if (picked != null) {
      setState(() {
        if (isExpiry) {
          _expiryDate = picked;
        } else {
          _mfgDate = picked;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedCategory == null) {
      AppSnackbar.show(
        context,
        message: 'Please select a main category',
        variant: SnackbarVariant.warning,
      );
      return;
    }

    if (_expiryDate == null) {
      AppSnackbar.show(
        context,
        message: 'Please select an expiry date',
        variant: SnackbarVariant.warning,
      );
      return;
    }

    final selling = double.tryParse(_sellingPriceController.text.trim()) ?? 0;
    final original = double.tryParse(_originalPriceController.text.trim()) ?? 0;
    if (selling <= 0 || original <= 0) {
      AppSnackbar.show(
        context,
        message: 'Prices must be greater than zero',
        variant: SnackbarVariant.warning,
      );
      return;
    }

    if (selling > original) {
      AppSnackbar.show(
        context,
        message: 'Selling price cannot exceed original price (MRP)',
        variant: SnackbarVariant.warning,
      );
      return;
    }

    if (_mfgDate != null && _expiryDate!.isBefore(_mfgDate!)) {
      AppSnackbar.show(
        context,
        message: 'Expiry date must be after manufacturing date',
        variant: SnackbarVariant.warning,
      );
      return;
    }

    final stock = int.tryParse(_stockQuantityController.text.trim()) ?? 0;
    if (stock < 0) {
      AppSnackbar.show(
        context,
        message: 'Stock quantity cannot be negative',
        variant: SnackbarVariant.warning,
      );
      return;
    }

    final storeId = ref.read(ownerStateProvider).activeStore?.id;
    if (storeId == null) {
      AppSnackbar.show(
        context,
        message: 'No active store selected',
        variant: SnackbarVariant.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Effective category: subcategory if chosen, else main category
    final targetCategoryId = _selectedSubcategory?.id ?? _selectedCategory!.id;
    final imageToSave = _uploadedImageUrl ??
        (_imageUrlController.text.trim().isNotEmpty
            ? _imageUrlController.text.trim()
            : null);

    final result = await ref.read(ownerProductRepositoryProvider).createStoreProduct(
      storeId,
      name: _nameController.text.trim(),
      categoryId: targetCategoryId,
      sellingPrice: selling,
      originalPrice: original,
      initialStockQuantity: stock,
      expiryDate: _expiryDate!.toIso8601String(),
      description: _descController.text.trim().isNotEmpty
          ? _descController.text.trim()
          : null,
      brand: _brandController.text.trim().isNotEmpty
          ? _brandController.text.trim()
          : null,
      unit: _unitController.text.trim().isNotEmpty
          ? _unitController.text.trim()
          : null,
      sku: _skuController.text.trim().isNotEmpty
          ? _skuController.text.trim()
          : null,
      barcode: _barcodeController.text.trim().isNotEmpty
          ? _barcodeController.text.trim()
          : null,
      image: imageToSave,
      manufacturingDate: _mfgDate?.toIso8601String(),
      batchNumber: _batchNumberController.text.trim().isNotEmpty
          ? _batchNumberController.text.trim()
          : null,
    );

    setState(() => _isSubmitting = false);

    if (mounted) {
      result.when(
        success: (created) {
          // Invalidate lists so both product management and inventory screens update
          ref.invalidate(ownerStoreProductListProvider);
          ref.invalidate(inventoryListProvider);
          AppSnackbar.show(
            context,
            message: 'Product "${created.name}" added to your store!',
            variant: SnackbarVariant.success,
          );
          context.pop(created);
        },
        failure: (error) {
          AppSnackbar.show(
            context,
            message: error.message ?? 'Failed to add product. Please check your inputs.',
            variant: SnackbarVariant.error,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryListProvider);
    final activeStore = ref.watch(ownerStateProvider).activeStore;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Product to Store', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              if (activeStore != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.storefront, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Adding product to: ${activeStore.name}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // ── Image Section ─────────────────────────────────────
              _buildSectionHeader('Product Image', Icons.photo_camera_outlined),
              _buildImagePickerSection(),
              const SizedBox(height: AppSpacing.lg),

              // ── Basic Info Section ───────────────────────────────
              _buildSectionHeader('Basic Information', Icons.info_outline),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name *',
                  hintText: 'e.g. Organic Standard Milk',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Product name is required' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Categories
              _buildCategoryDropdowns(categoryState),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _brandController,
                      decoration: const InputDecoration(
                        labelText: 'Brand (Optional)',
                        hintText: 'e.g. Amul, Nestlé',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Package / Unit *',
                        hintText: 'e.g. 500g, 1L, 1 pc',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Unit is required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Product Description (Optional)',
                  hintText: 'Detailed description of ingredients, quality, or freshness',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Pricing & Stock Section ──────────────────────────
              _buildSectionHeader('Pricing & Initial Inventory', Icons.currency_rupee),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _originalPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Original Price (MRP) *',
                        hintText: '₹0.00',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final num = double.tryParse(v.trim());
                        if (num == null || num <= 0) return 'Invalid price';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _sellingPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Selling Price *',
                        hintText: '₹0.00',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';
                        final num = double.tryParse(v.trim());
                        if (num == null || num <= 0) return 'Invalid price';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _stockQuantityController,
                decoration: const InputDecoration(
                  labelText: 'Initial Stock Quantity *',
                  hintText: 'Number of units',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  final num = int.tryParse(v.trim());
                  if (num == null || num < 0) return 'Invalid quantity';
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── Expiry & Batch Section ───────────────────────────
              _buildSectionHeader('Batch & Expiry Dates', Icons.calendar_today_outlined),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, false),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Mfg Date (Optional)',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _mfgDate == null
                              ? 'Select Date'
                              : DateFormat('MMM dd, yyyy').format(_mfgDate!),
                          style: TextStyle(
                            color: _mfgDate == null
                                ? AppColors.textDisabled
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context, true),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Expiry Date *',
                          border: OutlineInputBorder(),
                        ),
                        child: Text(
                          _expiryDate == null
                              ? 'Select Date *'
                              : DateFormat('MMM dd, yyyy').format(_expiryDate!),
                          style: TextStyle(
                            color: _expiryDate == null
                                ? AppColors.error
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _batchNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Batch Number (Optional)',
                        hintText: 'e.g. BATCH-2026-X1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // ── SKU & Barcode Section ────────────────────────────
              _buildSectionHeader('Identifiers (Optional)', Icons.qr_code_outlined),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _skuController,
                      decoration: const InputDecoration(
                        labelText: 'SKU (Optional)',
                        hintText: 'Unique SKU',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: TextFormField(
                      controller: _barcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Barcode / EAN (Optional)',
                        hintText: '890...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Submit Button
              AppButton(
                label: 'Save & Publish Product',
                isLoading: _isSubmitting,
                onPressed: _submit,
                variant: AppButtonVariant.primary,
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTypography.title.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isUploadingImage) ...[
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 8),
                    Text('Uploading image to secure storage...'),
                  ],
                ),
              ),
            ),
          ] else if (_uploadedImageUrl != null || _pickedImage != null) ...[
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _uploadedImageUrl != null
                      ? Image.network(
                          resolveImageUrl(_uploadedImageUrl!),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
                        )
                      : (kIsWeb
                          ? const Icon(Icons.image, size: 80)
                          : Image.file(
                              File(_pickedImage!.path),
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            )),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Image Selected',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _uploadedImageUrl ?? 'Ready for upload',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.photo_library, size: 16),
                            label: const Text('Change'),
                            onPressed: () => _pickAndUploadImage(ImageSource.gallery),
                          ),
                          TextButton.icon(
                            icon: const Icon(Icons.delete_outline, size: 16, color: AppColors.error),
                            label: const Text('Remove', style: TextStyle(color: AppColors.error)),
                            onPressed: () {
                              setState(() {
                                _pickedImage = null;
                                _uploadedImageUrl = null;
                                _imageUrlController.clear();
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Choose from Gallery'),
                    onPressed: () => _pickAndUploadImage(ImageSource.gallery),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Take Photo'),
                    onPressed: () => _pickAndUploadImage(ImageSource.camera),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Or enter Image URL directly',
                hintText: 'https://...',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) {
                if (val.trim().isNotEmpty) {
                  setState(() => _uploadedImageUrl = val.trim());
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryDropdowns(CategoryListState categoryState) {
    if (categoryState.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final topLevelCategories = categoryState.categories
        .where((c) => c.parentId == null)
        .toList();

    final subcategories = _selectedCategory == null
        ? <OwnerProductCategory>[]
        : categoryState.categories
            .where((c) => c.parentId == _selectedCategory!.id)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<OwnerProductCategory>(
          initialValue: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'Main Category *',
            border: OutlineInputBorder(),
          ),
          hint: const Text('Select Main Category'),
          items: topLevelCategories
              .map((cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name),
                  ))
              .toList(),
          onChanged: (cat) {
            setState(() {
              _selectedCategory = cat;
              _selectedSubcategory = null;
            });
          },
          validator: (v) => v == null ? 'Please select a main category' : null,
        ),
        if (subcategories.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<OwnerProductCategory>(
            initialValue: _selectedSubcategory,
            decoration: const InputDecoration(
              labelText: 'Subcategory (Optional)',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Select Subcategory'),
            items: subcategories
                .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(cat.name),
                    ))
                .toList(),
            onChanged: (cat) {
              setState(() => _selectedSubcategory = cat);
            },
          ),
        ],
      ],
    );
  }
}
