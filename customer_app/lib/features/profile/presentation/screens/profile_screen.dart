import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';
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
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile', style: AppTypography.headline),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: AppSpacing.xl),
                  _buildSectionHeader('FreshSave Activity'),
                  AppCard(
                    variant: AppCardVariant.outlined,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.history,
                          title: 'My Reservations',
                          onTap: () => context.push('/reservation/history'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingsTile(
                          icon: Icons.notifications_none,
                          title: 'Notifications',
                          onTap: () => context.push('/notifications'),
                        ),
                      ],
                    ),
                  ),
                  _buildSectionHeader('Preferences'),
                  AppCard(
                    variant: AppCardVariant.outlined,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.location_on_outlined,
                          title: 'Location Preferences',
                          subtitle: 'Manage search radius and location',
                          onTap: () => context.push('/location-selector'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingsTile(
                          icon: Icons.notifications_active_outlined,
                          title: 'Notification Preferences',
                          subtitle: 'Manage alerts and emails',
                          onTap: () => context.push('/profile/notifications'),
                        ),
                      ],
                    ),
                  ),
                  _buildSectionHeader('Account & Security'),
                  AppCard(
                    variant: AppCardVariant.outlined,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildSettingsTile(
                          icon: Icons.lock_outline,
                          title: 'Change Password',
                          onTap: () => context.push('/profile/security'),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildSettingsTile(
                          icon: Icons.logout,
                          title: 'Log Out',
                          textColor: AppColors.error,
                          iconColor: AppColors.error,
                          onTap: () => _showLogoutDialog(context, ref),
                        ),
                      ],
                    ),
                  ),
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
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.surfaceVariant,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: AppTypography.display.copyWith(color: AppColors.primary),
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
        top: AppSpacing.md,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 1.2,
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: AppTypography.body.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: AppTypography.label.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.textSecondary,
        size: 20,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: AppTypography.headline),
        content: const Text(
          'Are you sure you want to log out of FreshSave?',
          style: AppTypography.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
