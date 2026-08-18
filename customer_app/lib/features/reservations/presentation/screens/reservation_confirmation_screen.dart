import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/glass_surface.dart';
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
                _buildSuccessHeader(reservation),
                const SizedBox(height: AppSpacing.xxl),
                _buildReservationDetails(reservation),
                const SizedBox(height: AppSpacing.xl),
                _buildPickupInstructions(reservation),
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle,
            size: 48,
            color: AppColors.success,
          ),
        ),
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
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(
            'Reference',
            reservation.reservationCode,
            isPrimary: true,
          ),
          const Divider(height: AppSpacing.xl),
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
              ? AppTypography.title.copyWith(color: AppColors.primary)
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
          icon: Icons.storefront,
          title: 'Visit the store',
          description:
              'Head to the store before your reservation hold expires.',
        ),
        _buildInstructionStep(
          icon: Icons.qr_code,
          title: 'Show your code',
          description:
              'Present reference ${reservation.reservationCode} at the counter.',
        ),
        _buildInstructionStep(
          icon: Icons.payments,
          title: 'Pay and collect',
          description:
              'Pay ₹${reservation.totalAmount.toStringAsFixed(2)} directly at the store.',
        ),
      ],
    );
  }

  Widget _buildInstructionStep({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, size: 24, color: AppColors.textPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.body),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Reservation reservation) {
    return GlassSurface(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              AppButton(
                label: 'View Reservation',
                variant: AppButtonVariant.primary,
                onPressed: () {
                  // STEP 12.12 Route placeholder
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
    );
  }
}
