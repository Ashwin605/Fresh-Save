import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';
import '../network/app_error.dart';
import '../network/app_error_mapper.dart';

class AppErrorView extends StatelessWidget {
  final String? title;
  final String? message;
  final AppError? error;
  final VoidCallback? onRetry;

  const AppErrorView({
    super.key,
    this.title,
    this.message,
    this.error,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle =
        title ?? (error != null ? AppErrorMapper.getTitle(error!) : 'Oops!');
    final displayMessage =
        message ??
        (error != null
            ? AppErrorMapper.getMessage(error!)
            : 'Something went wrong.');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(
              displayTitle,
              style: AppTypography.headline,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              displayMessage,
              style: AppTypography.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
          ],
        ),
      ),
    );
  }
}
