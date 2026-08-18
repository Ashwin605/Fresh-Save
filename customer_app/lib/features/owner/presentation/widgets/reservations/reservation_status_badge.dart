import 'package:flutter/material.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../domain/models/owner_reservation_models.dart';

class ReservationStatusBadge extends StatelessWidget {
  final ReservationStatus status;

  const ReservationStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    String label;

    switch (status) {
      case ReservationStatus.pending:
        backgroundColor = AppColors.warning.withValues(alpha: 0.1);
        textColor = AppColors.warning;
        label = 'Pending';
      case ReservationStatus.confirmed:
        backgroundColor = AppColors.info.withValues(alpha: 0.1);
        textColor = AppColors.info;
        label = 'Confirmed';
      case ReservationStatus.ready:
        backgroundColor = AppColors.primary.withValues(alpha: 0.1);
        textColor = AppColors.primary;
        label = 'Ready for Pickup';
      case ReservationStatus.completed:
        backgroundColor = AppColors.success.withValues(alpha: 0.1);
        textColor = AppColors.success;
        label = 'Completed';
      case ReservationStatus.cancelled:
      case ReservationStatus.expired:
      case ReservationStatus.rejected:
      case ReservationStatus.failed:
        backgroundColor = AppColors.error.withValues(alpha: 0.1);
        textColor = AppColors.error;
        label = _getFailureLabel(status);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  String _getFailureLabel(ReservationStatus status) {
    if (status == ReservationStatus.cancelled) return 'Cancelled';
    if (status == ReservationStatus.expired) return 'Expired';
    if (status == ReservationStatus.rejected) return 'Rejected';
    return 'Failed';
  }
}
