import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_coupons_provider.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/widgets/feedback/app_snackbar.dart';
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
            TextField(controller: codeCtrl, decoration: const InputDecoration(labelText: 'Code *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title *', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: valCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Discount Value (₹) *', border: OutlineInputBorder())),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              if (codeCtrl.text.trim().isEmpty || titleCtrl.text.trim().isEmpty) {
                AppSnackbar.show(ctx, message: 'Please fill in all required fields', variant: SnackbarVariant.warning);
                return;
              }
              try {
                final dio = ref.read(dioProvider);
                await dio.post('/admin/coupons', data: {
                  'code': codeCtrl.text.trim().toUpperCase(),
                  'title': titleCtrl.text.trim(),
                  'discountType': 'FIXED_AMOUNT',
                  'discountValue': double.tryParse(valCtrl.text.trim()) ?? 10.0,
                  'startDate': DateTime.now().toIso8601String(),
                  'expiryDate': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
                  'isActive': true,
                });
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  AppSnackbar.show(context, message: 'Coupon created successfully', variant: SnackbarVariant.success);
                  ref.invalidate(adminCouponsProvider(const {'page': 1, 'limit': 20}));
                }
              } catch (e) {
                if (ctx.mounted) {
                  AppSnackbar.show(ctx, message: e.toString(), variant: SnackbarVariant.error);
                }
              }
            },
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDataView(dynamic data) {
    final List items = data is List ? data : (data['data'] as List? ?? []);
    
    if (items.isEmpty) {
      return const Center(child: Text('No coupons registered yet.', style: TextStyle(color: AppColors.textSecondary)));
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isActive = item['isActive'] == true;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          color: AppColors.surface,
          child: ListTile(
            title: Row(
              children: [
                Text(item['code'] ?? 'COUPON', style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isActive ? AppColors.success : AppColors.textSecondary).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isActive ? 'ACTIVE' : 'INACTIVE',
                    style: TextStyle(
                      color: isActive ? AppColors.success : AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            subtitle: Text('Title: ${item['title'] ?? 'N/A'} • Discount: ₹${item['discountValue']} (${item['discountType'] ?? 'FIXED'})', style: const TextStyle(color: AppColors.textSecondary)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => context.push('/admin/coupons/${item['id']}'),
          ),
        );
      },
    );
  }
}
