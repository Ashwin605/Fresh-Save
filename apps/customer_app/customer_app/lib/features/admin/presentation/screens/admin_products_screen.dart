import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/network/image_url_resolver.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/layout/admin_data_table.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
import '../providers/admin_products_provider.dart';
import '../../data/admin_repository.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  ConsumerState<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  int _currentPage = 1;
  String _searchQuery = '';
  String _statusFilter = 'ALL';

  void _updateProductStatus(String id, String status) async {
    try {
      await ref.read(adminRepositoryProvider).updateProductStatus(id, status);
      if (!mounted) return;
      AppSnackbar.show(
        context,
        message: status == 'ACTIVE' ? 'Product approved and published' : 'Product unpublished/deactivated',
        variant: status == 'ACTIVE' ? SnackbarVariant.success : SnackbarVariant.warning,
      );
      ref.invalidate(adminProductsProvider(_currentPage));
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.show(context, message: e.toString(), variant: SnackbarVariant.error);
    }
  }

  void _inspectProduct(Map<String, dynamic> product) {
    showDialog(
      context: context,
      builder: (context) => _ProductDetailsDialog(
        product: product,
        onStatusChange: (status) => _updateProductStatus(product['id'], status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(adminProductsProvider(_currentPage));

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
                  'Product Catalog & Governance',
                  style: AppTypography.headline.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            // Search and filter bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by product name, brand, SKU or category...',
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
                  children: ['ALL', 'ACTIVE', 'INACTIVE'].map((filter) {
                    final isSelected = _statusFilter == filter;
                    String label = filter;
                    if (filter == 'ACTIVE') label = 'Active (Published)';
                    if (filter == 'INACTIVE') label = 'Inactive / Review';

                    return ChoiceChip(
                      label: Text(label, style: TextStyle(
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
              child: productsAsync.when(
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

                  final products = allItems.where((item) {
                    final name = (item['name'] ?? '').toString().toLowerCase();
                    final brand = (item['brand'] ?? '').toString().toLowerCase();
                    final sku = (item['sku'] ?? '').toString().toLowerCase();
                    final category = (item['category']?['name'] ?? '').toString().toLowerCase();
                    final status = (item['status'] ?? 'ACTIVE').toString().toUpperCase();

                    final q = _searchQuery.toLowerCase();
                    final matchesSearch = _searchQuery.isEmpty ||
                        name.contains(q) ||
                        brand.contains(q) ||
                        sku.contains(q) ||
                        category.contains(q);
                    final matchesStatus = _statusFilter == 'ALL' || status == _statusFilter;
                    return matchesSearch && matchesStatus;
                  }).toList();

                  if (products.isEmpty) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Text('No products match the selected filters.', style: TextStyle(color: AppColors.textSecondary))),
                    );
                  }

                  return AdminDataTable(
                    currentPage: _currentPage,
                    totalPages: totalPages > 0 ? totalPages : 1,
                    onPageChanged: (page) => setState(() => _currentPage = page),
                    columns: const [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('SKU / Barcode')),
                      DataColumn(label: Text('Store & Pricing')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Created')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: products.map<DataRow>((product) {
                      final status = product['status'] ?? 'ACTIVE';
                      final isActive = status == 'ACTIVE';
                      final inventoryList = product['inventory'] as List? ?? [];

                      Color statusColor = isActive ? AppColors.success : AppColors.warning;

                      // Pricing / Store summary
                      String pricingSummary = 'No store listings';
                      if (inventoryList.isNotEmpty) {
                        final firstInv = inventoryList.first as Map<String, dynamic>;
                        final storeName = firstInv['store']?['name'] ?? 'Store';
                        final price = firstInv['sellingPrice'] ?? '0';
                        pricingSummary = '₹$price ($storeName)';
                        if (inventoryList.length > 1) {
                          pricingSummary += ' +${inventoryList.length - 1} more';
                        }
                      }

                      return DataRow(
                        cells: [
                          DataCell(
                            InkWell(
                              onTap: () => _inspectProduct(product),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: product['image'] != null && (product['image'] as String).isNotEmpty
                                          ? AppNetworkImage(
                                              imageUrl: resolveImageUrl(product['image']),
                                              fit: BoxFit.cover,
                                            )
                                          : Container(
                                              color: AppColors.surfaceVariant,
                                              child: const Icon(Icons.image_not_supported, size: 20, color: AppColors.textDisabled),
                                            ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product['name'] ?? 'Unnamed',
                                        style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (product['brand'] != null)
                                        Text(
                                          product['brand'],
                                          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
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
                                product['category']?['name'] ?? 'General',
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          DataCell(
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('SKU: ${product['sku'] ?? 'N/A'}', style: const TextStyle(fontSize: 12)),
                                if (product['barcode'] != null)
                                  Text('Bar: ${product['barcode']}', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          DataCell(
                            Text(pricingSummary, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
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
                            product['createdAt'] != null
                                ? DateFormat('MMM d, yyyy').format(DateTime.parse(product['createdAt']))
                                : 'N/A',
                            style: const TextStyle(fontSize: 12),
                          )),
                          DataCell(
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                              onSelected: (value) {
                                if (value == 'DETAILS') {
                                  _inspectProduct(product);
                                } else if (value == 'ACTIVE' || value == 'INACTIVE') {
                                  _updateProductStatus(product['id'], value);
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
                                if (!isActive)
                                  const PopupMenuItem(
                                    value: 'ACTIVE',
                                    child: Row(
                                      children: [
                                        Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                                        SizedBox(width: 8),
                                        Text('Approve & Publish', style: TextStyle(color: AppColors.success)),
                                      ],
                                    ),
                                  ),
                                if (isActive)
                                  const PopupMenuItem(
                                    value: 'INACTIVE',
                                    child: Row(
                                      children: [
                                        Icon(Icons.visibility_off_outlined, size: 18, color: AppColors.warning),
                                        SizedBox(width: 8),
                                        Text('Unpublish / Deactivate', style: TextStyle(color: AppColors.warning)),
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

class _ProductDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> product;
  final ValueChanged<String> onStatusChange;

  const _ProductDetailsDialog({required this.product, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    final status = product['status'] ?? 'ACTIVE';
    final isActive = status == 'ACTIVE';
    final category = product['category']?['name'] ?? 'Uncategorized';
    final inventoryList = product['inventory'] as List? ?? [];

    Color statusColor = isActive ? AppColors.success : AppColors.warning;

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              product['name'] ?? 'Product Details',
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
        width: 540,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (product['image'] != null && (product['image'] as String).isNotEmpty)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 160,
                      width: 220,
                      child: AppNetworkImage(
                        imageUrl: resolveImageUrl(product['image']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _detailRow('Product ID', product['id'] ?? 'N/A'),
              _detailRow('Category', category),
              _detailRow('Brand', product['brand'] ?? 'N/A'),
              _detailRow('Unit', product['unit'] ?? '1 Unit'),
              _detailRow('SKU', product['sku'] ?? 'N/A'),
              _detailRow('Barcode', product['barcode'] ?? 'N/A'),
              _detailRow('Description', product['description'] ?? 'No description provided'),
              _detailRow('Created On', product['createdAt'] != null
                  ? DateFormat('MMMM d, yyyy h:mm a').format(DateTime.parse(product['createdAt']))
                  : 'N/A'),
              const Divider(height: 24),
              Text('Store Inventory & Pricing (${inventoryList.length} Stores)',
                  style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              if (inventoryList.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('No shopkeeper has added inventory for this master product yet.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                )
              else
                ...inventoryList.map<Widget>((inv) {
                  final storeName = inv['store']?['name'] ?? 'Store';
                  final stock = inv['stockQuantity'] ?? 0;
                  final sPrice = inv['sellingPrice'] ?? '0';
                  final oPrice = inv['originalPrice'] ?? '0';
                  final invStatus = inv['status'] ?? 'ACTIVE';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text('Stock: $stock • Status: $invStatus', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹$sPrice', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 14)),
                            if (oPrice != sPrice)
                              Text('₹$oPrice', style: const TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        if (!isActive)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            icon: const Icon(Icons.check, size: 16, color: Colors.white),
            label: const Text('Approve & Publish', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              onStatusChange('ACTIVE');
            },
          ),
        if (isActive)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: AppColors.warning),
            icon: const Icon(Icons.visibility_off, size: 16),
            label: const Text('Unpublish'),
            onPressed: () {
              Navigator.pop(context);
              onStatusChange('INACTIVE');
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
            width: 120,
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
