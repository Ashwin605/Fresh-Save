import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/network/result.dart';
import '../../../details/domain/models/details_models.dart';
import '../../../details/presentation/providers/details_providers.dart';
import '../../domain/models/reservation_models.dart';
import '../../data/repositories/reservation_repository.dart';

class ReservationReviewScreen extends ConsumerStatefulWidget {
  final String offerId;
  const ReservationReviewScreen({super.key, required this.offerId});

  @override
  ConsumerState<ReservationReviewScreen> createState() =>
      _ReservationReviewScreenState();
}

class _ReservationReviewScreenState
    extends ConsumerState<ReservationReviewScreen> {
  int _quantity = 1;
  bool _isSubmitting = false;
  late final String _idempotencyKey;

  @override
  void initState() {
    super.initState();
    _idempotencyKey = const Uuid().v4();
  }

  void _incrementQuantity(int max) {
    if (_quantity < max) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  Future<void> _submitReservation(DealDetail deal) async {
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final request = CreateReservationRequest(
      storeId: deal.store.id,
      items: [
        ReservationItemRequest(
          inventoryId: deal.inventory.id,
          quantity: _quantity,
        ),
      ],
      notes: 'Customer pick-up', // Optional
    );

    final repo = ref.read(reservationRepositoryProvider);
    final result = await repo.createReservation(
      request,
      idempotencyKey: _idempotencyKey,
    );

    if (!mounted) return;

    if (result is Success<Reservation>) {
      context.go('/reservation/success/${result.data.id}');
    } else if (result is Failure<Reservation>) {
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.error.message ?? 'Failed to reserve. Please try again.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final offerAsync = ref.watch(offerDetailsProvider(widget.offerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Review Reservation', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
      ),
      body: offerAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => AppErrorView(
          message: 'Failed to load details',
          onRetry: () => ref.invalidate(offerDetailsProvider(widget.offerId)),
        ),
        data: (deal) => _buildContent(context, deal),
      ),
    );
  }

  Widget _buildContent(BuildContext context, DealDetail deal) {
    // Basic quantity constraint
    final maxQuantity = deal.inventory.availableQuantity > 0
        ? deal.inventory.availableQuantity
        : 1;
    if (_quantity > maxQuantity) {
      _quantity = maxQuantity;
    }

    final total = deal.offer.discountedPrice * _quantity;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildProductSummary(deal),
              const SizedBox(height: AppSpacing.xl),
              _buildQuantitySelector(maxQuantity),
              const SizedBox(height: AppSpacing.xl),
              _buildPriceSummary(deal, total),
              const SizedBox(height: AppSpacing.xl),
              _buildStoreSummary(deal),
              const SizedBox(height: AppSpacing.xl),
              _buildRules(),
            ],
          ),
        ),
        _buildStickyCTA(deal, total),
      ],
    );
  }

  Widget _buildProductSummary(DealDetail deal) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: deal.product.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: AppNetworkImage(
                      imageUrl: deal.product.image!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.fastfood, color: AppColors.textDisabled),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(deal.product.name, style: AppTypography.title),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  deal.offer.title ?? 'Discounted Item',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantitySelector(int maxQuantity) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Quantity', style: AppTypography.title),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              color: _quantity > 1
                  ? AppColors.textPrimary
                  : AppColors.textDisabled,
              onPressed: _quantity > 1 ? _decrementQuantity : null,
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$_quantity',
                textAlign: TextAlign.center,
                style: AppTypography.headline,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: _quantity < maxQuantity
                  ? AppColors.textPrimary
                  : AppColors.textDisabled,
              onPressed: _quantity < maxQuantity
                  ? () => _incrementQuantity(maxQuantity)
                  : null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceSummary(DealDetail deal, double total) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Unit Price', style: AppTypography.body),
              Text(
                '₹${deal.offer.discountedPrice.toStringAsFixed(2)}',
                style: AppTypography.body,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Price', style: AppTypography.title),
              Text(
                '₹${total.toStringAsFixed(2)}',
                style: AppTypography.title.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Payment is collected at the store.',
            style: AppTypography.label.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSummary(DealDetail deal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Pickup Information', style: AppTypography.title),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.surfaceVariant),
          ),
          child: Row(
            children: [
              const Icon(Icons.storefront, color: AppColors.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deal.store.name, style: AppTypography.body),
                    if (deal.store.address != null)
                      Text(
                        deal.store.address!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRules() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Reservation Rules', style: AppTypography.title),
        const SizedBox(height: AppSpacing.sm),
        _buildRuleItem(
          Icons.timer,
          'Hold Time: Reserved items are typically held for a limited time.',
        ),
        _buildRuleItem(
          Icons.cancel,
          'Cancellation: Please cancel if you cannot make it to the store.',
        ),
      ],
    );
  }

  Widget _buildRuleItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCTA(DealDetail deal, double total) {
    return GlassSurface(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            label: _isSubmitting ? 'Confirming...' : 'Confirm Reservation',
            variant: AppButtonVariant.primary,
            isLoading: _isSubmitting,
            onPressed: () => _submitReservation(deal),
          ),
        ),
      ),
    );
  }
}
