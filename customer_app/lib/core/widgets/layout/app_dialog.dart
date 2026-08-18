import 'package:flutter/material.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_typography.dart';
import '../../../app/theme/app_colors.dart';

class AppDialog {
  static Future<T?> showConfirmation<T>({
    required BuildContext context,
    required String title,
    required String description,
    required String confirmText,
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        title: Text(title, style: AppTypography.title),
        content: Text(description, style: AppTypography.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              cancelText,
              style: AppTypography.label.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true as T),
            child: Text(
              confirmText,
              style: AppTypography.label.copyWith(
                color: isDestructive ? AppColors.error : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
