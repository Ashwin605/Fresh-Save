import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/layout/interactive_container.dart';

import '../providers/reservation_providers.dart';

class ReservationDetailScreen extends ConsumerWidget {
  final String reservationId;

  const ReservationDetailScreen({
    super.key,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservationAsync = ref.watch(reservationDetailsProvider(reservationId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reservation Details', style: AppTypography.title),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveContainer(
            onTap: () => context.pop(),
            scaleDown: 0.9,
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      body: reservationAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Text(
              err.toString(),
              style: AppTypography.body.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (reservation) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          reservation.status.name.toUpperCase(),
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Order #${reservation.reservationCode}',
                        style: AppTypography.headline,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      if (reservation.expiresAt != null)
                        Text(
                          'Expires at ${reservation.expiresAt!.toLocal().toString().split('.')[0]}',
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Store details fallback
                Text('Store Details', style: AppTypography.title).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.storefront_outlined, color: AppColors.primary),
                    ),
                    title: const Text('Partner Store', style: AppTypography.body),
                    subtitle: Text('Store ID: ${reservation.storeId.substring(0, 8)}...', style: AppTypography.bodySmall),
                  ),
                ).animate().fade(duration: AppAnimations.medium, delay: 150.ms).slideY(begin: 0.1, end: 0),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Order details
                Text('Order Summary', style: AppTypography.title).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.1, end: 0),
                const SizedBox(height: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    children: [
                      ...reservation.items.map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Item x${item.quantity}', style: AppTypography.body),
                                Text('\$${item.subtotal.toStringAsFixed(2)}', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Divider(color: AppColors.border.withValues(alpha: 0.5)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total', style: AppTypography.headline),
                          Text('\$${reservation.totalAmount.toStringAsFixed(2)}', style: AppTypography.headline.copyWith(color: AppColors.primary)),
                        ],
                      ),
                    ],
                  ),
                ).animate().fade(duration: AppAnimations.medium, delay: 250.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: AppSpacing.xxl),
                
                AppButton(
                  label: 'Get Directions',
                  variant: AppButtonVariant.primary,
                  onPressed: () {},
                ).animate().fade(duration: AppAnimations.medium, delay: 350.ms).slideY(begin: 0.1, end: 0),
              ],
            ),
          );
        },
      ),
    );
  }
}
