import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../../auth/domain/models/auth_models.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    if (user == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile', style: AppTypography.headline),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  _buildProfileHeader(user).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildSectionHeader('FreshSave Activity').animate().fade(duration: AppAnimations.medium, delay: 100.ms),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.history_rounded,
                          title: 'My Reservations',
                          onTap: () => context.push('/reservation/history'),
                        ),
                        Divider(height: 1, indent: 56, color: AppColors.border.withValues(alpha: 0.5)),
                        _buildSettingsTile(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          onTap: () => context.push('/notifications'),
                        ),
                      ],
                    ),
                  ).animate().fade(duration: AppAnimations.medium, delay: 150.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Preferences').animate().fade(duration: AppAnimations.medium, delay: 200.ms),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.location_on_outlined,
                          title: 'Location Preferences',
                          subtitle: 'Manage search radius and location',
                          onTap: () => context.push('/location-selector'),
                        ),
                        Divider(height: 1, indent: 56, color: AppColors.border.withValues(alpha: 0.5)),
                        _buildSettingsTile(
                          icon: Icons.notifications_active_outlined,
                          title: 'Notification Preferences',
                          subtitle: 'Manage alerts and emails',
                          onTap: () => context.push('/profile/notifications'),
                        ),
                      ],
                    ),
                  ).animate().fade(duration: AppAnimations.medium, delay: 250.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('Account & Security').animate().fade(duration: AppAnimations.medium, delay: 300.ms),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: 'Change Password',
                          onTap: () => context.push('/profile/security'),
                        ),
                        Divider(height: 1, indent: 56, color: AppColors.border.withValues(alpha: 0.5)),
                        _buildSettingsTile(
                          icon: Icons.logout_rounded,
                          title: 'Log Out',
                          textColor: AppColors.error,
                          iconColor: AppColors.error,
                          onTap: () => _showLogoutDialog(context, ref),
                        ),
                      ],
                    ),
                  ).animate().fade(duration: AppAnimations.medium, delay: 350.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 120), // Bottom padding for shell navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(User user) {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 4),
          ),
          child: Center(
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
              style: AppTypography.display.copyWith(color: AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(user.name, style: AppTypography.headline),
        const SizedBox(height: AppSpacing.xs),
        Text(
          user.email,
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
        if (user.phone != null && user.phone!.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            user.phone!,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: AppSpacing.xs,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color textColor = AppColors.textPrimary,
    Color iconColor = AppColors.textSecondary,
  }) {
    return InteractiveContainer(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor == AppColors.error ? AppColors.error.withValues(alpha: 0.1) : AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.body.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.label.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Text('Log Out', style: AppTypography.headline),
        content: Text('Are you sure you want to log out of FreshSave?',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
            },
            child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
