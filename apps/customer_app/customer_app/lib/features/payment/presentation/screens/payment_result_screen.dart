import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/buttons/app_button.dart';

class PaymentResultScreen extends StatelessWidget {
  final String status;
  final String reservationId;
  final String? paymentId;

  const PaymentResultScreen({
    super.key,
    required this.status,
    required this.reservationId,
    this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    final isSuccess = status == 'success';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle : Icons.error,
                color: isSuccess ? AppColors.success : AppColors.error,
                size: 80,
              ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
              const SizedBox(height: AppSpacing.lg),
              Text(
                isSuccess ? 'Payment Successful!' : 'Payment Failed',
                style: AppTypography.headline.copyWith(
                  color: isSuccess ? AppColors.success : AppColors.error,
                ),
              ).animate().fade().slideY(delay: 200.ms),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isSuccess
                    ? 'Your order has been confirmed.'
                    : 'We could not process your payment. Please try again.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: AppColors.textSecondary),
              ).animate().fade().slideY(delay: 300.ms),
              const SizedBox(height: AppSpacing.xl),
              if (isSuccess) ...[
                 AppButton(
                  label: 'View Order',
                  variant: AppButtonVariant.primary,
                  onPressed: () => context.go('/reservation/success/$reservationId'),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Continue Shopping',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.go('/home'),
                ),
              ] else ...[
                AppButton(
                  label: 'Retry Payment',
                  variant: AppButtonVariant.primary,
                  onPressed: () => context.go('/payment/$reservationId'),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Back to Home',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => context.go('/home'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
