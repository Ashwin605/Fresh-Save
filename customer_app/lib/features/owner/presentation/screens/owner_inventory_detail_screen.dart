import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../providers/inventory_detail_provider.dart';
import '../../domain/models/inventory_models.dart';
import '../widgets/inventory/stock_adjustment_sheet.dart';

class OwnerInventoryDetailScreen extends ConsumerWidget {
  final String inventoryId;

  const OwnerInventoryDetailScreen({super.key, required this.inventoryId});

  void _showAdjustStockSheet(BuildContext context, OwnerInventoryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StockAdjustmentSheet(
        inventoryId: inventoryId,
        currentStock: item.stockQuantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(inventoryDetailProvider(inventoryId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Inventory Details',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                error.toString(),
                style: const TextStyle(color: AppColors.error),
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.refresh(inventoryDetailProvider(inventoryId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (item) => _buildContent(context, ref, item),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    OwnerInventoryItem item,
  ) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(inventoryDetailProvider(inventoryId)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.product.name, style: AppTypography.headline),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Brand: ${item.product.brand}',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      _buildInfoBadge('SKU: ${item.product.sku ?? 'N/A'}'),
                      const SizedBox(width: AppSpacing.sm),
                      _buildInfoBadge('Unit: ${item.product.unit}'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Stock Details
            Text('Stock Information', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Available Quantity',
                    '${item.stockQuantity}',
                    isBold: true,
                  ),
                  _buildDetailRow('Batch Number', item.batchNumber ?? 'N/A'),
                  _buildDetailRow(
                    'Original Price',
                    '\$${item.originalPrice.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow(
                    'Selling Price',
                    '\$${item.sellingPrice.toStringAsFixed(2)}',
                  ),
                  _buildDetailRow('Status', item.status),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Expiry Details
            Text('Dates', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSpacing.md),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Manufacturing Date',
                    item.manufacturingDate != null
                        ? dateFormat.format(item.manufacturingDate!)
                        : 'N/A',
                  ),
                  _buildDetailRow(
                    'Expiry Date',
                    dateFormat.format(item.expiryDate),
                    textColor: item.expiryStatus == 'EXPIRED'
                        ? AppColors.error
                        : null,
                  ),
                  _buildDetailRow('Time Remaining', item.timeRemaining),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Adjust Stock Button
            ElevatedButton(
              onPressed: () => _showAdjustStockSheet(context, item),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.md),
                ),
              ),
              child: const Text(
                'Adjust Stock',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Text(text, style: AppTypography.bodySmall),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isBold = false,
    Color? textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
