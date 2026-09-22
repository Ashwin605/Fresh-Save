import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../layout/interactive_container.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isGlass;
  final Color? color;
  final Color? backgroundColor;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.isGlass = false,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InteractiveContainer(
      onTap: onPressed,
      scaleDown: 0.9,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: isGlass
              ? AppColors.glassFill
              : backgroundColor ??
                    (onPressed == null
                        ? AppColors.surfaceVariant
                        : AppColors.surface),
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: isGlass ? Border.all(color: AppColors.glassBorder) : null,
          boxShadow: isGlass || backgroundColor == null
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
        ),
        child: Icon(
          icon,
          color: onPressed == null
              ? AppColors.textDisabled
              : (color ?? AppColors.textPrimary),
          size: 20,
        ),
      ),
    );
  }
}
