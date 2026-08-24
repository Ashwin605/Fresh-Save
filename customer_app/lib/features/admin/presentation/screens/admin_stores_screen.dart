import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/layout/admin_data_table.dart';
import '../providers/admin_stores_provider.dart';
import '../../data/admin_repository.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';

class AdminStoresScreen extends ConsumerStatefulWidget {
  const AdminStoresScreen({super.key});

  @override
  ConsumerState<AdminStoresScreen> createState() => _AdminStoresScreenState();
}

class _AdminStoresScreenState extends ConsumerState<AdminStoresScreen> {
  int _currentPage = 1;

  void _updateStoreStatus(String id, String status) async {
    try {
      await ref.read(adminRepositoryProvider).updateStoreStatus(id, status);
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Store status updated to $status');
      ref.invalidate(adminStoresProvider(_currentPage));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    }
  }

  void _deleteStore(String id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Store'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(adminRepositoryProvider).deleteStore(id);
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Store deleted successfully');
      ref.invalidate(adminStoresProvider(_currentPage));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final storesState = ref.watch(adminStoresProvider(_currentPage));

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddStoreDialog(
              onSuccess: () => ref.invalidate(adminStoresProvider(_currentPage)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add Store', style: AppTypography.body.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Store Management',
              style: AppTypography.display.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            GlassSurface(
              child: storesState.when(
                loading: () => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 400,
                  child: Center(child: Text('Error: $err', style: TextStyle(color: AppColors.error))),
                ),
                data: (data) {
                  final List stores = data['data'] ?? [];
                  final total = data['total'] as int? ?? 0;
                  final totalPages = (total / 20).ceil();

                  return AdminDataTable(
                    currentPage: _currentPage,
                    totalPages: totalPages,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    columns: const [
                      DataColumn(label: Text('Store Name')),
                      DataColumn(label: Text('Owner Email')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Created')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: stores.map<DataRow>((store) {
                      final ownerEmail = store['business']?['owner']?['email'] ?? 'N/A';
                      final verificationStatus = store['verificationStatus'] ?? 'PENDING';
                      
                      Color statusColor = AppColors.textSecondary;
                      if (verificationStatus == 'VERIFIED') statusColor = AppColors.success;
                      if (verificationStatus == 'REJECTED' || verificationStatus == 'SUSPENDED') statusColor = AppColors.error;

                      return DataRow(
                        cells: [
                          DataCell(Text(store['name'] ?? 'N/A')),
                          DataCell(Text(ownerEmail)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                verificationStatus,
                                style: AppTypography.label.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataCell(Text(
                            store['createdAt'] != null 
                              ? DateFormat('MMM d, yyyy').format(DateTime.parse(store['createdAt'])) 
                              : 'N/A'
                          )),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                              onSelected: (value) {
                                if (value == 'EDIT') {
                                  showDialog(
                                    context: context,
                                    builder: (context) => EditStoreDialog(
                                      store: store,
                                      onSuccess: () => ref.invalidate(adminStoresProvider(_currentPage)),
                                    ),
                                  );
                                } else if (value == 'DELETE') {
                                  _deleteStore(store['id'], store['name']);
                                } else {
                                  _updateStoreStatus(store['id'], value);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'EDIT',
                                  child: Text('Edit Store'),
                                ),
                                const PopupMenuItem(
                                  value: 'VERIFIED',
                                  child: Text('Approve (VERIFIED)', style: TextStyle(color: AppColors.success)),
                                ),
                                const PopupMenuItem(
                                  value: 'REJECTED',
                                  child: Text('Reject', style: TextStyle(color: AppColors.error)),
                                ),
                                const PopupMenuItem(
                                  value: 'SUSPENDED',
                                  child: Text('Suspend', style: TextStyle(color: AppColors.error)),
                                ),
                                const PopupMenuItem(
                                  value: 'DELETE',
                                  child: Text('Delete Store', style: TextStyle(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
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

class AddStoreDialog extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;

  const AddStoreDialog({super.key, required this.onSuccess});

  @override
  ConsumerState<AddStoreDialog> createState() => _AddStoreDialogState();
}

class _AddStoreDialogState extends ConsumerState<AddStoreDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _address = '';
  String _ownerEmail = '';
  bool _verifyInstantly = true;
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await ref.read(adminRepositoryProvider).createStore(
            name: _name,
            address: _address,
            ownerEmail: _ownerEmail,
            verifyInstantly: _verifyInstantly,
          );
      
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Store created successfully!');
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Add New Store', style: AppTypography.headline.copyWith(color: AppColors.textPrimary)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Store Name', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _address = v!,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Owner Email', border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (!v.contains('@')) return 'Invalid email';
                  return null;
                },
                onSaved: (v) => _ownerEmail = v!,
              ),
              const SizedBox(height: AppSpacing.md),
              CheckboxListTile(
                title: const Text('Verify Instantly'),
                subtitle: const Text('Automatically marks business and store as verified.'),
                value: _verifyInstantly,
                onChanged: (v) => setState(() => _verifyInstantly = v ?? true),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Create Store', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

class EditStoreDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> store;
  final VoidCallback onSuccess;

  const EditStoreDialog({super.key, required this.store, required this.onSuccess});

  @override
  ConsumerState<EditStoreDialog> createState() => _EditStoreDialogState();
}

class _EditStoreDialogState extends ConsumerState<EditStoreDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _address;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name = widget.store['name'] ?? '';
    _address = widget.store['address'] ?? '';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await ref.read(adminRepositoryProvider).updateStore(
            storeId: widget.store['id'],
            name: _name,
            address: _address,
          );
      
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Store updated successfully!');
      widget.onSuccess();
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Edit Store', style: AppTypography.headline.copyWith(color: AppColors.textPrimary)),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Store Name', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _name = v!,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                onSaved: (v) => _address = v!,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: _isLoading 
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : const Text('Save Changes', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
