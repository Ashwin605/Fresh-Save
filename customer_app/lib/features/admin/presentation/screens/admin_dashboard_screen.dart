import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/layout/app_card.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard Overview',
              style: AppTypography.display.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Welcome back! Here is what\'s happening on FreshSave today.',
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            
            // KPI Cards Row
            ref.watch(adminDashboardMetricsProvider).when(
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text('Failed to load metrics: $err')),
              ),
              data: (metrics) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 1000;
                    
                    final cards = [
                      _AnimatedKpiCard(
                        title: 'Total Users',
                        value: '${metrics['totalUsers'] ?? 0}',
                        trend: 'Real-time',
                        icon: Icons.people_outline,
                        color: const Color(0xFF3B82F6), // Blue
                        delay: 0,
                        width: isNarrow ? constraints.maxWidth / 2 - 8 : null,
                      ),
                      _AnimatedKpiCard(
                        title: 'Active Stores',
                        value: '${metrics['registeredStores'] ?? 0}',
                        trend: 'Real-time',
                        icon: Icons.storefront_outlined,
                        color: const Color(0xFF10B981), // Emerald
                        delay: 100,
                        width: isNarrow ? constraints.maxWidth / 2 - 8 : null,
                      ),
                      _AnimatedKpiCard(
                        title: 'Active Offers',
                        value: '${metrics['activeOffers'] ?? 0}',
                        trend: 'Real-time',
                        icon: Icons.local_offer_outlined,
                        color: const Color(0xFFF59E0B), // Amber
                        delay: 200,
                        width: isNarrow ? constraints.maxWidth / 2 - 8 : null,
                      ),
                      _AnimatedKpiCard(
                        title: 'Total Reservations',
                        value: '${metrics['totalReservations'] ?? 0}',
                        trend: 'Real-time',
                        icon: Icons.receipt_long_outlined,
                        color: const Color(0xFF8B5CF6), // Purple
                        delay: 300,
                        width: isNarrow ? constraints.maxWidth / 2 - 8 : null,
                      ),
                    ];
                    
                    if (isNarrow) {
                      return Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: cards,
                      );
                    }
                    
                    return Row(
                      children: [
                        Expanded(child: cards[0]),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: cards[1]),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: cards[2]),
                        const SizedBox(width: AppSpacing.lg),
                        Expanded(child: cards[3]),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Charts and Activity Area
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _MockChartSection(),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  flex: 1,
                  child: _RecentActivitySection(),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

class _AnimatedKpiCard extends StatefulWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final int delay;
  final double? width;

  const _AnimatedKpiCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    required this.delay,
    this.width,
  });

  @override
  State<_AnimatedKpiCard> createState() => _AnimatedKpiCardState();
}

class _AnimatedKpiCardState extends State<_AnimatedKpiCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SizedBox(
          width: widget.width,
          child: AppCard(
            variant: AppCardVariant.elevated,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: AppTypography.body.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(widget.icon, color: widget.color, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.value,
                  style: AppTypography.display.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(Icons.trending_up, color: AppColors.success, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.trend,
                      style: AppTypography.label.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MockChartSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Platform Growth',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'New users and reservations over the last 7 days.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _ChartBar(height: 0, label: 'Mon'),
                _ChartBar(height: 0, label: 'Tue'),
                _ChartBar(height: 0, label: 'Wed'),
                _ChartBar(height: 0, label: 'Thu'),
                _ChartBar(height: 0, label: 'Fri'),
                _ChartBar(height: 0, label: 'Sat'),
                _ChartBar(height: 0, label: 'Sun'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  final double height;
  final String label;

  const _ChartBar({
    required this.height,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 40,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [AppColors.surfaceVariant, AppColors.border],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassSurface(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTypography.headline.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Live updates from the platform.',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  Icon(Icons.inbox_outlined, size: 48, color: AppColors.textSecondary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'No recent activity',
                    style: AppTypography.body.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


