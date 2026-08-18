import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_radius.dart';

enum AppBadgeVariant { neutral, success, warning, error, info, discount }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
    this.icon,
  });

  Color get _backgroundColor {
    switch (variant) {
      case AppBadgeVariant.neutral:
        return AppColors.surfaceVariant;
      case AppBadgeVariant.success:
        return AppColors.success.withValues(alpha: 0.1);
      case AppBadgeVariant.warning:
        return AppColors.warning.withValues(alpha: 0.1);
      case AppBadgeVariant.error:
        return AppColors.error.withValues(alpha: 0.1);
      case AppBadgeVariant.info:
        return AppColors.info.withValues(alpha: 0.1);
      case AppBadgeVariant.discount:
        return AppColors.secondary.withValues(alpha: 0.15);
    }
  }

  Color get _textColor {
    switch (variant) {
      case AppBadgeVariant.neutral:
        return AppColors.textSecondary;
      case AppBadgeVariant.success:
        return AppColors.success;
      case AppBadgeVariant.warning:
        return AppColors.warning;
      case AppBadgeVariant.error:
        return AppColors.error;
      case AppBadgeVariant.info:
        return AppColors.info;
      case AppBadgeVariant.discount:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: _textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.label.copyWith(
              color: _textColor,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
