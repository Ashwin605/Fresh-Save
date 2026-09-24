import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_coupons_provider.dart';
import '../../../../core/network/dio_client.dart';
import 'package:go_router/go_router.dart';

class AdminCouponsScreen extends ConsumerWidget {
  const AdminCouponsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(adminCouponsProvider(const {'page': 1, 'limit': 20}));

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateCouponDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Coupons',
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
      ),
    );
  }

  Future<void> _showCreateCouponDialog(BuildContext context, WidgetRef ref) async {
    final codeCtrl = TextEditingController();
    final titleCtrl = TextEditingController();
    final valCtrl = TextEditingController();
    
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create Coupon'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Code')),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: valCtrl, decoration: const InputDecoration(labelText: 'Discount Value')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              try {
                final dio = ref.read(dioProvider);
                await dio.post('/admin/coupons', data: {
                  'code': codeCtrl.text,
                  'title': titleCtrl.text,
                  'discountType': 'FIXED_AMOUNT',
                  'discountValue': double.tryParse(valCtrl.text) ?? 10.0,
                  'startDate': DateTime.now().toIso8601String(),
                  'expiryDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
                  'isActive': true,
                });
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ref.invalidate(adminCouponsProvider(const {'page': 1, 'limit': 20}));
                }
              } catch (e) {
                // ignore
              }
            },
            child: const Text('Create'),
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
            title: Text(item['code'] ?? item['name'] ?? item['id'] ?? 'Coupon', style: const TextStyle(color: AppColors.textPrimary)),
            subtitle: Text('Discount: ${item['discountValue']} | Active: ${item['isActive']}', style: const TextStyle(color: AppColors.textSecondary)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => context.push('/admin/coupons/${item['id']}'),
          ),
        );
      },
    );
  }
}
