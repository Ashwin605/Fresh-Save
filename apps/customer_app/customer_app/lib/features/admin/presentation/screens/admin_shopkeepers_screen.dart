import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/layout/admin_data_table.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../providers/admin_shopkeepers_provider.dart';
import '../../data/admin_repository.dart';

class AdminShopkeepersScreen extends ConsumerStatefulWidget {
  const AdminShopkeepersScreen({super.key});

  @override
  ConsumerState<AdminShopkeepersScreen> createState() => _AdminShopkeepersScreenState();
}

class _AdminShopkeepersScreenState extends ConsumerState<AdminShopkeepersScreen> {
  int _currentPage = 1;
  String _searchQuery = '';
  String _statusFilter = 'ALL';

  void _suspendUser(String userId, String name) async {
    final reasonCtrl = TextEditingController();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Suspend Account', style: AppTypography.headline.copyWith(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to suspend access for "$name"?'),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: reasonCtrl,
              decoration: const InputDecoration(
                labelText: 'Reason for suspension *',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              if (reasonCtrl.text.trim().isEmpty) {
                AppSnackbar.show(context, message: 'Please provide a reason', variant: SnackbarVariant.warning);
                return;
              }
              Navigator.pop(context, true);
            },
            child: const Text('Suspend', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(adminRepositoryProvider).suspendUser(userId, reasonCtrl.text.trim());
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Account suspended successfully', variant: SnackbarVariant.success);
      ref.invalidate(adminShopkeepersProvider(_currentPage));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    }
  }

  void _reinstateUser(String userId, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Restore Account Access', style: AppTypography.headline.copyWith(color: AppColors.textPrimary)),
        content: Text('Are you sure you want to restore platform access for "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restore Access', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ref.read(adminRepositoryProvider).reinstateUser(userId);
      if (!mounted) return;
      AppSnackbar.show(context, message: 'Account restored successfully', variant: SnackbarVariant.success);
      ref.invalidate(adminShopkeepersProvider(_currentPage));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    }
  }

  void _inspectShopkeeper(Map<String, dynamic> shopkeeper) {
    showDialog(
      context: context,
      builder: (context) => _ShopkeeperDetailsDialog(
        shopkeeper: shopkeeper,
        onSuspend: () => _suspendUser(shopkeeper['id'], shopkeeper['name'] ?? 'Shopkeeper'),
        onReinstate: () => _reinstateUser(shopkeeper['id'], shopkeeper['name'] ?? 'Shopkeeper'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopkeepersAsync = ref.watch(adminShopkeepersProvider(_currentPage));

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
                  'Shopkeeper Management',
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
                      hintText: 'Search by shopkeeper name or email...',
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
                  children: ['ALL', 'ACTIVE', 'SUSPENDED'].map((filter) {
                    final isSelected = _statusFilter == filter;
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
                        if (selected) setState(() => _statusFilter = filter);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            GlassSurface(
              child: shopkeepersAsync.when(
                loading: () => const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => SizedBox(
                  height: 400,
                  child: Center(child: Text('Error: $err', style: TextStyle(color: AppColors.error))),
                ),
                data: (data) {
                  final List allItems = (data['data'] as List?) ?? [];
                  final total = (data['total'] as int?) ?? allItems.length;
                  final totalPages = (total / 20).ceil();

                  final shopkeepers = allItems.where((item) {
                    final name = (item['name'] ?? '').toString().toLowerCase();
                    final email = (item['email'] ?? '').toString().toLowerCase();
                    final status = (item['status'] ?? 'ACTIVE').toString().toUpperCase();

                    final matchesSearch = _searchQuery.isEmpty ||
                        name.contains(_searchQuery.toLowerCase()) ||
                        email.contains(_searchQuery.toLowerCase());
                    final matchesStatus = _statusFilter == 'ALL' || status == _statusFilter;
                    return matchesSearch && matchesStatus;
                  }).toList();

                  if (shopkeepers.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Text('No shopkeepers match the selected filters.', style: TextStyle(color: AppColors.textSecondary))),
                    );
                  }

                  return AdminDataTable(
                    currentPage: _currentPage,
                    totalPages: totalPages > 0 ? totalPages : 1,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    columns: const [
                      DataColumn(label: Text('Shopkeeper')),
                      DataColumn(label: Text('Email & Phone')),
                      DataColumn(label: Text('Associated Stores')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Registered')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: shopkeepers.map<DataRow>((user) {
                      final status = user['status'] ?? 'ACTIVE';
                      final isSuspended = status == 'SUSPENDED';
                      final isAct = status == 'ACTIVE';

                      Color statusColor = AppColors.textSecondary;
                      if (isAct) statusColor = AppColors.success;
                      if (isSuspended) statusColor = AppColors.error;

                      // Extract businesses & stores
                      final businesses = user['businesses'] as List? ?? [];
                      final stores = <Map<String, dynamic>>[];
                      for (final b in businesses) {
                        final bStores = b['stores'] as List? ?? [];
                        for (final s in bStores) {
                          stores.add(s as Map<String, dynamic>);
                        }
                      }

                      final storeCountText = stores.isEmpty
                          ? '0 Stores'
                          : '${stores.length} Store${stores.length > 1 ? 's' : ''} (${stores.map((s) => s['name']).take(2).join(', ')})';

                      return DataRow(
                        cells: [
                          DataCell(
                            InkWell(
                              onTap: () => _inspectShopkeeper(user),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                    child: Text(
                                      (user['name'] ?? 'U').toString().substring(0, 1).toUpperCase(),
                                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    user['name'] ?? 'Shopkeeper',
                                    style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(user['email'] ?? 'N/A', style: const TextStyle(fontSize: 13)),
                                if (user['phone'] != null && user['phone'].toString().isNotEmpty)
                                  Text(user['phone'], style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                storeCountText,
                                style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                status,
                                style: AppTypography.label.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataCell(Text(
                            user['createdAt'] != null
                                ? DateFormat('MMM d, yyyy').format(DateTime.parse(user['createdAt']))
                                : 'N/A',
                            style: const TextStyle(fontSize: 13),
                          )),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                              onSelected: (value) {
                                if (value == 'DETAILS') {
                                  _inspectShopkeeper(user);
                                } else if (value == 'SUSPEND') {
                                  _suspendUser(user['id'], user['name'] ?? 'Shopkeeper');
                                } else if (value == 'REINSTATE') {
                                  _reinstateUser(user['id'], user['name'] ?? 'Shopkeeper');
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
                                if (!isSuspended)
                                  const PopupMenuItem(
                                    value: 'SUSPEND',
                                    child: Row(
                                      children: [
                                        Icon(Icons.block, size: 18, color: AppColors.error),
                                        SizedBox(width: 8),
                                        Text('Suspend Access', style: TextStyle(color: AppColors.error)),
                                      ],
                                    ),
                                  ),
                                if (isSuspended)
                                  const PopupMenuItem(
                                    value: 'REINSTATE',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                                        SizedBox(width: 8),
                                        Text('Restore Access', style: TextStyle(color: AppColors.success)),
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

class _ShopkeeperDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> shopkeeper;
  final VoidCallback onSuspend;
  final VoidCallback onReinstate;

  const _ShopkeeperDetailsDialog({
    required this.shopkeeper,
    required this.onSuspend,
    required this.onReinstate,
  });

  @override
  Widget build(BuildContext context) {
    final status = shopkeeper['status'] ?? 'ACTIVE';
    final isSuspended = status == 'SUSPENDED';
    final businesses = shopkeeper['businesses'] as List? ?? [];

    Color statusColor = AppColors.textSecondary;
    if (status == 'ACTIVE') statusColor = AppColors.success;
    if (isSuspended) statusColor = AppColors.error;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              shopkeeper['name'] ?? 'Shopkeeper Details',
              style: AppTypography.headline.copyWith(color: AppColors.textPrimary, fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _detailRow('User ID', shopkeeper['id'] ?? 'N/A'),
              _detailRow('Email', shopkeeper['email'] ?? 'N/A'),
              _detailRow('Phone', shopkeeper['phone'] ?? 'Not provided'),
              _detailRow('Role', shopkeeper['role'] ?? 'SHOP_OWNER'),
              _detailRow('Registered On', shopkeeper['createdAt'] != null
                  ? DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(shopkeeper['createdAt']))
                  : 'N/A'),
              const Divider(height: 24),
              Text('Owned Businesses & Stores',
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              if (businesses.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No businesses registered for this shopkeeper.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                )
              else
                ...businesses.map<Widget>((biz) {
                  final stores = biz['stores'] as List? ?? [];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(biz['businessName'] ?? 'Business', style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(biz['verificationStatus'] ?? 'PENDING', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        if (stores.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          const Text('Stores:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ...stores.map((s) => Padding(
                                padding: const EdgeInsets.only(left: 8, top: 2),
                                child: Text('• ${s['name']} (${s['verificationStatus']}) - ${s['address'] ?? 'No address'}', style: const TextStyle(fontSize: 12)),
                              )),
                        ],
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        if (!isSuspended)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
            icon: const Icon(Icons.block, size: 16),
            label: const Text('Suspend Access'),
            onPressed: () {
              Navigator.pop(context);
              onSuspend();
            },
          ),
        if (isSuspended)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
            label: const Text('Restore Access', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              onReinstate();
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
            width: 130,
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
