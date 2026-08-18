import 'package:flutter/material.dart';
import 'app_badge.dart';

enum ExpiryStatus { fresh, expiringSoon, urgent, critical, expired }

class ExpiryBadge extends StatelessWidget {
  final ExpiryStatus status;
  final String label;

  const ExpiryBadge({super.key, required this.status, required this.label});

  AppBadgeVariant get _variant {
    switch (status) {
      case ExpiryStatus.fresh:
        return AppBadgeVariant.success;
      case ExpiryStatus.expiringSoon:
        return AppBadgeVariant.neutral;
      case ExpiryStatus.urgent:
        return AppBadgeVariant.warning;
      case ExpiryStatus.critical:
        return AppBadgeVariant.error;
      case ExpiryStatus.expired:
        return AppBadgeVariant.neutral;
    }
  }

  IconData get _icon {
    switch (status) {
      case ExpiryStatus.fresh:
        return Icons.eco_outlined;
      case ExpiryStatus.expiringSoon:
        return Icons.schedule;
      case ExpiryStatus.urgent:
        return Icons.warning_amber_outlined;
      case ExpiryStatus.critical:
        return Icons.error_outline;
      case ExpiryStatus.expired:
        return Icons.block;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBadge(label: label, variant: _variant, icon: _icon);
  }
}
