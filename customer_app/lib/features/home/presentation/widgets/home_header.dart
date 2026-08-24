import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../location/presentation/widgets/location_status_chip.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final unreadCountAsync = ref.watch(unreadCountProvider);
    final hour = DateTime.now().hour;
    final String greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.background.withValues(alpha: 0.95),
      elevation: 0,
      scrolledUnderElevation: 4,
      shadowColor: AppColors.primary.withValues(alpha: 0.1),
      toolbarHeight: 72,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$greeting,',
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              if (user != null)
                Text(
                  ' ${user.name.split(' ').first}',
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.2, end: 0),
          const SizedBox(height: 4),
          InteractiveContainer(
            onTap: () => context.push('/location-selector'),
            scaleDown: 0.95,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                const Flexible(
                  child: LocationStatusChip(),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
      actions: [
        InteractiveContainer(
          onTap: () => context.push('/notifications'),
          scaleDown: 0.9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
              if (!unreadCountAsync.isLoading &&
                  unreadCountAsync.hasValue &&
                  unreadCountAsync.value! > 0)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                    child: Text(
                      unreadCountAsync.value! > 99
                          ? '99+'
                          : unreadCountAsync.value!.toString(),
                      style: AppTypography.label.copyWith(
                        color: AppColors.surface,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ).animate().scale(curve: AppAnimations.bounceCurve),
                ),
            ],
          ),
        ).animate().fade(duration: AppAnimations.medium, delay: 200.ms).scaleXY(begin: 0.8, end: 1.0),
        const SizedBox(width: AppSpacing.sm),
        InteractiveContainer(
          onTap: () => context.push('/profile'),
          scaleDown: 0.9,
          child: Hero(
            tag: 'profile_avatar',
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                  style: AppTypography.title.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ).animate().fade(duration: AppAnimations.medium, delay: 300.ms).scaleXY(begin: 0.8, end: 1.0),
        const SizedBox(width: AppSpacing.md),
      ],
    );
  }
}
