import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
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
      backgroundColor: AppColors.background.withAlpha(240),
      elevation: 0,
      toolbarHeight: 70,
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
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => context.push('/location-selector'),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 6),
                const Expanded(
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
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(
                Icons.notifications_none,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.push('/notifications'),
            ),
            if (!unreadCountAsync.isLoading &&
                unreadCountAsync.hasValue &&
                unreadCountAsync.value! > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    unreadCountAsync.value! > 99
                        ? '99+'
                        : unreadCountAsync.value!.toString(),
                    style: AppTypography.label.copyWith(
                      color: AppColors.surface,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: Hero(
            tag: 'profile_avatar',
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.surfaceVariant,
              child: Text(
                user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
                style: AppTypography.title.copyWith(
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
      ],
    );
  }
}
