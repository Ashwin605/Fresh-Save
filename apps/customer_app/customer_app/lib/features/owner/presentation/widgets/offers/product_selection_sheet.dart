import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../domain/models/inventory_models.dart';
import '../../providers/inventory_list_provider.dart';

class ProductSelectionSheet extends ConsumerWidget {
  final void Function(OwnerInventoryItem) onSelected;

  const ProductSelectionSheet({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(inventoryListProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Select Inventory Batch', style: AppTypography.title),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(child: _buildContent(context, inventoryState)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, InventoryListState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(child: Text('Error: ${state.error}'));
    }

    final availableItems = state.items
        .where((i) => i.status == 'ACTIVE' && i.stockQuantity > 0)
        .toList();

    if (availableItems.isEmpty) {
      return const Center(
        child: Text('No active inventory available to offer.'),
      );
    }

    return ListView.builder(
      itemCount: availableItems.length,
      itemBuilder: (context, index) {
        final item = availableItems[index];
        return ListTile(
          title: Text(
            item.product.name,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            'Stock: ${item.stockQuantity} • Expiry: ${item.expiryDate.toLocal().toString().split(' ')[0]}',
          ),
          trailing: Text(
            '₹${item.sellingPrice.toStringAsFixed(2)}',
            style: AppTypography.title.copyWith(color: AppColors.primary),
          ),
          onTap: () {
            onSelected(item);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}
