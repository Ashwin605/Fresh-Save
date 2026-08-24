import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/layout/interactive_container.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Dynamic Background Texture
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.15),
                    AppColors.background.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ).animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            ).scaleXY(end: 1.1, duration: const Duration(seconds: 4), curve: Curves.easeInOutSine),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.1),
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
                  // Branding
                  const Text(
                    'FreshSave',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans', // Fallback
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -1.5,
                    ),
                  ).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Welcome.',
                    style: AppTypography.display.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'How would you like to continue?',
                    style: AppTypography.title.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ).animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.2, end: 0),

                  const Spacer(),

                  // Role Selection Cards
                  GlassSurface(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    borderRadius: AppRadius.xl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildRoleCard(
                          context,
                          title: 'Continue as Customer',
                          subtitle: 'Discover deals and save food nearby',
                          icon: Icons.person_outline,
                          onTap: () => context.push('/login'),
                        ).animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideX(begin: 0.1, end: 0),
                        const SizedBox(height: AppSpacing.md),
                        _buildRoleCard(
                          context,
                          title: 'Continue as Shopkeeper',
                          subtitle: 'Manage your store and publish deals',
                          icon: Icons.store_mall_directory_outlined,
                          onTap: () => context.push('/owner/login'),
                          isSecondary: true,
                        ).animate().fade(duration: AppAnimations.medium, delay: 500.ms).slideX(begin: 0.1, end: 0),
                      ],
                    ),
                  ).animate().fade(duration: AppAnimations.medium, delay: 300.ms).scaleXY(begin: 0.95, end: 1.0),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
    bool isSecondary = false,
  }) {
    return InteractiveContainer(
      onTap: onTap,
      scaleDown: 0.96,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSecondary ? AppColors.surface : AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: isSecondary 
            ? Border.all(color: AppColors.border, width: 1.5) 
            : null,
          boxShadow: [
            if (!isSecondary)
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSecondary 
                  ? AppColors.primary.withValues(alpha: 0.08) 
                  : Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSecondary ? AppColors.primary : Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.title.copyWith(
                      color: isSecondary ? AppColors.textPrimary : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: isSecondary 
                        ? AppColors.textSecondary 
                        : Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isSecondary ? AppColors.textSecondary : Colors.white,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
