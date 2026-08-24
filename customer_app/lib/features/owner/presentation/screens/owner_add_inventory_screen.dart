import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/feedback/app_snackbar.dart';
import '../../domain/models/owner_product_models.dart';
import '../providers/category_list_provider.dart';
import '../providers/owner_product_list_provider.dart';
import '../../data/repositories/inventory_repository_provider.dart';
import '../providers/owner_state_provider.dart';
import '../widgets/inventory/add_product_dialog.dart';
import '../providers/inventory_list_provider.dart';
import '../../../../../core/network/result.dart';

class OwnerAddInventoryScreen extends ConsumerStatefulWidget {
  const OwnerAddInventoryScreen({super.key});

  @override
  ConsumerState<OwnerAddInventoryScreen> createState() => _OwnerAddInventoryScreenState();
}

class _OwnerAddInventoryScreenState extends ConsumerState<OwnerAddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  
  OwnerProductCategory? _selectedCategory;
  OwnerProductCategory? _selectedSubcategory;
  OwnerProduct? _selectedProduct;
  
  final _stockQuantityController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _batchNumberController = TextEditingController();
  DateTime? _expiryDate;
  DateTime? _mfgDate;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _stockQuantityController.dispose();
    _originalPriceController.dispose();
    _sellingPriceController.dispose();
    _batchNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isExpiry) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: isExpiry ? DateTime.now() : DateTime(2000),
      lastDate: isExpiry ? DateTime(2101) : DateTime.now(),
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
    if (!_formKey.currentState!.validate()) return;
    if (_selectedProduct == null) {
      AppSnackbar.show(context, message: 'Please select a product', variant: SnackbarVariant.warning);
      return;
    }
    if (_expiryDate == null) {
      AppSnackbar.show(context, message: 'Please select an expiry date', variant: SnackbarVariant.warning);
      return;
    }

    final storeId = ref.read(ownerStateProvider).activeStore?.id;
    if (storeId == null) {
      AppSnackbar.show(context, message: 'No active store selected', variant: SnackbarVariant.error);
      return;
    }

    setState(() => _isLoading = true);

    final result = await ref.read(inventoryRepositoryProvider).createInventory(
      storeId,
      productId: _selectedProduct!.id,
      stockQuantity: int.parse(_stockQuantityController.text),
      originalPrice: double.parse(_originalPriceController.text),
      sellingPrice: double.parse(_sellingPriceController.text),
      expiryDate: _expiryDate!.toIso8601String(),
      batchNumber: _batchNumberController.text.isNotEmpty ? _batchNumberController.text : null,
      manufacturingDate: _mfgDate?.toIso8601String(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      result.map(
        success: (_) {
          AppSnackbar.show(context, message: 'Inventory added successfully!', variant: SnackbarVariant.success);
          ref.read(inventoryListProvider.notifier).loadInitial(); // Refresh inventory list
          context.pop();
        },
        failure: (failure) {
          AppSnackbar.show(context, message: failure.error.message ?? 'Failed to add inventory', variant: SnackbarVariant.error);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryState = ref.watch(categoryListProvider);
    final productState = ref.watch(ownerProductListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Inventory', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Category Selection
            _buildSectionTitle('1. Select Main Category'),
            if (categoryState.isLoading)
              const CircularProgressIndicator()
            else
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<OwnerProductCategory>(
                      initialValue: _selectedCategory,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                      hint: const Text('Choose Main Category'),
                      items: categoryState.categories
                          .where((c) => c.parentId == null)
                          .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedCategory = val;
                          _selectedSubcategory = null;
                          _selectedProduct = null;
                        });
                        if (val != null) {
                          ref.read(ownerProductListFilterProvider.notifier).updateFilter('categoryId', val.id);
                        }
                      },
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: AppSpacing.lg),

            if (_selectedCategory != null) ...[
              _buildSectionTitle('2. Select Subcategory (Optional)'),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<OwnerProductCategory>(
                      initialValue: _selectedSubcategory,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                      hint: const Text('Choose Subcategory'),
                      items: categoryState.categories
                          .where((c) => c.parentId == _selectedCategory?.id)
                          .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedSubcategory = val;
                          _selectedProduct = null;
                        });
                        if (val != null) {
                          ref.read(ownerProductListFilterProvider.notifier).updateFilter('categoryId', val.id);
                        } else {
                          ref.read(ownerProductListFilterProvider.notifier).updateFilter('categoryId', _selectedCategory!.id);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Product Selection
            _buildSectionTitle(_selectedCategory != null ? '3. Select Product' : '2. Select Product'),
            productState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err', style: const TextStyle(color: AppColors.error)),
              data: (data) => Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<OwnerProduct>(
                      initialValue: _selectedProduct,
                      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                      hint: const Text('Choose Product'),
                      items: data.data.items.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
                      onChanged: _selectedCategory == null ? null : (val) => setState(() => _selectedProduct = val),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: AppColors.primary),
                    onPressed: _selectedCategory == null ? null : () async {
                      final targetCategory = _selectedSubcategory ?? _selectedCategory!;
                      final newProduct = await showDialog<OwnerProduct>(context: context, builder: (_) => AddProductDialog(category: targetCategory));
                      if (newProduct != null) {
                         setState(() => _selectedProduct = newProduct);
                      }
                    },
                  )
                ],
              ),
            ),
            if (_selectedCategory == null)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Please select a main category first', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),

            const SizedBox(height: AppSpacing.xl),

            // Inventory Details
            _buildSectionTitle('3. Inventory Details'),
            TextFormField(
              controller: _stockQuantityController,
              decoration: const InputDecoration(labelText: 'Stock Quantity', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : (int.tryParse(v) == null ? 'Invalid number' : null),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _originalPriceController,
                    decoration: const InputDecoration(labelText: 'Original Price', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : (double.tryParse(v) == null ? 'Invalid number' : null),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _sellingPriceController,
                    decoration: const InputDecoration(labelText: 'Discounted Selling Price', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : (double.tryParse(v) == null ? 'Invalid number' : null),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _batchNumberController,
              decoration: const InputDecoration(labelText: 'Batch Number (Optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Mfg Date (Optional)', border: OutlineInputBorder()),
                      child: Text(_mfgDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_mfgDate!)),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Expiry Date *', border: OutlineInputBorder()),
                      child: Text(_expiryDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(_expiryDate!)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              label: 'Save Inventory',
              isLoading: _isLoading,
              onPressed: _submit,
              variant: AppButtonVariant.primary,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
    );
  }
}
