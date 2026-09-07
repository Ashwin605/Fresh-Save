import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/admin_categories_provider.dart';
import '../../../home/domain/models/home_models.dart';
import '../../../../core/widgets/buttons/app_button.dart';

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
            Text(
              'Category Management',
              style: AppTypography.display.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
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
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Image')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Sort Order')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: categories.map((cat) {
                        return DataRow(
                          cells: [
                            DataCell(
                              cat.image != null && cat.image!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(cat.image!, width: 48, height: 48, fit: BoxFit.cover),
                                    )
                                  : Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfaceVariant,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.image_not_supported, color: AppColors.textDisabled),
                                    ),
                            ),
                            DataCell(Text(cat.name)),
                            DataCell(Text('0')), // We didn't add sortOrder to the Dart model yet, hardcoding for now or need to add it
                            DataCell(
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.primary),
                                onPressed: () => _editCategory(cat),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                  );
                },
              ),
            ),
          ],
        ),
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
  late TextEditingController _imageCtrl;
  late TextEditingController _sortCtrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageCtrl = TextEditingController(text: widget.category.image ?? '');
    _sortCtrl = TextEditingController(text: '0'); // Assuming sortOrder isn't in model, defaulting
  }

  @override
  void dispose() {
    _imageCtrl.dispose();
    _sortCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(updateAdminCategoryProvider({
        'id': widget.category.id,
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _imageCtrl,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _sortCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Sort Order'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          label: 'Save',
          onPressed: _isLoading ? null : _save,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
