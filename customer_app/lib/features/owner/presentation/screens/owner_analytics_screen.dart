import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../providers/analytics_provider.dart';
import '../providers/owner_state_provider.dart';
import '../../domain/models/analytics_models.dart';
import '../widgets/analytics/analytics_kpi_card.dart';
import '../widgets/analytics/analytics_insight_card.dart';

class OwnerAnalyticsScreen extends ConsumerWidget {
  const OwnerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsState = ref.watch(analyticsProvider);
    final activeStore = ref.watch(ownerStateProvider).activeStore;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          activeStore != null ? '${activeStore.name} Analytics' : 'Analytics',
          style: AppTypography.title,
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(analyticsProvider.notifier).refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _buildDateRangeFilter(context, ref, analyticsState),
            ),
            if (analyticsState.isLoading && analyticsState.data == null)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (analyticsState.error != null)
              SliverFillRemaining(
                child: Center(
                  child: AppErrorView(
                    message: analyticsState.error!,
                    onRetry: () =>
                        ref.read(analyticsProvider.notifier).refresh(),
                  ),
                ),
              )
            else if (analyticsState.data != null)
              SliverList(
                delegate: SliverChildListDelegate([
                  _buildKpiSummary(analyticsState.data!.kpiSummary),
                  _buildPerformanceChartPlaceholder(context),
                  _buildInsights(analyticsState.data!.insights, context),
                ]),
              )
            else
              const SliverFillRemaining(
                child: Center(child: Text('No analytics data available.')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateRangeFilter(
    BuildContext context,
    WidgetRef ref,
    AnalyticsState state,
  ) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
        horizontal: AppSpacing.md,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: AnalyticsDateRange.values.map((range) {
            final isSelected = state.dateRange == range;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: ChoiceChip(
                label: Text(
                  range.label,
                  style: AppTypography.label.copyWith(
                    color: isSelected
                        ? AppColors.surface
                        : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.background,
                onSelected: (_) =>
                    ref.read(analyticsProvider.notifier).setDateRange(range),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildKpiSummary(AnalyticsKpiSummary kpiSummary) {
    final currencyFormatter = NumberFormat.simpleCurrency(
      name: kpiSummary.currency,
      decimalDigits: 0,
    );
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Performance Indicators', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.md,
            crossAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
            children: [
              AnalyticsKpiCard(
                title: 'Reservations',
                value: kpiSummary.reservations.toString(),
                icon: Icons.receipt_long_outlined,
              ),
              AnalyticsKpiCard(
                title: 'Completed Pickups',
                value: kpiSummary.completedPickups.toString(),
                icon: Icons.check_circle_outline,
              ),
              AnalyticsKpiCard(
                title: 'Surplus Rescued',
                value: '${kpiSummary.surplusRescued} kg',
                icon: Icons.eco_outlined,
              ),
              AnalyticsKpiCard(
                title: 'Value Generated',
                value: currencyFormatter.format(kpiSummary.valueGenerated),
                icon: Icons.payments_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChartPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Performance Overview', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Text(
                'Chart data unavailable',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsights(List insights, BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Actionable Insights', style: AppTypography.title),
          const SizedBox(height: AppSpacing.md),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: insights.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final insight = insights[index];
              return AnalyticsInsightCard(
                insight: insight,
                onActionTap: insight.actionRoute != null
                    ? () => context.push(insight.actionRoute!)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}
