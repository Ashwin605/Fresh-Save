import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../domain/models/owner_offer_models.dart';
import '../providers/owner_offer_list_provider.dart';
import '../widgets/offers/offer_management_card.dart';

class OwnerOfferListScreen extends ConsumerWidget {
  const OwnerOfferListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(ownerOfferListProvider);
    final filterState = ref.watch(ownerOfferListFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildFilters(ref, filterState),
            Expanded(
              child: offersState.when(
                data: (response) {
                  final offers = response.items;
                  if (offers.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    itemCount: offers.length,
                    itemBuilder: (context, index) {
                      return OfferManagementCard(offer: offers[index]);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Failed to load offers',
                          style: AppTypography.title,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          onPressed: () =>
                              ref.invalidate(ownerOfferListProvider),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/owner/offers/create'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Create Offer',
          style: AppTypography.label.copyWith(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('Offers', style: AppTypography.headline),
        ],
      ),
    );
  }

  Widget _buildFilters(WidgetRef ref, Map<String, dynamic> state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        children: [
          _buildFilterChip(ref, state, 'All', null),
          _buildFilterChip(ref, state, 'Active', OfferStatus.active),
          _buildFilterChip(ref, state, 'Scheduled', OfferStatus.scheduled),
          _buildFilterChip(ref, state, 'Paused', OfferStatus.paused),
          _buildFilterChip(ref, state, 'Expired', OfferStatus.expired),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    WidgetRef ref,
    Map<String, dynamic> state,
    String label,
    OfferStatus? status,
  ) {
    final isSelected = state['status'] == status;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          ref
              .read(ownerOfferListFilterProvider.notifier)
              .updateFilter('status', selected ? status : null);
        },
        selectedColor: AppColors.primary.withAlpha(20),
        checkmarkColor: AppColors.primary,
        labelStyle: AppTypography.bodySmall.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: AppColors.textDisabled.withAlpha(100),
            ),
            const SizedBox(height: AppSpacing.md),
            Text('No offers found', style: AppTypography.headline),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Create a new offer to expose surplus inventory to customers.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
