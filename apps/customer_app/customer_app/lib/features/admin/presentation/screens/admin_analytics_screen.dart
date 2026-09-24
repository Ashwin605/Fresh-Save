import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

final adminAnalyticsRevenueProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/analytics/revenue');
  return response.data as List<dynamic>;
});

final adminAnalyticsOrdersProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/analytics/orders');
  return response.data as List<dynamic>;
});

final adminAnalyticsDiscountsProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/analytics/discounts');
  return response.data;
});

final adminAnalyticsRatingsProvider = FutureProvider.autoDispose((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('/admin/analytics/ratings');
  return response.data;
});

class AdminAnalyticsScreen extends ConsumerWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics & Trends',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // REVENUE ANALYTICS
            const Text('Revenue Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: AppSpacing.md),
            ref.watch(adminAnalyticsRevenueProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
              data: (data) => _buildRevenueTable(data),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // ORDER ANALYTICS
            const Text('Order Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: AppSpacing.md),
            ref.watch(adminAnalyticsOrdersProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
              data: (data) => _buildOrdersTable(data),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // DISCOUNT ANALYTICS
            const Text('Discount Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: AppSpacing.md),
            ref.watch(adminAnalyticsDiscountsProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
              data: (data) => _buildDiscountsTable(data),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // SHOP RATING ANALYTICS
            const Text('Shop Rating Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: AppSpacing.md),
            ref.watch(adminAnalyticsRatingsProvider).when(
              loading: () => const CircularProgressIndicator(),
              error: (err, _) => Text('Error: $err'),
              data: (data) => _buildRatingsTable(data),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueTable(List<dynamic> data) {
    if (data.isEmpty) return const Text('No data');
    return Card(
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Gross Revenue', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Discounts', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Net Revenue', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: data.map((row) {
            return DataRow(cells: [
              DataCell(Text('${row['date'] ?? 'Unknown'}')),
              DataCell(Text('₹${row['_sum']?['subtotal'] ?? 0}')),
              DataCell(Text('₹${row['_sum']?['totalDiscount'] ?? 0}')),
              DataCell(Text('₹${row['_sum']?['finalAmount'] ?? 0}')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildOrdersTable(List<dynamic> data) {
    if (data.isEmpty) return const Text('No data');
    return Card(
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Count', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: data.map((row) {
            return DataRow(cells: [
              DataCell(Text('${row['status'] ?? 'Unknown'}')),
              DataCell(Text('${row['_count']?['status'] ?? 0}')),
            ]);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDiscountsTable(dynamic data) {
    if (data == null) return const Text('No data');
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coupons Used: ${data['couponUsage']}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Offers Provided: ${data['offersProvided'] ?? 0}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingsTable(dynamic data) {
    if (data == null) return const Text('No data');
    return Card(
      color: AppColors.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Average Rating: ${data['average'] ?? 0} ⭐', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Total Reviews: ${data['total'] ?? 0}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('5-Star Reviews: ${data['fiveStar'] ?? 0}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('1-Star Reviews: ${data['oneStar'] ?? 0}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
