import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../providers/admin_payments_provider.dart';

class AdminPaymentsScreen extends ConsumerStatefulWidget {
  const AdminPaymentsScreen({super.key});

  @override
  ConsumerState<AdminPaymentsScreen> createState() => _AdminPaymentsScreenState();
}

class _AdminPaymentsScreenState extends ConsumerState<AdminPaymentsScreen> {
  int _currentPage = 1;
  final int _limit = 20;
  String? _statusFilter = 'ALL';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _currentPage = 1; // Reset to page 1 on search
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mock Payment Monitoring', style: AppTypography.headline),
                  const SizedBox(height: AppSpacing.md),
                  _buildStatsSection(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildFilters(),
                  const SizedBox(height: AppSpacing.xl),
                  _buildPaymentsTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    final statsAsync = ref.watch(adminPaymentStatsProvider);
    return statsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorView(message: 'Failed to load stats'),
      data: (stats) => LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth > 800;
          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: [
              _buildStatCard('Total Payments', stats['totalPayments'].toString(), Icons.receipt_long, isDesktop),
              _buildStatCard('Successful', stats['successfulPayments'].toString(), Icons.check_circle, isDesktop, color: AppColors.success),
              _buildStatCard('Pending', stats['pendingPayments'].toString(), Icons.hourglass_empty, isDesktop, color: AppColors.warning),
              _buildStatCard('Failed', stats['failedPayments'].toString(), Icons.error, isDesktop, color: AppColors.error),
              _buildStatCard('Total Value', '₹${stats['totalSuccessfulValue']}', Icons.currency_rupee, isDesktop, color: AppColors.primary),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDesktop, {Color color = AppColors.textPrimary}) {
    return Container(
      width: isDesktop ? 200 : double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(value, style: AppTypography.title.copyWith(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search by Payment ID or Order ID...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              isDense: true,
            ),
            onSubmitted: (_) => _onSearch(),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        ElevatedButton(
          onPressed: _onSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
          child: const Text('Search', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _statusFilter,
              items: const [
                DropdownMenuItem(value: 'ALL', child: Text('All Statuses')),
                DropdownMenuItem(value: 'SUCCESS', child: Text('Success')),
                DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                DropdownMenuItem(value: 'PROCESSING', child: Text('Processing')),
                DropdownMenuItem(value: 'FAILED', child: Text('Failed')),
                DropdownMenuItem(value: 'CANCELLED', child: Text('Cancelled')),
                DropdownMenuItem(value: 'REFUNDED', child: Text('Refunded')),
              ],
              onChanged: (val) {
                setState(() {
                  _statusFilter = val;
                  _currentPage = 1;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentsTable() {
    final paymentsAsync = ref.watch(adminPaymentListProvider({
      'page': _currentPage,
      'limit': _limit,
      'status': _statusFilter,
      'search': _searchQuery,
    }));

    return paymentsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => AppErrorView(message: e.toString()),
      data: (data) {
        final items = data['items'] as List<dynamic>;
        final meta = data['meta'] as Map<String, dynamic>;

        if (items.isEmpty) {
          return const Center(child: Text('No payments found.'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Payment ID')),
                      DataColumn(label: Text('Order ID')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Provider')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: items.map((p) => DataRow(
                      cells: [
                        DataCell(Text(p['id'].toString().substring(0, 12) + '...')),
                        DataCell(Text(p['orderId'].toString().substring(0, 8) + '...')),
                        DataCell(Text(p['customer']?['name'] ?? 'Unknown')),
                        DataCell(Text('₹${p['amount']}')),
                        DataCell(Text(p['provider'] == 'mock_gateway' ? 'MOCK / DEMO' : p['provider'])),
                        DataCell(_buildStatusBadge(p['status'])),
                        DataCell(
                          TextButton(
                            onPressed: () => context.go('/admin/payments/${p['id']}'),
                            child: const Text('View'),
                          ),
                        ),
                      ],
                    )).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildPagination(meta['totalPages'] as int),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'SUCCESS':
        color = AppColors.success;
        break;
      case 'PENDING':
      case 'PROCESSING':
        color = AppColors.warning;
        break;
      case 'FAILED':
      case 'CANCELLED':
        color = AppColors.error;
        break;
      default:
        color = AppColors.textSecondary;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: _currentPage > 1 ? () => setState(() => _currentPage--) : null,
        ),
        Text('Page $_currentPage of $totalPages', style: AppTypography.bodySmall),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: _currentPage < totalPages ? () => setState(() => _currentPage++) : null,
        ),
      ],
    );
  }
}
