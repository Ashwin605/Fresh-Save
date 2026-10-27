import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_animate/flutter_animate.dart';

class AdminStoresScreen extends ConsumerStatefulWidget {
  const AdminStoresScreen({super.key});

  @override
  ConsumerState<AdminStoresScreen> createState() => _AdminStoresScreenState();
}

class _AdminStoresScreenState extends ConsumerState<AdminStoresScreen> {
  int _currentPage = 1;
  String _searchQuery = '';
  String _filterVerification = 'ALL';

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

  void _inspectStoreDetails(Map<String, dynamic> store) {
    showDialog(
      context: context,
      builder: (context) => _StoreDetailsDialog(
        store: store,
        onStatusChange: (status) {
          _updateStoreStatus(store['id'], status);
        },
      ),
    );
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Store Management',
                  style: AppTypography.headline.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Search & Filter controls
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by store name or owner email...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Wrap(
                  spacing: 8,
                  children: ['ALL', 'PENDING', 'VERIFIED', 'REJECTED', 'SUSPENDED'].map((filter) {
                    final isSelected = _filterVerification == filter;
                    return ChoiceChip(
                      label: Text(filter, style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      )),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) setState(() => _filterVerification = filter);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
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
                  final List allStores = data['data'] ?? [];
                  final total = data['total'] as int? ?? 0;
                  final totalPages = (total / 20).ceil();

                  final stores = allStores.where((store) {
                    final name = (store['name'] ?? '').toString().toLowerCase();
                    final email = (store['business']?['owner']?['email'] ?? '').toString().toLowerCase();
                    final vStatus = (store['verificationStatus'] ?? 'PENDING').toString();

                    final matchesSearch = _searchQuery.isEmpty ||
                        name.contains(_searchQuery.toLowerCase()) ||
                        email.contains(_searchQuery.toLowerCase());
                    final matchesStatus = _filterVerification == 'ALL' || vStatus == _filterVerification;
                    return matchesSearch && matchesStatus;
                  }).toList();

                  if (stores.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Text('No stores match the current filters.', style: TextStyle(color: AppColors.textSecondary))),
                    );
                  }

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
                          DataCell(
                            InkWell(
                              onTap: () => _inspectStoreDetails(store),
                              child: Text(
                                store['name'] ?? 'N/A',
                                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                              ),
                            ),
                          ),
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
                                if (value == 'DETAILS') {
                                  _inspectStoreDetails(store);
                                } else if (value == 'EDIT') {
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
                                  value: 'DETAILS',
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('View Details'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'EDIT',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                                      SizedBox(width: 8),
                                      Text('Edit Store'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'VERIFIED',
                                  child: Row(
                                    children: [
                                      Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                                      SizedBox(width: 8),
                                      Text('Approve (VERIFIED)', style: TextStyle(color: AppColors.success)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'ACTIVE',
                                  child: Row(
                                    children: [
                                      Icon(Icons.play_circle_outline, size: 18, color: AppColors.primary),
                                      SizedBox(width: 8),
                                      Text('Activate (ACTIVE)', style: TextStyle(color: AppColors.primary)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'REJECTED',
                                  child: Row(
                                    children: [
                                      Icon(Icons.cancel_outlined, size: 18, color: AppColors.error),
                                      SizedBox(width: 8),
                                      Text('Reject Application', style: TextStyle(color: AppColors.error)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'SUSPENDED',
                                  child: Row(
                                    children: [
                                      Icon(Icons.pause_circle_outline, size: 18, color: AppColors.error),
                                      SizedBox(width: 8),
                                      Text('Suspend', style: TextStyle(color: AppColors.error)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'DELETE',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                                      SizedBox(width: 8),
                                      Text('Delete Store', style: TextStyle(color: AppColors.error)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> store;
  final ValueChanged<String> onStatusChange;

  const _StoreDetailsDialog({required this.store, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    final owner = store['business']?['owner'];
    final vStatus = store['verificationStatus'] ?? 'PENDING';
    final status = store['status'] ?? 'ACTIVE';

    Color vColor = AppColors.textSecondary;
    if (vStatus == 'VERIFIED') vColor = AppColors.success;
    if (vStatus == 'REJECTED' || vStatus == 'SUSPENDED') vColor = AppColors.error;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              store['name'] ?? 'Store Details',
              style: AppTypography.headline.copyWith(color: AppColors.textPrimary, fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: vColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              vStatus,
              style: TextStyle(color: vColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('Store ID', store['id'] ?? 'N/A'),
              _detailRow('Operational Status', status),
              _detailRow('Address', store['address'] ?? 'Not specified'),
              _detailRow('Phone', store['phone'] ?? 'N/A'),
              _detailRow('Email', store['email'] ?? 'N/A'),
              _detailRow('Description', store['description'] ?? 'No description provided'),
              const Divider(height: 24),
              Text('Shopkeeper & Business Information', style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              _detailRow('Owner Name', owner?['name'] ?? 'N/A'),
              _detailRow('Owner Email', owner?['email'] ?? 'N/A'),
              _detailRow('Business Name', store['business']?['businessName'] ?? 'N/A'),
              const Divider(height: 24),
              _detailRow('Created At', store['createdAt'] != null ? DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(store['createdAt'])) : 'N/A'),
            ],
          ),
        ),
      ),
      actions: [
        if (vStatus != 'VERIFIED')
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            icon: const Icon(Icons.check, size: 16, color: Colors.white),
            label: const Text('Approve', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              onStatusChange('VERIFIED');
            },
          ),
        if (vStatus != 'REJECTED')
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            icon: const Icon(Icons.close, size: 16),
            label: const Text('Reject'),
            onPressed: () {
              Navigator.pop(context);
              onStatusChange('REJECTED');
            },
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500, fontSize: 13)),
          ),
        ],
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
      final tempPassword = await ref.read(adminRepositoryProvider).createStore(
            name: _name,
            address: _address,
            ownerEmail: _ownerEmail,
            verifyInstantly: _verifyInstantly,
          );
      
      if (!mounted) return;
      widget.onSuccess();
      Navigator.of(context).pop();

      if (tempPassword != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => _TemporaryPasswordDialog(password: tempPassword),
        );
      } else {
        AppSnackbar.show(context, message: 'Store created successfully!');
      }
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

class _TemporaryPasswordDialog extends StatelessWidget {
  final String password;
  const _TemporaryPasswordDialog({required this.password});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Store Created Successfully', style: AppTypography.headline.copyWith(color: AppColors.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('The store and owner account were created successfully.'),
          const SizedBox(height: AppSpacing.md),
          const Text('Temporary Owner Password', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(password, style: const TextStyle(letterSpacing: 2, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Please provide this password to the store owner.'),
          const SizedBox(height: AppSpacing.sm),
          const Text('This password will not be shown again after closing this dialog.', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: password));
            AppSnackbar.show(context, message: 'Password copied');
          },
          child: const Text('Copy Password'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Done', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
