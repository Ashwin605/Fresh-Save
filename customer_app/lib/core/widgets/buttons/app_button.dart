import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';
import '../layout/interactive_container.dart';

enum AppButtonVariant { primary, secondary, destructive, glass }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.destructive({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : variant = AppButtonVariant.destructive;

  const AppButton.glass({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : variant = AppButtonVariant.glass;

  Color get _backgroundColor {
    if (onPressed == null) return AppColors.surfaceVariant;
    switch (variant) {
      case AppButtonVariant.primary:
        return AppColors.primary;
      case AppButtonVariant.secondary:
        return AppColors.surface;
      case AppButtonVariant.destructive:
        return AppColors.error.withValues(alpha: 0.1);
      case AppButtonVariant.glass:
        return AppColors.glassFill;
    }
  }

  Color get _textColor {
    if (onPressed == null) return AppColors.textDisabled;
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return AppColors.primary;
      case AppButtonVariant.destructive:
        return AppColors.error;
      case AppButtonVariant.glass:
        return AppColors.primary;
    }
  }

  Border? get _border {
    if (variant == AppButtonVariant.secondary ||
        variant == AppButtonVariant.glass) {
      return Border.all(
        color: onPressed == null
            ? AppColors.surfaceVariant
            : AppColors.primaryLight.withValues(alpha: 0.3),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveContainer(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 52,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: _border,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: _textColor, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: AppTypography.label.copyWith(
                        color: _textColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
