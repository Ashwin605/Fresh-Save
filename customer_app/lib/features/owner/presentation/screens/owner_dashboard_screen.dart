import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/owner_state_provider.dart';

import '../../../notifications/presentation/providers/notification_providers.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownerState = ref.watch(ownerStateProvider);

    if (ownerState.contextState == OwnerContextState.loading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          ownerState.activeStore?.name ?? 'Dashboard',
          style: AppTypography.title,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Open store switcher bottom sheet
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.push('/owner/inventory');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.fastfood_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.push('/owner/products');
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.manage_accounts,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.push('/owner/profile');
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final unreadState = ref.watch(unreadCountProvider);
              final unreadCount = unreadState.value ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () {
                      context.push('/owner/notifications');
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              context.push('/owner/settings');
            },
          ),
        ],
      ),
      body: ownerState.contextState == OwnerContextState.loading
          ? const Center(child: CircularProgressIndicator())
          : _buildDashboardContent(context, ownerState),
    );
  }

  Widget _buildDashboardContent(BuildContext context, OwnerState state) {
    if (state.dashboardMetrics != null) {
      final items = [
        _buildMetricCard(
          'Active Offers',
          state.dashboardMetrics!.activeOffers.toString(),
        ),
        _buildMetricCard(
          'Pending',
          state.dashboardMetrics!.pendingReservations.toString(),
        ),
        _buildMetricCard(
          "Today's Pickups",
          state.dashboardMetrics!.todayPickups.toString(),
        ),
      ];

      return ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.5,
            children: items,
          ).animate().fade(duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
        ],
      );
    }

    // Show welcome dashboard with quick actions when metrics aren't loaded
    final items = [
      Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${state.business?.name ?? 'Shop Owner'}!',
              style: AppTypography.headline.copyWith(color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              state.activeStore != null
                  ? 'Managing: ${state.activeStore!.name}'
                  : 'Set up your store to get started',
              style: AppTypography.body.copyWith(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: AppSpacing.xl),
      Text('Quick Actions', style: AppTypography.title),
      const SizedBox(height: AppSpacing.md),
      _buildQuickActionCard(
        icon: Icons.inventory_2_outlined,
        title: 'Manage Inventory',
        subtitle: 'Add and update your product stock',
        onTap: () => context.push('/owner/inventory'),
      ),
      const SizedBox(height: AppSpacing.sm),
      _buildQuickActionCard(
        icon: Icons.local_offer_outlined,
        title: 'Create Offers',
        subtitle: 'Publish deals for customers',
        onTap: () => context.push('/owner/offers'),
      ),
      const SizedBox(height: AppSpacing.sm),
      _buildQuickActionCard(
        icon: Icons.receipt_long_outlined,
        title: 'View Reservations',
        subtitle: 'Track customer pickups',
        onTap: () => context.push('/owner/reservations'),
      ),
      const SizedBox(height: AppSpacing.sm),
      _buildQuickActionCard(
        icon: Icons.analytics_outlined,
        title: 'Analytics',
        subtitle: 'View store performance',
        onTap: () => context.push('/owner/analytics'),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: items.animate(interval: 50.ms).fade(duration: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InteractiveContainer(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTypography.label.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value) {
    return AppCard(
      variant: AppCardVariant.elevated,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(value, style: AppTypography.headline),
        ],
      ),
    );
  }
}
