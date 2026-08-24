import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../domain/models/reservation_models.dart';
import '../providers/reservation_providers.dart';

class ReservationConfirmationScreen extends ConsumerWidget {
  final String reservationId;

  const ReservationConfirmationScreen({super.key, required this.reservationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationAsync = ref.watch(
      reservationDetailsProvider(reservationId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: reservationAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => AppErrorView(
          message: 'Failed to load confirmation details',
          onRetry: () =>
              ref.invalidate(reservationDetailsProvider(reservationId)),
        ),
        data: (reservation) => _buildContent(context, reservation),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Reservation reservation) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              physics: const BouncingScrollPhysics(),
              children: [
                _buildSuccessHeader(reservation).animate().fade(duration: AppAnimations.medium).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1), curve: Curves.easeOutBack),
                const SizedBox(height: AppSpacing.xxl),
                _buildReservationDetails(reservation).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.xl),
                _buildPickupInstructions(reservation).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
          ),
          _buildActionButtons(context, reservation),
        ],
      ),
    );
  }

  Widget _buildSuccessHeader(Reservation reservation) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3), width: 4),
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            size: 48,
            color: AppColors.success,
          ),
        ).animate(onPlay: (controller) => controller.repeat(reverse: true)).shimmer(duration: 2.seconds, color: AppColors.success.withValues(alpha: 0.3)),
        const SizedBox(height: AppSpacing.lg),
        Text('Reservation Confirmed', style: AppTypography.headline),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Your items have been reserved and locked.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildReservationDetails(Reservation reservation) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Reference',
            reservation.reservationCode,
            isPrimary: true,
          ),
          const SizedBox(height: AppSpacing.md),
          Divider(color: AppColors.border.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.md),
          _buildDetailRow(
            'Total Amount',
            '₹${reservation.totalAmount.toStringAsFixed(2)}',
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildDetailRow('Status', reservation.status.name.toUpperCase()),
          if (reservation.expiresAt != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _buildDetailRow(
              'Held Until',
              DateFormat('h:mm a').format(reservation.expiresAt!.toLocal()),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isPrimary = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isPrimary
              ? AppTypography.title.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 20)
              : AppTypography.title,
        ),
      ],
    );
  }

  Widget _buildPickupInstructions(Reservation reservation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Next Steps', style: AppTypography.title),
        const SizedBox(height: AppSpacing.md),
        _buildInstructionStep(
          icon: Icons.storefront_outlined,
          title: 'Visit the store',
          description:
              'Head to the store before your reservation hold expires.',
          delay: 200,
        ),
        _buildInstructionStep(
          icon: Icons.qr_code_outlined,
          title: 'Show your code',
          description:
              'Present reference ${reservation.reservationCode} at the counter.',
          delay: 300,
        ),
        _buildInstructionStep(
          icon: Icons.payments_outlined,
          title: 'Pay and collect',
          description:
              'Pay ₹${reservation.totalAmount.toStringAsFixed(2)} directly at the store.',
          delay: 400,
        ),
      ],
    );
  }

  Widget _buildInstructionStep({
    required IconData icon,
    required String title,
    required String description,
    required int delay,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    description,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: AppAnimations.medium, delay: delay.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildActionButtons(BuildContext context, Reservation reservation) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppButton(
                label: 'View Reservation',
                variant: AppButtonVariant.primary,
                onPressed: () {
                  context.push('/reservation/${reservation.id}');
                },
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Back to Home',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.go('/home'),
              ),
            ],
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0, duration: AppAnimations.medium, curve: Curves.easeOutCubic);
  }
}
