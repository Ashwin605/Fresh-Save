import 'package:flutter/material.dart';
import '../chips_badges/app_badge.dart';

enum StockStatus { available, lowStock, soldOut }

class StockIndicator extends StatelessWidget {
  final StockStatus status;
  final int? remaining;

  const StockIndicator({super.key, required this.status, this.remaining});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case StockStatus.available:
        return const AppBadge(
          label: 'Available',
          variant: AppBadgeVariant.success,
          icon: Icons.check_circle_outline,
        );
      case StockStatus.lowStock:
        return AppBadge(
          label: remaining != null ? 'Only $remaining left' : 'Low Stock',
          variant: AppBadgeVariant.warning,
          icon: Icons.local_fire_department_outlined,
        );
      case StockStatus.soldOut:
        return const AppBadge(
          label: 'Sold Out',
          variant: AppBadgeVariant.neutral,
          icon: Icons.block,
        );
    }
  }
}
