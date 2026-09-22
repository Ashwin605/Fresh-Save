import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../domain/models/owner_reservation_models.dart';
import '../../providers/owner_reservation_action_controller.dart';
import 'reservation_status_badge.dart';

class PickupConfirmationSheet extends ConsumerWidget {
  final OwnerReservation reservation;

  const PickupConfirmationSheet({super.key, required this.reservation});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actionState = ref.watch(ownerReservationActionProvider);

    // Listen for success to close and pop back to fulfillment main screen
    ref.listen(ownerReservationActionProvider, (prev, next) {
      if (next.isSuccess) {
        // Pop the sheet
        Navigator.of(context).pop();
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pickup completed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
        // Pop back to fulfillment list if we were in the scan screen
        try {
          if (GoRouterState.of(context).uri.path.contains('/scan')) {
            context.pop();
          }
        } catch (_) {
          // If we can't get GoRouterState (e.g. inside a modal), we can check the URL via GoRouter
          try {
            final currentPath = GoRouter.of(
              context,
            ).routerDelegate.currentConfiguration.uri.path;
            if (currentPath.contains('/scan')) {
              context.pop();
            }
          } catch (_) {}
        }
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppColors.error,
          ),
        );
      }
    });

    final item = reservation.items.isNotEmpty ? reservation.items.first : null;
    final productName = item?.product?.name ?? 'Unknown Product';
    final quantity = item?.quantity ?? 0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Complete Pickup?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reservation.reservationCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    ReservationStatusBadge(status: reservation.status),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Customer',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  reservation.customer?.name ?? 'Unknown Customer',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Item',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  '$productName × $quantity',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (reservation.status != ReservationStatus.ready &&
              reservation.status != ReservationStatus.confirmed)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Reservation is ${reservation.status.name.toUpperCase()}. You usually complete READY reservations.',
                      style: const TextStyle(
                        color: AppColors.warning,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: actionState.isLoading
                ? null
                : () {
                    ref
                        .read(ownerReservationActionProvider.notifier)
                        .completePickup(reservation.id);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: actionState.isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Complete Pickup',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: actionState.isLoading
                ? null
                : () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
