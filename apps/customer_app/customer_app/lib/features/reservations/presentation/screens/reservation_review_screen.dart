import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../../../core/network/result.dart';
import '../../../details/domain/models/details_models.dart';
import '../../../details/presentation/providers/details_providers.dart';
import '../../domain/models/reservation_models.dart';
import '../../data/repositories/reservation_repository.dart';
import '../../data/repositories/pricing_repository.dart';

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

  final TextEditingController _couponController = TextEditingController();
  bool _isCalculating = false;
  Map<String, dynamic>? _pricingData;
  String? _couponMessage;
  String? _appliedCouponCode;
  DealDetail? _cachedDeal;

  @override
  void initState() {
    super.initState();
    _idempotencyKey = const Uuid().v4();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _incrementQuantity(int max) {
    if (_quantity < max) {
      setState(() => _quantity++);
      _recalculatePrice();
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
      _recalculatePrice();
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
      couponCode: _appliedCouponCode,
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
      String errorMessage = result.error.message ?? 'Failed to reserve. Please try again.';
      if (errorMessage.toLowerCase().contains('price') || errorMessage.toLowerCase().contains('changed')) {
        errorMessage = 'Some prices have changed. Please review your cart.';
      } else if (errorMessage.toLowerCase().contains('stock') || errorMessage.toLowerCase().contains('expired') || errorMessage.toLowerCase().contains('not found')) {
        errorMessage = 'Some items are out of stock. Please remove them.';
      } else if (errorMessage.toLowerCase().contains('coupon') || errorMessage.toLowerCase().contains('valid')) {
        errorMessage = 'This coupon is no longer valid.';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _recalculatePrice({bool isApplyingCoupon = false}) async {
    if (_cachedDeal == null) return;
    final deal = _cachedDeal!;
    
    final code = _couponController.text.trim();
    if (isApplyingCoupon && code.isEmpty) return;

    setState(() {
      _isCalculating = true;
      if (isApplyingCoupon) {
        _couponMessage = null;
      }
    });

    final request = CreateReservationRequest(
      storeId: deal.store.id,
      items: [
        ReservationItemRequest(
          inventoryId: deal.inventory.id,
          quantity: _quantity,
        ),
      ],
      couponCode: code.isNotEmpty ? code : null,
    );

    final repo = ref.read(pricingRepositoryProvider);
    final result = await repo.calculateCartPrice(request);

    if (!mounted) return;

    if (result is Success<Map<String, dynamic>>) {
      setState(() {
        _pricingData = result.data;
        if (code.isNotEmpty) {
           final couponInfo = result.data['coupon'];
           if (couponInfo != null) {
              _appliedCouponCode = code;
              if (isApplyingCoupon) _couponMessage = 'Coupon applied successfully!';
           } else {
              _appliedCouponCode = null;
              if (isApplyingCoupon) {
                 _couponMessage = 'Invalid coupon code or does not apply.';
              }
           }
        }
      });
    } else if (result is Failure<Map<String, dynamic>>) {
      setState(() {
        String errorMessage = result.error.message ?? 'Calculation failed';
        if (errorMessage.toLowerCase().contains('coupon') || errorMessage.toLowerCase().contains('valid')) {
          errorMessage = 'This coupon is no longer valid.';
        } else if (errorMessage.toLowerCase().contains('stock') || errorMessage.toLowerCase().contains('expired') || errorMessage.toLowerCase().contains('not found')) {
          errorMessage = 'Some items are out of stock. Please remove them.';
        } else if (errorMessage.toLowerCase().contains('price') || errorMessage.toLowerCase().contains('changed')) {
          errorMessage = 'Some prices have changed. Please review your cart.';
        }

        if (isApplyingCoupon) {
          _couponMessage = errorMessage;
          _appliedCouponCode = null;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        }
      });
    }

    setState(() {
      _isCalculating = false;
    });
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InteractiveContainer(
            onTap: () => context.pop(),
            scaleDown: 0.9,
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
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
    if (_cachedDeal == null) {
      _cachedDeal = deal;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _recalculatePrice();
      });
    }

    // Basic quantity constraint
    final maxQuantity = deal.inventory.availableQuantity > 0
        ? deal.inventory.availableQuantity
        : 1;
    if (_quantity > maxQuantity) {
      _quantity = maxQuantity;
    }

    if (_pricingData == null) {
       return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            physics: const BouncingScrollPhysics(),
            children: [
              _buildProductSummary(deal).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _buildQuantitySelector(maxQuantity).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _buildCouponSection(deal).animate().fade(duration: AppAnimations.medium, delay: 150.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _buildPriceSummary().animate().fade(duration: AppAnimations.medium, delay: 200.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _buildStoreSummary(deal).animate().fade(duration: AppAnimations.medium, delay: 300.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: AppSpacing.xl),
              _buildRules().animate().fade(duration: AppAnimations.medium, delay: 400.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
        _buildStickyCTA(deal),
      ],
    );
  }

  Widget _buildProductSummary(DealDetail deal) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                    fontWeight: FontWeight.w600,
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text('Quantity', style: AppTypography.title),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                InteractiveContainer(
                  onTap: _quantity > 1 ? _decrementQuantity : () {},
                  scaleDown: 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.remove,
                      color: _quantity > 1
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    '$_quantity',
                    textAlign: TextAlign.center,
                    style: AppTypography.title,
                  ),
                ),
                InteractiveContainer(
                  onTap: _quantity < maxQuantity
                      ? () => _incrementQuantity(maxQuantity)
                      : () {},
                  scaleDown: 0.9,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.add,
                      color: _quantity < maxQuantity
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponSection(DealDetail deal, double total) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Have a coupon?', style: AppTypography.title),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _couponController,
                  decoration: InputDecoration(
                    hintText: 'Enter code',
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      borderSide: BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Apply',
                isLoading: _isCalculating,
                onPressed: () => _recalculatePrice(isApplyingCoupon: true),
                variant: AppButtonVariant.primary,
              ),
            ],
          ),
          if (_couponMessage != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _couponMessage!,
              style: AppTypography.caption.copyWith(
                color: _appliedCouponCode != null ? AppColors.primary : AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    final subtotal = _pricingData!['subtotal'];
    final offerDiscount = _pricingData!['offerDiscount'];
    final couponDiscount = _pricingData!['couponDiscount'];
    final finalTotal = _pricingData!['total'];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items Total', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
              Text(
                '₹${(subtotal as num).toStringAsFixed(2)}',
                style: AppTypography.body,
              ),
            ],
          ),
          if (offerDiscount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Offer Discounts', style: AppTypography.body.copyWith(color: AppColors.success)),
                Text(
                  '-₹${(offerDiscount as num).toStringAsFixed(2)}',
                  style: AppTypography.body.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          if (couponDiscount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coupon Discount', style: AppTypography.body.copyWith(color: AppColors.success)),
                Text(
                  '-₹${(couponDiscount as num).toStringAsFixed(2)}',
                  style: AppTypography.body.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
          if ((_pricingData!['deliveryFee'] ?? 0) > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delivery Fee', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                Text(
                  '₹${((_pricingData!['deliveryFee']) as num).toStringAsFixed(2)}',
                  style: AppTypography.body,
                ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Divider(color: AppColors.border.withValues(alpha: 0.5)),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Final Amount', style: AppTypography.headline),
              Text(
                '₹${(finalTotal as num).toStringAsFixed(2)}',
                style: AppTypography.headline.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 16),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Payment is collected at the store.',
                    style: AppTypography.label.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
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
            border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.storefront, color: AppColors.primary),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deal.store.name, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
                    if (deal.store.address != null)
                      Text(
                        deal.store.address!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.4,
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
          Icons.timer_outlined,
          'Hold Time: Reserved items are typically held for a limited time.',
        ),
        _buildRuleItem(
          Icons.cancel_outlined,
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

  Widget _buildStickyCTA(DealDetail deal) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: AppButton(
            label: _isSubmitting ? 'Confirming...' : 'Confirm Reservation',
            variant: AppButtonVariant.primary,
            isLoading: _isSubmitting,
            onPressed: () => _submitReservation(deal),
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0, duration: AppAnimations.medium, curve: Curves.easeOutCubic);
  }
}
