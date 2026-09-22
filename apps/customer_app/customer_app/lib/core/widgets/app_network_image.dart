import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import 'feedback/app_skeleton.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: AppColors.surfaceVariant,
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.textDisabled,
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return AppSkeleton(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            borderRadius: borderRadius,
          );
        },
      ),
    );
  }
}
