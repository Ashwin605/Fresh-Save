import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/widgets/buttons/app_button.dart';

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.surfaceVariant),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
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
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Store details fallback
                Text('Store Details', style: AppTypography.title),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.store, color: AppColors.textSecondary),
                  ),
                  title: const Text('Partner Store', style: AppTypography.body),
                  subtitle: Text('Store ID: ${reservation.storeId.substring(0, 8)}...', style: AppTypography.bodySmall),
                ),
                
                const SizedBox(height: AppSpacing.xl),
                
                // Order details
                Text('Order Summary', style: AppTypography.title),
                const SizedBox(height: AppSpacing.md),
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
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: AppTypography.headline),
                    Text('\$${reservation.totalAmount.toStringAsFixed(2)}', style: AppTypography.headline),
                  ],
                ),

                const SizedBox(height: AppSpacing.xxl),
                
                AppButton.primary(
                  label: 'Get Directions',
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
