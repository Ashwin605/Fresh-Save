import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../providers/discovery_stores_provider.dart';
import 'store_discovery_card.dart';

class DiscoveryStoresResults extends ConsumerWidget {
  const DiscoveryStoresResults({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoveryStoresProvider);
    final notifier = ref.read(discoveryStoresProvider.notifier);

    if (state.status == DiscoveryStoresStatus.error && state.stores.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.sm),
              Text('Couldn\'t load nearby stores.', style: AppTypography.title),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  state.errorMessage!,
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Retry',
                onPressed: () => notifier.fetchInitial(),
              ),
            ],
          ),
        ),
      );
    }

    if (state.status == DiscoveryStoresStatus.loading && state.stores.isEmpty) {
      return SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.md),
              child: AppSkeleton(
                width: double.infinity,
                height: 240,
                borderRadius: 16,
              ),
            ),
            childCount: 4,
          ),
        ),
      );
    }

    if (state.stores.isEmpty) {
      return SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.store_outlined,
                size: 48,
                color: AppColors.textDisabled,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No stores found nearby.',
                style: AppTypography.title,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Increase Radius',
                variant: AppButtonVariant.secondary,
                onPressed: () => notifier.updateRadius(state.radius + 5.0),
              )
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppSpacing.md),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final store = state.stores[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: StoreDiscoveryCard(
                store: store,
                onTap: () {
                  // Navigate to store details
                  // context.push('/stores/${store.id}');
                },
              ),
            );
          },
          childCount: state.stores.length,
        ),
      ),
    );
  }
}
