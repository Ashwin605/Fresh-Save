import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';
import '../layout/interactive_container.dart';

enum AppButtonVariant { primary, secondary, destructive, glass, text }

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

  const AppButton.text({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : variant = AppButtonVariant.text;

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
      case AppButtonVariant.text:
        return Colors.transparent;
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
      case AppButtonVariant.text:
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
    final Widget buttonContent = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 56, // Slightly taller for better touch target (premium feel)
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: _border,
        boxShadow: variant == AppButtonVariant.primary && onPressed != null
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Center(
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: _textColor, size: 22),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: AppTypography.title.copyWith(
                      color: _textColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );

    return InteractiveContainer(
      onTap: isLoading ? null : onPressed,
      child: buttonContent,
    );
  }
}
