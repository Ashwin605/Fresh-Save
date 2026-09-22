import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radius.dart';
import '../../../app/theme/app_shadows.dart';
import 'interactive_container.dart';
import '../glass_surface.dart';

enum AppCardVariant { outlined, elevated, filled, glass }

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.outlined,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppCardVariant.glass) {
      return InteractiveContainer(
        onTap: onTap,
        enableFeedback: onTap != null,
        child: GlassSurface(
          borderRadius: AppRadius.lg,
          padding: padding,
          child: child,
        ),
      );
    }

    final BoxDecoration decoration = BoxDecoration(
      color: variant == AppCardVariant.filled ? AppColors.surfaceVariant : AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: variant == AppCardVariant.outlined
          ? Border.all(color: AppColors.border, width: 1)
          : null,
      boxShadow: variant == AppCardVariant.elevated ? AppShadows.elevated : [],
    );

    final Widget card = Container(
      padding: padding,
      decoration: decoration,
      child: child,
    );

    if (onTap != null) {
      return InteractiveContainer(onTap: onTap, child: card);
    }

    return card;
  }
}
