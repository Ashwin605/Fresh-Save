import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../../../../core/network/image_url_resolver.dart';
import '../../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import '../../domain/models/store_product_model.dart';
import '../providers/category_list_provider.dart';
import '../providers/owner_state_provider.dart';
import '../providers/owner_product_list_provider.dart';
import '../providers/inventory_list_provider.dart';
import '../../data/repositories/owner_product_repository_provider.dart';

class OwnerEditProductScreen extends ConsumerStatefulWidget {
  final StoreProduct? initialProduct;
  final String? productId;

  const OwnerEditProductScreen({
    super.key,
    this.initialProduct,
    this.productId,
  });

  @override
  ConsumerState<OwnerEditProductScreen> createState() =>
      _OwnerEditProductScreenState();
}

class _OwnerEditProductScreenState extends ConsumerState<OwnerEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _descController;
  late final TextEditingController _brandController;
  late final TextEditingController _unitController;
  late final TextEditingController _skuController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _originalPriceController;
  late final TextEditingController _stockQuantityController;
  late final TextEditingController _batchNumberController;
  late final TextEditingController _imageUrlController;

  // Selection & State
  StoreProduct? _currentProduct;
  bool _isLoadingProduct = false;
  OwnerProductCategory? _selectedCategory;
  OwnerProductCategory? _selectedSubcategory;
  DateTime? _expiryDate;
  DateTime? _mfgDate;
  String _selectedStatus = 'ACTIVE';

  // Image Upload State
  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImage;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _currentProduct = widget.initialProduct;

    _nameController = TextEditingController(text: _currentProduct?.name ?? '');
    _descController = TextEditingController(text: _currentProduct?.description ?? '');
    _brandController = TextEditingController(text: _currentProduct?.brand ?? '');
    _unitController = TextEditingController(text: _currentProduct?.unit ?? '');
    _skuController = TextEditingController(text: _currentProduct?.sku ?? '');
    _barcodeController = TextEditingController(text: _currentProduct?.barcode ?? '');
    _sellingPriceController = TextEditingController(
      text: _currentProduct != null ? _currentProduct!.sellingPrice.toStringAsFixed(2) : '',
    );
    _originalPriceController = TextEditingController(
      text: _currentProduct != null ? _currentProduct!.originalPrice.toStringAsFixed(2) : '',
    );
    _stockQuantityController = TextEditingController(
      text: _currentProduct != null ? _currentProduct!.stockQuantity.toString() : '0',
    );
    _batchNumberController = TextEditingController(text: _currentProduct?.batchNumber ?? '');
    _imageUrlController = TextEditingController(text: _currentProduct?.image ?? '');
    _uploadedImageUrl = _currentProduct?.image;
    _selectedStatus = _currentProduct?.status ?? 'ACTIVE';

    if (_currentProduct?.expiryDate != null) {
      _expiryDate = _currentProduct!.expiryDate;
    }
    if (_currentProduct?.manufacturingDate != null) {
      _mfgDate = _currentProduct!.manufacturingDate;
    }

    if (_currentProduct == null && widget.productId != null) {
      _loadProductDetails();
    }
  }

  Future<void> _loadProductDetails() async {
    final activeStore = ref.read(ownerStateProvider).activeStore;
    if (activeStore == null || widget.productId == null) return;

    setState(() => _isLoadingProduct = true);
    final repo = ref.read(ownerProductRepositoryProvider);
    final result = await repo.getStoreProductDetails(activeStore.id, widget.productId!);

    if (!mounted) return;
    setState(() => _isLoadingProduct = false);

    result.when(
      success: (product) {
        setState(() {
          _currentProduct = product;
          _nameController.text = product.name;
          _descController.text = product.description ?? '';
          _brandController.text = product.brand ?? '';
          _unitController.text = product.unit ?? '';
          _skuController.text = product.sku ?? '';
          _barcodeController.text = product.barcode ?? '';
          _sellingPriceController.text = product.sellingPrice.toStringAsFixed(2);
          _originalPriceController.text = product.originalPrice.toStringAsFixed(2);
          _stockQuantityController.text = product.stockQuantity.toString();
          _batchNumberController.text = product.batchNumber ?? '';
          _imageUrlController.text = product.image ?? '';
          _uploadedImageUrl = product.image;
          _selectedStatus = product.status;
          if (product.expiryDate != null) {
            _expiryDate = product.expiryDate;
          }
          if (product.manufacturingDate != null) {
            _mfgDate = product.manufacturingDate;
          }
        });
      },
      failure: (error) {
        AppSnackbar.show(
          context,
          message: error.message ?? 'Failed to load product details',
          variant: SnackbarVariant.error,
        );
      },
    );
  }

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
      final filename = picked.name.isNotEmpty
          ? picked.name
          : 'product_${DateTime.now().millisecondsSinceEpoch}.jpg';

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

      if (!mounted) return;
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
              message: 'Product image updated successfully!',
              variant: SnackbarVariant.success,
            );
          }
        },
        failure: (error) {
          if (mounted) {
            AppSnackbar.show(
              context,
              message: 'Image upload failed: ${error.message}',
              variant: SnackbarVariant.error,
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isUploadingImage = false);
        AppSnackbar.show(
          context,
          message: 'Error selecting image: $e',
          variant: SnackbarVariant.error,
        );
      }
    }
  }

  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Product Image',
                style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
              ListTile(
                leading: const Icon(Icons.photo_camera, color: AppColors.primary),
                title: const Text('Take a photo with camera'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primary),
                title: const Text('Choose from photo gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickAndUploadImage(ImageSource.gallery);
                },
              ),
              if (_uploadedImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: AppColors.error),
                  title: const Text(
                    'Remove Image',
                    style: TextStyle(color: AppColors.error),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _uploadedImageUrl = null;
                      _imageUrlController.clear();
                      _pickedImage = null;
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? now.add(const Duration(days: 30)),
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  Future<void> _selectMfgDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _mfgDate ?? now.subtract(const Duration(days: 7)),
      firstDate: now.subtract(const Duration(days: 365 * 3)),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _mfgDate = picked);
    }
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) {
      AppSnackbar.show(
        context,
        message: 'Please resolve validation errors before saving.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    final sellingPrice = double.tryParse(_sellingPriceController.text.trim());
    final originalPrice = double.tryParse(_originalPriceController.text.trim());

    if (sellingPrice == null || sellingPrice <= 0) {
      AppSnackbar.show(
        context,
        message: 'Please provide a valid selling price greater than 0.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    if (originalPrice == null || originalPrice <= 0) {
      AppSnackbar.show(
        context,
        message: 'Please provide a valid original price (MRP) greater than 0.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    if (sellingPrice > originalPrice) {
      AppSnackbar.show(
        context,
        message: 'Selling price cannot exceed the original price (MRP).',
        variant: SnackbarVariant.error,
      );
      return;
    }

    final stock = int.tryParse(_stockQuantityController.text.trim());
    if (stock == null || stock < 0) {
      AppSnackbar.show(
        context,
        message: 'Stock quantity cannot be negative.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    final activeStore = ref.read(ownerStateProvider).activeStore;
    if (activeStore == null) {
      AppSnackbar.show(
        context,
        message: 'No active store selected.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    final identifier = _currentProduct?.id ?? widget.productId;
    if (identifier == null) {
      AppSnackbar.show(
        context,
        message: 'Missing product identifier.',
        variant: SnackbarVariant.error,
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final categoryIdToSave = _selectedSubcategory?.id ??
        _selectedCategory?.id ??
        _currentProduct?.categoryId;

    final repo = ref.read(ownerProductRepositoryProvider);
    final result = await repo.updateStoreProduct(
      activeStore.id,
      identifier,
      name: _nameController.text.trim(),
      categoryId: categoryIdToSave,
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      brand: _brandController.text.trim().isEmpty
          ? null
          : _brandController.text.trim(),
      unit: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      sku: _skuController.text.trim().isEmpty
          ? null
          : _skuController.text.trim(),
      barcode: _barcodeController.text.trim().isEmpty
          ? null
          : _barcodeController.text.trim(),
      image: _uploadedImageUrl ??
          (_imageUrlController.text.trim().isNotEmpty
              ? _imageUrlController.text.trim()
              : null),
      sellingPrice: sellingPrice,
      originalPrice: originalPrice,
      stockQuantity: stock,
      expiryDate: _expiryDate?.toIso8601String(),
      manufacturingDate: _mfgDate?.toIso8601String(),
      batchNumber: _batchNumberController.text.trim().isEmpty
          ? null
          : _batchNumberController.text.trim(),
      inventoryStatus: _selectedStatus,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      success: (updatedProduct) {
        ref.invalidate(ownerStoreProductListProvider);
        ref.invalidate(inventoryListProvider);

        AppSnackbar.show(
          context,
          message: 'Product "${updatedProduct.name}" updated successfully!',
          variant: SnackbarVariant.success,
        );

        Navigator.of(context).pop(updatedProduct);
      },
      failure: (error) {
        AppSnackbar.show(
          context,
          message: error.message ?? 'Failed to update product',
          variant: SnackbarVariant.error,
        );
      },
    );
  }

  Future<void> _confirmDelete() async {
    final activeStore = ref.read(ownerStateProvider).activeStore;
    final identifier = _currentProduct?.id ?? widget.productId;
    if (activeStore == null || identifier == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove from Store?'),
        content: Text(
          'Are you sure you want to remove "${_nameController.text}" from your store catalog? This will mark the inventory inactive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Remove Product', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isSubmitting = true);
    final repo = ref.read(ownerProductRepositoryProvider);
    final result = await repo.removeStoreProduct(activeStore.id, identifier);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.when(
      success: (_) {
        ref.invalidate(ownerStoreProductListProvider);
        ref.invalidate(inventoryListProvider);
        AppSnackbar.show(
          context,
          message: 'Product removed from store catalog.',
          variant: SnackbarVariant.success,
        );
        Navigator.of(context).pop();
      },
      failure: (error) {
        AppSnackbar.show(
          context,
          message: error.message ?? 'Failed to remove product',
          variant: SnackbarVariant.error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingProduct) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final categoriesState = ref.watch(categoryListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            tooltip: 'Remove Product',
            onPressed: _isSubmitting ? null : _confirmDelete,
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              _buildImageSection(),
              const SizedBox(height: AppSpacing.md),
              _buildBasicInfoSection(categoriesState),
              const SizedBox(height: AppSpacing.md),
              _buildPricingSection(),
              const SizedBox(height: AppSpacing.md),
              _buildInventorySection(),
              const SizedBox(height: AppSpacing.md),
              _buildAdditionalDetailsSection(),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Save Changes',
                isLoading: _isSubmitting,
                onPressed: _isSubmitting ? null : _submitUpdate,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Product Image',
                style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton.icon(
                onPressed: _isUploadingImage ? null : _showImagePickerSheet,
                icon: const Icon(Icons.camera_alt_outlined, size: 18),
                label: Text(_uploadedImageUrl != null ? 'Change' : 'Upload'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: _isUploadingImage ? null : _showImagePickerSheet,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildImagePreviewWidget(),
                  ),
                ),
                if (_isUploadingImage)
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Center(
            child: Text(
              'Supports JPEG, PNG, WebP up to 5MB. Stored on server.',
              style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreviewWidget() {
    if (_pickedImage != null) {
      if (kIsWeb) {
        return Image.network(_pickedImage!.path, fit: BoxFit.cover);
      } else {
        return Image.file(File(_pickedImage!.path), fit: BoxFit.cover);
      }
    }

    if (_uploadedImageUrl != null && _uploadedImageUrl!.isNotEmpty) {
      final fullUrl = resolveImageUrl(_uploadedImageUrl);

      return Image.network(
        fullUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.broken_image_outlined,
          size: 48,
          color: AppColors.textDisabled,
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.add_a_photo_outlined,
          size: 40,
          color: AppColors.primary.withValues(alpha: 0.8),
        ),
        const SizedBox(height: 6),
        Text(
          'Select Photo',
          style: AppTypography.caption.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoSection(CategoryListState categoriesState) {
    if (categoriesState.isLoading) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceVariant),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    final allCategories = categoriesState.categories;
    final topLevelCategories = allCategories.where((c) => c.parentId == null).toList();

    // Auto-resolve category hierarchy from current product category ID
    if (_selectedCategory == null && _currentProduct?.categoryId != null) {
      final matchingCat = allCategories.where((c) => c.id == _currentProduct?.categoryId).firstOrNull;
      if (matchingCat != null) {
        if (matchingCat.parentId != null) {
          _selectedCategory = allCategories.where((c) => c.id == matchingCat.parentId).firstOrNull;
          _selectedSubcategory = matchingCat;
        } else {
          _selectedCategory = matchingCat;
        }
      }
    }

    final subcategories = _selectedCategory == null
        ? <OwnerProductCategory>[]
        : allCategories.where((c) => c.parentId == _selectedCategory!.id).toList();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Product Name *',
              hintText: 'e.g., Organic Whole Milk 1L',
              prefixIcon: const Icon(Icons.shopping_bag_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Product name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<OwnerProductCategory>(
            initialValue: _selectedCategory,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Category *',
              prefixIcon: const Icon(Icons.category_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            hint: const Text('Select a category'),
            items: topLevelCategories.map((cat) {
              return DropdownMenuItem(
                value: cat,
                child: Text(cat.name),
              );
            }).toList(),
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
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Subcategory (Optional)',
                prefixIcon: const Icon(Icons.subdirectory_arrow_right),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              hint: const Text('Select a subcategory'),
              items: subcategories.map((sub) {
                return DropdownMenuItem(
                  value: sub,
                  child: Text(sub.name),
                );
              }).toList(),
              onChanged: (sub) => setState(() => _selectedSubcategory = sub),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(
                    labelText: 'Brand',
                    hintText: 'e.g., Amul, Nestle',
                    prefixIcon: const Icon(Icons.branding_watermark_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _unitController,
                  decoration: InputDecoration(
                    labelText: 'Package / Unit',
                    hintText: 'e.g., 500 g, 1 L',
                    prefixIcon: const Icon(Icons.straighten_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _descController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Details about the product, ingredients, etc.',
              prefixIcon: const Icon(Icons.description_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    final selling = double.tryParse(_sellingPriceController.text.trim()) ?? 0;
    final orig = double.tryParse(_originalPriceController.text.trim()) ?? 0;
    final discount = (orig > selling && orig > 0)
        ? (((orig - selling) / orig) * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pricing & Discounts',
                style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
              ),
              if (discount > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$discount% OFF',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
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
                  controller: _sellingPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Selling Price (₹) *',
                    hintText: '0.00',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    final num = double.tryParse(val.trim());
                    if (num == null || num <= 0) return 'Must be > 0';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _originalPriceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Original MRP (₹) *',
                    hintText: '0.00',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onChanged: (_) => setState(() {}),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    final num = double.tryParse(val.trim());
                    if (num == null || num <= 0) return 'Must be > 0';
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Selling price is the final cost charged to the customer. Original MRP shows discount savings.',
            style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildInventorySection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Inventory & Availability',
            style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _stockQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Stock Quantity *',
                    hintText: '0',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Required';
                    final num = int.tryParse(val.trim());
                    if (num == null || num < 0) return 'Must be >= 0';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    prefixIcon: const Icon(Icons.toggle_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'ACTIVE', child: Text('Active (Live)')),
                    DropdownMenuItem(value: 'INACTIVE', child: Text('Inactive (Hidden)')),
                    DropdownMenuItem(value: 'OUT_OF_STOCK', child: Text('Out of Stock')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedStatus = val);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: _selectExpiryDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _expiryDate != null
                          ? DateFormat('dd MMM yyyy').format(_expiryDate!)
                          : 'Select Date',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: InkWell(
                  onTap: _selectMfgDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Mfg Date',
                      prefixIcon: const Icon(Icons.factory_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _mfgDate != null
                          ? DateFormat('dd MMM yyyy').format(_mfgDate!)
                          : 'Select Date',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Batch & Identification (Optional)',
            style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _batchNumberController,
            decoration: InputDecoration(
              labelText: 'Batch Number',
              hintText: 'e.g., BATCH-2026-OCT',
              prefixIcon: const Icon(Icons.numbers_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _skuController,
                  decoration: InputDecoration(
                    labelText: 'SKU',
                    hintText: 'e.g., SKU-1002',
                    prefixIcon: const Icon(Icons.qr_code_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  controller: _barcodeController,
                  decoration: InputDecoration(
                    labelText: 'Barcode',
                    hintText: 'e.g., 890123456789',
                    prefixIcon: const Icon(Icons.barcode_reader),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
