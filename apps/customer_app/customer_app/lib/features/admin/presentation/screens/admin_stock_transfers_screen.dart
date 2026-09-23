import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/admin_inventory_movements_provider.dart';

class AdminStockTransfersScreen extends ConsumerWidget {
  const AdminStockTransfersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(adminInventoryMovementsProvider(const {'page': 1, 'limit': 20}));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stock Transfers',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: dataAsync.when(
              data: (data) => _buildDataView(data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataView(dynamic data) {
    // Extract list based on response type (Stats is a List, others are Map with 'data' array)
    final List items = data is List ? data : (data['data'] as List? ?? []);
    
    if (items.isEmpty) {
      return const Center(child: Text('No data found'));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          color: AppColors.surface,
          child: ListTile(
            title: Text(item['name'] ?? item['id'] ?? item['date'] ?? 'Item $index', style: const TextStyle(color: AppColors.textPrimary)),
            subtitle: Text(item.toString(), maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textSecondary)),
          ),
        );
      },
    );
  }
}
