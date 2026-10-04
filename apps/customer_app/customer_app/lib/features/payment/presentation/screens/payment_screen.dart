import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/network/result.dart';
import '../../data/repositories/payment_repository.dart';
import '../../../reservations/data/repositories/reservation_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String reservationId;
  const PaymentScreen({super.key, required this.reservationId});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isProcessing = false;
  String _selectedMethod = 'mock_card';
  String? _paymentId;

  Future<void> _processPayment() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final paymentRepo = ref.read(paymentRepositoryProvider);
    
    // 1. Create Payment
    final createResult = await paymentRepo.createPayment(widget.reservationId);
    if (createResult is Failure<Map<String, dynamic>>) {
      _showError(createResult.error.message ?? 'Failed to initialize payment');
      setState(() => _isProcessing = false);
      return;
    }

    _paymentId = (createResult as Success<Map<String, dynamic>>).data['id'];

    // 2. Simulate delay for realistic UX
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // 3. Verify Mock Payment
    final verifyResult = await paymentRepo.verifyPayment(_paymentId!, simulateStatus: 'SUCCESS');

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (verifyResult is Success<Map<String, dynamic>>) {
      final status = verifyResult.data['status'];
      if (status == 'SUCCESS') {
         context.go('/payment/result/success?reservationId=${widget.reservationId}&paymentId=$_paymentId');
      } else {
         context.go('/payment/result/failed?reservationId=${widget.reservationId}&paymentId=$_paymentId');
      }
    } else {
      context.go('/payment/result/failed?reservationId=${widget.reservationId}&paymentId=$_paymentId');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservationAsync = ref.watch(reservationDetailProvider(widget.reservationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Checkout', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        leading: BackButton(
          color: AppColors.textPrimary,
          onPressed: () {
            // Cancel flow
            context.go('/home'); // Or wherever it should return
          },
        ),
      ),
      body: reservationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (error, _) => Center(child: Text('Error loading order summary')),
        data: (reservationResult) {
          if (reservationResult is! Success) {
             return const Center(child: Text('Failed to load order'));
          }
          final reservation = (reservationResult as Success).data;
          
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    _buildDemoWarning().animate().fade().slideY(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildOrderSummary(reservation.totalAmount).animate().fade().slideY(delay: 100.ms),
                    const SizedBox(height: AppSpacing.lg),
                    _buildPaymentMethods().animate().fade().slideY(delay: 200.ms),
                  ],
                ),
              ),
              _buildStickyCTA(reservation.totalAmount),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDemoWarning() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.science, color: AppColors.warning),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'This is a placeholder payment gateway. No real charges will be made.',
              style: AppTypography.bodySmall.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(String totalAmount) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order Summary', style: AppTypography.title),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount to Pay', style: AppTypography.body),
              Text(
                '₹$totalAmount',
                style: AppTypography.headline.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Select Payment Method', style: AppTypography.title),
        const SizedBox(height: AppSpacing.md),
        _buildMethodTile('mock_card', 'Credit / Debit Card', Icons.credit_card),
        const SizedBox(height: AppSpacing.sm),
        _buildMethodTile('mock_upi', 'UPI Payment', Icons.qr_code_scanner),
      ],
    );
  }

  Widget _buildMethodTile(String id, String title, IconData icon) {
    final isSelected = _selectedMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = id),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: AppTypography.body.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyCTA(String totalAmount) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: SafeArea(
        child: AppButton(
          label: _isProcessing ? 'Processing Payment...' : 'Pay ₹$totalAmount',
          variant: AppButtonVariant.primary,
          isLoading: _isProcessing,
          onPressed: _processPayment,
        ),
      ),
    );
  }
}

// Temporary provider for fetching reservation details to get the total amount
final reservationDetailProvider = FutureProvider.family<dynamic, String>((ref, id) async {
  final repo = ref.read(reservationRepositoryProvider);
  return repo.getReservation(id);
});
