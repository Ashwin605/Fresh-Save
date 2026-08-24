import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/notification_preferences_provider.dart';

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefsAsync = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Notification Preferences',
          style: AppTypography.title,
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: prefsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, _) => Center(
          child: Text(
            'Could not load preferences.\nTap to retry.',
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: AppColors.error),
          ),
        ),
        data: (prefs) {
          final notifier = ref.read(notificationPreferencesProvider.notifier);

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: [
              _buildSectionTitle('Delivery Methods'),
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive alerts on your device',
                value: prefs.pushEnabled,
                onChanged: (val) =>
                    _handleToggle(context, () => notifier.togglePush(val)),
              ),
              _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive alerts via email',
                value: prefs.emailEnabled,
                onChanged: (val) =>
                    _handleToggle(context, () => notifier.toggleEmail(val)),
              ),
              _buildSwitchTile(
                title: 'In-App Notifications',
                subtitle: 'See notifications inside the app',
                value: prefs.inAppEnabled,
                onChanged: (val) =>
                    _handleToggle(context, () => notifier.toggleInApp(val)),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildSectionTitle('Notification Types'),
              _buildSwitchTile(
                title: 'Reservation Updates',
                subtitle: 'Status changes on your reservations',
                value: prefs.reservationUpdates,
                onChanged: (val) => _handleToggle(
                  context,
                  () => notifier.toggleReservationUpdates(val),
                ),
              ),
              _buildSwitchTile(
                title: 'Offer Alerts',
                subtitle: 'New offers from saved stores',
                value: prefs.offerAlerts,
                onChanged: (val) => _handleToggle(
                  context,
                  () => notifier.toggleOfferAlerts(val),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.sm,
        left: AppSpacing.xs,
      ),
      child: Text(
        title.toUpperCase(),
        style: AppTypography.label.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textDisabled),
      ),
      child: SwitchListTile.adaptive(
        activeTrackColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 4,
        ),
        title: Text(
          title,
          style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.label.copyWith(color: AppColors.textSecondary),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  void _handleToggle(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Couldn\'t update notification preference.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
