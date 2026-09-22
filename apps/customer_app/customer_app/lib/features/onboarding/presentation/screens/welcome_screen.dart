import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/glass_surface.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -50,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.2),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scaleXY(end: 1.1, duration: const Duration(seconds: 4), curve: Curves.easeInOutSine),
          ),
          Positioned(
            bottom: 150,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.15),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scaleXY(begin: 1.05, end: 0.95, duration: const Duration(seconds: 5), curve: Curves.easeInOutSine),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'FreshSave',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -1,
                    ),
                  ).animate().fade(duration: AppAnimations.medium).slideY(begin: -0.5, end: 0),
                  const SizedBox(height: AppSpacing.xxl),

                  // Floating hero element
                  Expanded(
                    child: Center(
                      child: GlassSurface(
                        padding: const EdgeInsets.all(AppSpacing.xxl),
                        child: Icon(
                          Icons.storefront_rounded,
                          size: 96,
                          color: AppColors.primary,
                        ).animate(
                          onPlay: (controller) => controller.repeat(reverse: true),
                        ).slideY(begin: -0.05, end: 0.05, duration: const Duration(seconds: 3), curve: Curves.easeInOutSine),
                      ),
                    ).animate().fade(duration: AppAnimations.medium, delay: 200.ms).scale(curve: AppAnimations.bounceCurve),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Discover good products before they go to waste.',
                        style: AppTypography.display.copyWith(height: 1.15),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton.primary(
                        label: 'Get Started',
                        onPressed: () => context.push('/onboarding/value'),
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ).animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideY(begin: 0.2, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
