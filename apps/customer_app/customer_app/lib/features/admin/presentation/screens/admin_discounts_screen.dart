import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_offers_provider.dart';
import 'package:go_router/go_router.dart';

class AdminDiscountsScreen extends ConsumerWidget {
  const AdminDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(adminOffersProvider(const {'page': 1, 'limit': 20}));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discounts',
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
    final List items = data is List ? data : (data['data'] as List? ?? []);
    
    if (items.isEmpty) {
      return const Center(child: Text('No promotional offers found.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final status = (item['status'] ?? 'DRAFT').toString();
        final isActive = status == 'ACTIVE';

        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          color: AppColors.surface,
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    item['title'] ?? item['id'] ?? 'Promotional Offer',
                    style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isActive ? AppColors.success : AppColors.textSecondary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: isActive ? AppColors.success : AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text(
              'Discount: ₹${item['discountValue']} (${item['discountType'] ?? 'PERCENTAGE'}) • Starts: ${item['startsAt'] != null ? item['startsAt'].toString().split('T')[0] : 'N/A'}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => context.push('/admin/offers/${item['id']}'),
          ),
        );
      },
    );
  }
}
