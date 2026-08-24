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
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/feedback/empty_state_view.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../domain/models/reservation_models.dart';
import '../providers/reservation_providers.dart';

class ReservationHistoryScreen extends ConsumerWidget {
  const ReservationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationsAsync = ref.watch(customerReservationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('My Reservations', style: AppTypography.headline),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveContainer(
            onTap: () => context.pop(),
            scaleDown: 0.9,
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: reservationsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => AppErrorView(
          message: error.toString().replaceFirst('Exception: ', ''),
          onRetry: () => ref.invalidate(customerReservationsProvider),
        ),
        data: (result) {
          if (result.items.isEmpty) {
            return _buildEmptyState(context).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.1, end: 0);
          }
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async =>
                ref.invalidate(customerReservationsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: result.items.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) =>
                  _ReservationCard(reservation: result.items[index]).animate().fade(
                    duration: AppAnimations.medium,
                    delay: Duration(milliseconds: (index % 10) * 50),
                  ).slideY(begin: 0.1, end: 0),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyStateView(
      icon: Icons.receipt_long_outlined,
      title: 'No reservations yet',
      description:
          'Your reservation history will appear here once you book items from a store.',
      actionLabel: 'Explore Deals',
      onAction: () => context.go('/home'),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final Reservation reservation;

  const _ReservationCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return InteractiveContainer(
      onTap: () => context.push('/reservation/${reservation.id}'),
      scaleDown: 0.98,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: code + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reservation.reservationCode,
                  style: AppTypography.title.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                _StatusBadge(status: reservation.status),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            // Item count + amount
            Row(
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  '${reservation.items.length} item${reservation.items.length == 1 ? '' : 's'}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${reservation.totalAmount.toStringAsFixed(2)}',
                  style: AppTypography.body.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            // Date
            if (reservation.createdAt != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    DateFormat('d MMM yyyy, h:mm a')
                        .format(reservation.createdAt!.toLocal()),
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReservationStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor) = switch (status) {
      ReservationStatus.pending => (
          'Pending',
          AppColors.warning.withValues(alpha: 0.12),
          AppColors.warning,
        ),
      ReservationStatus.confirmed => (
          'Confirmed',
          AppColors.info.withValues(alpha: 0.12),
          AppColors.info,
        ),
      ReservationStatus.ready => (
          'Ready',
          AppColors.success.withValues(alpha: 0.12),
          AppColors.success,
        ),
      ReservationStatus.completed => (
          'Completed',
          AppColors.success.withValues(alpha: 0.1),
          AppColors.success,
        ),
      ReservationStatus.cancelled => (
          'Cancelled',
          AppColors.error.withValues(alpha: 0.1),
          AppColors.error,
        ),
      ReservationStatus.expired => (
          'Expired',
          AppColors.textDisabled.withValues(alpha: 0.15),
          AppColors.textDisabled,
        ),
      ReservationStatus.rejected => (
          'Rejected',
          AppColors.error.withValues(alpha: 0.1),
          AppColors.error,
        ),
      ReservationStatus.failed => (
          'Failed',
          AppColors.error.withValues(alpha: 0.1),
          AppColors.error,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
