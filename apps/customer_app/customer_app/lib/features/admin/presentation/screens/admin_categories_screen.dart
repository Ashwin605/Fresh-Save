import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/network/image_url_resolver.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/admin_categories_provider.dart';
import '../../../home/domain/models/home_models.dart';

class AdminCategoriesScreen extends ConsumerStatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  ConsumerState<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends ConsumerState<AdminCategoriesScreen> {
  void _editCategory(Category category) {
    showDialog(
      context: context,
      builder: (context) => _EditCategoryDialog(category: category),
    ).then((updated) {
      if (updated == true) {
        ref.invalidate(adminCategoriesProvider);
      }
    });
  }

  void _createCategory(List<Category> existingCategories) {
    showDialog(
      context: context,
      builder: (context) => _CreateCategoryDialog(existingCategories: existingCategories),
    ).then((created) {
      if (created == true) {
        ref.invalidate(adminCategoriesProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesState = ref.watch(adminCategoriesProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Category Management',
                  style: AppTypography.display.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Category'),
                  onPressed: () {
                    final cats = categoriesState.value ?? [];
                    _createCategory(cats);
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            GlassSurface(
              child: categoriesState.when(
                loading: () => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 400,
                  child: Center(child: Text('Error: $err', style: TextStyle(color: AppColors.error))),
                ),
                data: (categories) {
                  // Build a flattened view showing parent and child relationships
                  final List<Widget> categoryRows = [];

                  for (final cat in categories) {
                    categoryRows.add(_buildCategoryTile(cat, isChild: false));
                    for (final child in cat.children) {
                      categoryRows.add(_buildCategoryTile(child, isChild: true, parentName: cat.name));
                    }
                  }

                  if (categoryRows.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Text('No categories registered yet.', style: TextStyle(color: AppColors.textSecondary))),
                    );
                  }

                  return Column(
                    children: categoryRows,
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Category cat, {required bool isChild, String? parentName}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.3))),
        color: isChild ? AppColors.surfaceVariant.withValues(alpha: 0.3) : Colors.transparent,
      ),
      padding: EdgeInsets.only(
        left: isChild ? 48.0 : 16.0,
        right: 16.0,
        top: 12.0,
        bottom: 12.0,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 44,
              height: 44,
              child: cat.image != null && cat.image!.isNotEmpty
                  ? AppNetworkImage(
                      imageUrl: resolveImageUrl(cat.image!),
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.surfaceVariant,
                      child: Icon(
                        isChild ? Icons.subdirectory_arrow_right : Icons.category_outlined,
                        color: AppColors.textDisabled,
                        size: 20,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontWeight: isChild ? FontWeight.w500 : FontWeight.bold,
                        fontSize: isChild ? 14 : 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (!isChild && cat.children.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${cat.children.length} subcategories',
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    if (isChild) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Subcategory of $parentName',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ],
                ),
                if (cat.description != null && cat.description!.isNotEmpty)
                  Text(
                    cat.description!,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
            onPressed: () => _editCategory(cat),
            tooltip: 'Edit Category',
          ),
        ],
      ),
    );
  }
}

class _EditCategoryDialog extends ConsumerStatefulWidget {
  final Category category;
  const _EditCategoryDialog({required this.category});

  @override
  ConsumerState<_EditCategoryDialog> createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends ConsumerState<_EditCategoryDialog> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _imageCtrl;
  late TextEditingController _sortCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category.name);
    _descCtrl = TextEditingController(text: widget.category.description ?? '');
    _imageCtrl = TextEditingController(text: widget.category.image ?? '');
    _sortCtrl = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    _sortCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(updateAdminCategoryProvider({
        'id': widget.category.id,
        'name': _nameCtrl.text.trim(),
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'image': _imageCtrl.text.trim(),
        'sortOrder': int.tryParse(_sortCtrl.text.trim()) ?? 0,
      }).future);
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Category updated successfully');
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit ${widget.category.name}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Category Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _imageCtrl,
              decoration: const InputDecoration(labelText: 'Image URL or Upload Path', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _sortCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sort Order', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Save Changes', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class _CreateCategoryDialog extends ConsumerStatefulWidget {
  final List<Category> existingCategories;
  const _CreateCategoryDialog({required this.existingCategories});

  @override
  ConsumerState<_CreateCategoryDialog> createState() => _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends ConsumerState<_CreateCategoryDialog> {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();
  final _sortCtrl = TextEditingController(text: '0');
  String? _selectedParentId;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _imageCtrl.dispose();
    _sortCtrl.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      AppSnackbar.show(context, message: 'Category name is required', variant: SnackbarVariant.warning);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(createAdminCategoryProvider({
        'name': name,
        'description': _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
        'image': _imageCtrl.text.trim().isNotEmpty ? _imageCtrl.text.trim() : null,
        'parentId': _selectedParentId,
        'sortOrder': int.tryParse(_sortCtrl.text.trim()) ?? 0,
      }).future);
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Category created successfully', variant: SnackbarVariant.success);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Category'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Category Name *', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String?>(
              initialValue: _selectedParentId,
              decoration: const InputDecoration(
                labelText: 'Parent Category (Optional for Subcategory)',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<String?>(
                  value: null,
                  child: Text('None (Top-Level Category)'),
                ),
                ...widget.existingCategories.map((c) => DropdownMenuItem<String?>(
                      value: c.id,
                      child: Text(c.name),
                    )),
              ],
              onChanged: (val) => setState(() => _selectedParentId = val),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description (Optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _imageCtrl,
              decoration: const InputDecoration(labelText: 'Image URL or Upload Path (Optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _sortCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Sort Order', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _isLoading ? null : _create,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text('Create Category', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
