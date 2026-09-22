import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../providers/notification_preferences_provider.dart';
import 'package:flutter/services.dart';

class OwnerNotificationPreferencesScreen extends ConsumerWidget {
  const OwnerNotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notificationPreferencesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        backgroundColor: AppColors.surface.withValues(alpha: 0.8),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(notificationPreferencesProvider.notifier).refresh(),
        child: _buildBody(context, ref, state),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    NotificationPreferencesState state,
  ) {
    if (state.isLoading && state.preferences == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.preferences == null) {
      return Center(
        child: AppErrorView(
          message: state.error!,
          onRetry: () =>
              ref.read(notificationPreferencesProvider.notifier).refresh(),
        ),
      );
    }

    final prefs = state.preferences;
    if (prefs == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.isLoading) const LinearProgressIndicator(),
          const SizedBox(height: AppSpacing.sm),
          _buildSectionHeader('DELIVERY CHANNELS'),
          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Push Notifications',
              subtitle: 'Receive alerts on your device',
              value: prefs.pushEnabled,
              onChanged: (v) => _updatePref(context, ref, 'pushEnabled', v),
            ),
            const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.border,
            ),
            _buildSwitchTile(
              title: 'Email Notifications',
              subtitle: 'Receive updates via email',
              value: prefs.emailEnabled,
              onChanged: (v) => _updatePref(context, ref, 'emailEnabled', v),
            ),
            const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.border,
            ),
            _buildSwitchTile(
              title: 'In-App Notifications',
              subtitle: 'Show alerts inside the app',
              value: prefs.inAppEnabled,
              onChanged: (v) => _updatePref(context, ref, 'inAppEnabled', v),
            ),
          ]),
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('ALERTS'),
          _buildSettingsCard([
            _buildSwitchTile(
              title: 'Reservation Updates',
              subtitle: 'New, confirmed, and cancelled reservations',
              value: prefs.reservationUpdates,
              onChanged: (v) =>
                  _updatePref(context, ref, 'reservationUpdates', v),
            ),
            const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.border,
            ),
            _buildSwitchTile(
              title: 'Offer Alerts',
              subtitle: 'Offers activating, expiring, or selling out',
              value: prefs.offerAlerts,
              onChanged: (v) => _updatePref(context, ref, 'offerAlerts', v),
            ),
            const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.border,
            ),
            _buildSwitchTile(
              title: 'Inventory Alerts',
              subtitle: 'Stock running low or expiring soon',
              value: prefs.inventoryAlerts,
              onChanged: (v) => _updatePref(context, ref, 'inventoryAlerts', v),
            ),
            const Divider(
              height: 1,
              indent: 16,
              endIndent: 16,
              color: AppColors.border,
            ),
            _buildSwitchTile(
              title: 'Marketing & Tips',
              subtitle: 'Platform updates and optimization tips',
              value: prefs.marketingAlerts,
              onChanged: (v) => _updatePref(context, ref, 'marketingAlerts', v),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> _updatePref(
    BuildContext context,
    WidgetRef ref,
    String key,
    bool value,
  ) async {
    final success = await ref
        .read(notificationPreferencesProvider.notifier)
        .updatePreference({key: value});
    if (!success && context.mounted) {
      final error =
          ref.read(notificationPreferencesProvider).error ??
          'Failed to update preference';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: AppTypography.label.copyWith(
          color: AppColors.textSecondary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Column(children: children),
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
    return SwitchListTile(
      title: Text(
        title,
        style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      value: value,
      onChanged: (v) {
        HapticFeedback.lightImpact();
        onChanged(v);
      },
      activeThumbColor: AppColors.primary,
    );
  }
}
