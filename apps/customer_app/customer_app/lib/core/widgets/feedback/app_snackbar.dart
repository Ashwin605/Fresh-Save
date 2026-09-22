import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_shadows.dart';

enum SnackbarVariant { success, error, warning, info }

class AppSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    SnackbarVariant variant = SnackbarVariant.info,
  }) {
    Color bgColor;
    IconData icon;

    switch (variant) {
      case SnackbarVariant.success:
        bgColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarVariant.error:
        bgColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case SnackbarVariant.warning:
        bgColor = AppColors.warning;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarVariant.info:
        bgColor = AppColors.textPrimary;
        icon = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.floating,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTypography.bodySmall.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
