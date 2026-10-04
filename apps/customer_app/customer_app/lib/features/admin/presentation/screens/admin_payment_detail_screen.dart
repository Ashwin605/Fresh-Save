import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../providers/admin_payments_provider.dart';

class AdminPaymentDetailScreen extends ConsumerWidget {
  final String paymentId;
  const AdminPaymentDetailScreen({super.key, required this.paymentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentAsync = ref.watch(adminPaymentDetailProvider(paymentId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Payment Details', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: BackButton(onPressed: () => context.go('/admin/payments')),
      ),
      body: paymentAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => AppErrorView(message: e.toString()),
        data: (payment) => _buildContent(context, payment),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> payment) {
    final reservation = payment['reservation'];
    final customer = reservation?['customer'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payment ID: ${payment['id']}', style: AppTypography.headline),
              _buildStatusBadge(payment['status']),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.xl,
            runSpacing: AppSpacing.xl,
            children: [
              _buildInfoCard('Payment Info', [
                _InfoRow('Amount', '₹${payment['amount']} ${payment['currency']}'),
                _InfoRow('Provider', payment['provider'] == 'mock_gateway' ? 'MOCK / DEMO' : payment['provider']),
                _InfoRow('Provider ID', payment['providerPaymentId'] ?? 'N/A'),
                _InfoRow('Created At', payment['createdAt'].toString()),
                _InfoRow('Updated At', payment['updatedAt'].toString()),
              ]),
              _buildInfoCard('Order Info', [
                _InfoRow('Order ID', payment['reservationId']),
                _InfoRow('Order Status', reservation?['status'] ?? 'Unknown'),
                _InfoRow('Store', reservation?['store']?['name'] ?? 'Unknown'),
              ], action: TextButton(
                onPressed: () {
                  // Admin could view reservation if route exists
                  // context.go('/admin/reservations/${payment['reservationId']}');
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order viewing not implemented here yet')));
                },
                child: const Text('View Order'),
              )),
              _buildInfoCard('Customer Info', [
                _InfoRow('Name', customer?['name'] ?? 'Unknown'),
                _InfoRow('Email', customer?['email'] ?? 'Unknown'),
                _InfoRow('Phone', customer?['phone'] ?? 'N/A'),
              ]),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<_InfoRow> rows, {Widget? action}) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTypography.title),
              if (action != null) action,
            ],
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          ...rows.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                Text(r.value, style: AppTypography.body),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
