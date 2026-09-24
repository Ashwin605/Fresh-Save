import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'package:go_router/go_router.dart';

final adminCouponDetailProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, id) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/coupons/$id');
  return response.data;
});

class AdminCouponDetailScreen extends ConsumerStatefulWidget {
  final String id;
  const AdminCouponDetailScreen({super.key, required this.id});

  @override
  ConsumerState<AdminCouponDetailScreen> createState() => _AdminCouponDetailScreenState();
}

class _AdminCouponDetailScreenState extends ConsumerState<AdminCouponDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final dataAsync = ref.watch(adminCouponDetailProvider(widget.id));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text('Coupon Details', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: dataAsync.when(
        data: (data) => _buildContent(data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    final coupon = data['coupon'] ?? {};
    final usages = (data['usages'] as List?) ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: AppColors.surface,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Code: ${coupon['code']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Switch(
                        value: coupon['isActive'] == true,
                        activeColor: AppColors.primary,
                        onChanged: (val) async {
                          try {
                            final dio = ref.read(dioProvider);
                            await dio.patch('/admin/coupons/${coupon['id']}', data: {'isActive': val});
                            ref.invalidate(adminCouponDetailProvider(widget.id));
                          } catch (e) {
                            // Ignore
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text('Title: ${coupon['title'] ?? 'N/A'}'),
                  Text('Discount: ${coupon['discountValue']} (${coupon['discountType']})'),
                  Text('Used: ${coupon['usedCount']} / ${coupon['usageLimit'] ?? 'Unlimited'}'),
                  Text('Minimum Order: ${coupon['minimumOrderAmount'] ?? 'None'}'),
                  Text('Valid: ${coupon['startDate']} to ${coupon['expiryDate']}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          const Text('Usage History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.md),
          if (usages.isEmpty) const Text('No usage history found.')
          else ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: usages.length,
            itemBuilder: (context, index) {
              final usage = usages[index];
              return Card(
                color: AppColors.surfaceVariant,
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text(usage['customer']?['name'] ?? 'Unknown Customer'),
                  subtitle: Text('Order: ${usage['order']?['reservationCode'] ?? 'N/A'}\nUsed at: ${usage['usedAt']}'),
                  trailing: Text('Saved: ₹${usage['order']?['totalDiscount'] ?? 0}', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                  isThreeLine: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
