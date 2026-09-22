import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../domain/models/owner_offer_models.dart';
import '../providers/owner_offer_detail_provider.dart';
import '../../data/repositories/owner_offer_repository_provider.dart';

class OwnerOfferDetailScreen extends ConsumerStatefulWidget {
  final String offerId;

  const OwnerOfferDetailScreen({super.key, required this.offerId});

  @override
  ConsumerState<OwnerOfferDetailScreen> createState() =>
      _OwnerOfferDetailScreenState();
}

class _OwnerOfferDetailScreenState
    extends ConsumerState<OwnerOfferDetailScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final offerState = ref.watch(ownerOfferDetailProvider(widget.offerId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Offer Details', style: AppTypography.title),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.textPrimary),
            onPressed: () {
              // TODO: Push edit screen
            },
          ),
        ],
      ),
      body: offerState.when(
        data: (offer) => _buildContent(offer),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }

  Widget _buildContent(OwnerOffer offer) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
    );
    final dateFormatter = DateFormat('MMM d, y, h:mm a');

    return RefreshIndicator(
      onRefresh: () async =>
          ref.invalidate(ownerOfferDetailProvider(widget.offerId)),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          offer.title ??
                              offer.inventory?.product.name ??
                              'Offer',
                          style: AppTypography.headline,
                        ),
                      ),
                      _buildStatusBadge(offer.status),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (offer.description != null &&
                      offer.description!.isNotEmpty) ...[
                    Text(
                      offer.description!,
                      style: AppTypography.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  const Divider(),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _buildInfoColumn(
                        'Offer Price',
                        currencyFormatter.format(offer.discountedPrice),
                        isPrimary: true,
                      ),
                      _buildInfoColumn(
                        'Original',
                        currencyFormatter.format(offer.originalPriceSnapshot),
                        isStrikethrough: true,
                      ),
                      _buildInfoColumn(
                        'Available',
                        '${offer.inventory?.stockQuantity ?? 0} units',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Availability', style: AppTypography.title),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    'Starts At',
                    dateFormatter.format(offer.startsAt.toLocal()),
                  ),
                  const Divider(),
                  _buildDetailRow(
                    'Ends At',
                    dateFormatter.format(offer.endsAt.toLocal()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _buildActions(offer),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
    String label,
    String value, {
    bool isPrimary = false,
    bool isStrikethrough = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.label.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.title.copyWith(
              color: isPrimary ? AppColors.primary : AppColors.textPrimary,
              decoration: isStrikethrough ? TextDecoration.lineThrough : null,
              fontSize: isPrimary ? 20 : 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OfferStatus status) {
    Color color;
    String text;
    switch (status) {
      case OfferStatus.active:
        color = AppColors.success;
        text = 'Active';
        break;
      case OfferStatus.scheduled:
        color = AppColors.info;
        text = 'Scheduled';
        break;
      case OfferStatus.paused:
        color = AppColors.warning;
        text = 'Paused';
        break;
      case OfferStatus.soldOut:
        color = AppColors.textSecondary;
        text = 'Sold Out';
        break;
      case OfferStatus.expired:
        color = AppColors.error;
        text = 'Expired';
        break;
      case OfferStatus.cancelled:
        color = AppColors.error;
        text = 'Cancelled';
        break;
      case OfferStatus.draft:
        color = AppColors.textSecondary;
        text = 'Draft';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: AppTypography.label.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActions(OwnerOffer offer) {
    if (offer.status == OfferStatus.expired ||
        offer.status == OfferStatus.cancelled ||
        offer.status == OfferStatus.soldOut) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        if (offer.status == OfferStatus.paused)
          AppButton(
            label: 'Resume Offer',
            isLoading: _isProcessing,
            onPressed: () => _updateStatus('activate'),
          )
        else if (offer.status == OfferStatus.active ||
            offer.status == OfferStatus.scheduled)
          AppButton.secondary(
            label: 'Pause Offer',
            isLoading: _isProcessing,
            onPressed: () => _updateStatus('pause'),
          ),
        const SizedBox(height: AppSpacing.md),
        AppButton.destructive(
          label: 'Cancel Offer',
          isLoading: _isProcessing,
          onPressed: () => _showCancelConfirmation(),
        ),
      ],
    );
  }

  Future<void> _updateStatus(String action) async {
    setState(() => _isProcessing = true);
    final repo = ref.read(ownerOfferRepositoryProvider);
    try {
      if (action == 'activate') await repo.activateOffer(widget.offerId);
      if (action == 'pause') await repo.pauseOffer(widget.offerId);
      if (action == 'cancel') await repo.cancelOffer(widget.offerId);
      ref.invalidate(ownerOfferDetailProvider(widget.offerId));
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Offer?'),
        content: const Text(
          'This will permanently cancel the offer. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              _updateStatus('cancel');
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
