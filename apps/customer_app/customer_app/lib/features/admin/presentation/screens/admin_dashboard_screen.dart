import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../providers/admin_dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(context),
            const SizedBox(height: AppSpacing.xxl),
            
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
                    final isMobile = constraints.maxWidth < 600;
                    final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 1000;
                    final isDesktop = constraints.maxWidth >= 1000;
                    
                    final opCards = [
                      _CompactKpiCard(
                        title: 'Total Stores',
                        value: '${metrics['stores']?['total'] ?? 0}',
                        trend: '${metrics['stores']?['active'] ?? 0} Active • ${metrics['stores']?['pendingVerification'] ?? 0} Pending',
                        icon: Icons.storefront_outlined,
                        color: const Color(0xFF2563EB),
                        delay: 0,
                      ),
                      _CompactKpiCard(
                        title: 'Registered Shopkeepers',
                        value: '${metrics['shopkeepers']?['total'] ?? 0}',
                        trend: '${metrics['shopkeepers']?['active'] ?? 0} Active Accounts',
                        icon: Icons.person_outline,
                        color: const Color(0xFF0D9488),
                        delay: 50,
                      ),
                      _CompactKpiCard(
                        title: 'Published Products',
                        value: '${metrics['products']?['active'] ?? 0}',
                        trend: '${metrics['products']?['total'] ?? 0} Total (${metrics['products']?['inactive'] ?? 0} Inactive)',
                        icon: Icons.inventory_2_outlined,
                        color: const Color(0xFF7C3AED),
                        delay: 100,
                      ),
                      _CompactKpiCard(
                        title: 'Active Promotions',
                        value: '${(metrics['offers']?['active'] ?? 0) + (metrics['coupons']?['active'] ?? 0)}',
                        trend: '${metrics['offers']?['active'] ?? 0} Offers • ${metrics['coupons']?['active'] ?? 0} Coupons',
                        icon: Icons.local_offer_outlined,
                        color: const Color(0xFFEA580C),
                        delay: 150,
                      ),
                    ];

                    final finCards = [
                      _CompactKpiCard(
                        title: 'Total Orders',
                        value: '${metrics['orders']?['total'] ?? 0}',
                        trend: '${metrics['orders']?['completed'] ?? 0} Completed',
                        icon: Icons.receipt_long_outlined,
                        color: const Color(0xFF3B82F6),
                        delay: 200,
                      ),
                      _CompactKpiCard(
                        title: 'Net Revenue',
                        value: '₹${metrics['revenue']?['net'] ?? 0}',
                        trend: 'Gross: ₹${metrics['revenue']?['gross'] ?? 0}',
                        icon: Icons.currency_rupee,
                        color: const Color(0xFF10B981),
                        delay: 250,
                      ),
                      _CompactKpiCard(
                        title: 'Discounts Given',
                        value: '₹${metrics['revenue']?['discounts'] ?? 0}',
                        trend: '${metrics['coupons']?['usage'] ?? 0} Coupon Usages',
                        icon: Icons.money_off,
                        color: const Color(0xFFF59E0B),
                        delay: 300,
                      ),
                      _CompactKpiCard(
                        title: 'Customer Ratings',
                        value: '${metrics['ratings']?['average'] ?? '0.0'} ★',
                        trend: '${metrics['ratings']?['total'] ?? 0} Verified Reviews',
                        icon: Icons.star_rate_rounded,
                        color: const Color(0xFFEAB308),
                        delay: 350,
                      ),
                    ];

                    Widget buildCardRow(List<Widget> rowCards) {
                      if (isMobile) {
                        return Column(
                          children: [
                            Row(children: [Expanded(child: rowCards[0]), const SizedBox(width: AppSpacing.md), Expanded(child: rowCards[1])]),
                            const SizedBox(height: AppSpacing.md),
                            Row(children: [Expanded(child: rowCards[2]), const SizedBox(width: AppSpacing.md), Expanded(child: rowCards[3])]),
                          ],
                        );
                      } else if (isTablet) {
                        return Column(
                          children: [
                            Row(children: [Expanded(child: rowCards[0]), const SizedBox(width: AppSpacing.lg), Expanded(child: rowCards[1])]),
                            const SizedBox(height: AppSpacing.lg),
                            Row(children: [Expanded(child: rowCards[2]), const SizedBox(width: AppSpacing.lg), Expanded(child: rowCards[3])]),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(child: rowCards[0]), const SizedBox(width: AppSpacing.lg),
                            Expanded(child: rowCards[1]), const SizedBox(width: AppSpacing.lg),
                            Expanded(child: rowCards[2]), const SizedBox(width: AppSpacing.lg),
                            Expanded(child: rowCards[3]),
                          ],
                        );
                      }
                    }

                    Widget kpiSection = Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildCardRow(opCards),
                        const SizedBox(height: AppSpacing.lg),
                        buildCardRow(finCards),
                      ],
                    );

                    Widget contentSection;
                    if (isDesktop) {
                      contentSection = Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(
                            flex: 7,
                            child: _PerformanceSection(),
                          ),
                          SizedBox(width: AppSpacing.xl),
                          Expanded(
                            flex: 4,
                            child: _RecentOrdersSection(),
                          ),
                        ],
                      );
                    } else {
                      contentSection = Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: const [
                          _PerformanceSection(),
                          SizedBox(height: AppSpacing.xl),
                          _RecentOrdersSection(),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        kpiSection,
                        const SizedBox(height: AppSpacing.xl),
                        contentSection,
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isMobile) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dashboard',
                      style: AppTypography.headline.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Overview of your FreshSave business performance',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _buildDateFilter(),
            ],
          );
        }
        
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: AppTypography.headline.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Overview of your FreshSave business performance',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            _buildDateFilter(),
          ],
        );
      }
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('All time', style: AppTypography.label.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _CompactKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final int delay;

  const _CompactKpiCard({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.display.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.call_made, color: AppColors.textSecondary, size: 12),
              const SizedBox(width: 4),
              Text(
                trend,
                style: AppTypography.label.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: delay.ms).fade(duration: 400.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}

class _PerformanceSection extends StatelessWidget {
  const _PerformanceSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              Text('Performance Overview', style: AppTypography.title.copyWith(fontWeight: FontWeight.bold)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  _FilterTab('Revenue', true),
                  SizedBox(width: 8),
                  _FilterTab('Orders', false),
                  SizedBox(width: 8),
                  _FilterTab('Discounts', false),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                Icon(Icons.bar_chart, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.2)),
                const SizedBox(height: 16),
                Text('No activity yet', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(
                  'Your performance data will appear here once customers start placing orders.', 
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ]
            )
          ),
          const SizedBox(height: 32),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  
  const _FilterTab(this.label, this.isSelected);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.border.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: AppTypography.label.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _RecentOrdersSection extends StatelessWidget {
  const _RecentOrdersSection();
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recent Orders', style: AppTypography.title.copyWith(fontWeight: FontWeight.bold)),
              Icon(Icons.more_horiz, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(Icons.receipt_long_outlined, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(
                    'New customer orders will appear here.', 
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View All Orders'),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic);
  }
}
