import 'package:flutter/material.dart';
import '../../core/widgets/buttons/app_button.dart';
import '../../core/widgets/buttons/app_icon_button.dart';
import '../../core/widgets/inputs/app_text_field.dart';
import '../../core/widgets/inputs/search_field.dart';
import '../../core/widgets/chips_badges/app_chip.dart';
import '../../core/widgets/chips_badges/app_badge.dart';
import '../../core/widgets/chips_badges/discount_badge.dart';
import '../../core/widgets/chips_badges/expiry_badge.dart';
import '../../core/widgets/chips_badges/distance_badge.dart';
import '../../core/widgets/layout/app_card.dart';
import '../../core/widgets/layout/app_dialog.dart';
import '../../core/widgets/layout/app_bottom_sheet.dart';
import '../../core/widgets/feedback/app_snackbar.dart';
import '../../core/widgets/feedback/app_skeleton.dart';
import '../../core/widgets/feedback/empty_state.dart';
import '../../core/widgets/domain/store_card.dart';
import '../../core/widgets/domain/offer_card.dart';
import '../../core/widgets/domain/stock_indicator.dart';
import '../../core/widgets/motion/perspective_card.dart';
import '../../app/theme/app_typography.dart';
import '../../app/theme/app_spacing.dart';

class DesignSystemShowcase extends StatelessWidget {
  const DesignSystemShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System Showcase')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _Section('Buttons', child: _buildButtons()),
          _Section('Inputs', child: _buildInputs()),
          _Section('Chips & Badges', child: _buildChipsAndBadges()),
          _Section('Cards & Feedback', child: _buildCards(context)),
          _Section('Domain Components (Offers)', child: _buildDomainCards()),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        AppButton.primary(label: 'Primary Button', onPressed: () {}),
        AppButton.secondary(label: 'Secondary Button', onPressed: () {}),
        AppButton.destructive(label: 'Destructive', onPressed: () {}),
        AppButton.primary(
          label: 'Loading...',
          isLoading: true,
          onPressed: () {},
        ),
        AppButton.primary(label: 'Disabled'),
        AppIconButton(icon: Icons.favorite_outline, onPressed: () {}),
        AppIconButton(
          icon: Icons.share_outlined,
          isGlass: true,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildInputs() {
    return Column(
      children: [
        AppTextField(
          hintText: 'Standard input',
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        const SizedBox(height: AppSpacing.md),
        SearchField(onChanged: (_) {}, onFilterTap: () {}),
      ],
    );
  }

  Widget _buildChipsAndBadges() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        const AppChip(label: 'Selected', isSelected: true),
        const AppChip(label: 'Unselected'),
        const AppBadge(
          label: 'Success Badge',
          variant: AppBadgeVariant.success,
        ),
        const AppBadge(
          label: 'Warning Badge',
          variant: AppBadgeVariant.warning,
        ),
        const DiscountBadge(discountPercent: 40),
        const ExpiryBadge(status: ExpiryStatus.urgent, label: 'Expires Today'),
        const DistanceBadge(distanceText: '2.4 km'),
        const StockIndicator(status: StockStatus.lowStock, remaining: 3),
      ],
    );
  }

  Widget _buildCards(BuildContext context) {
    return Column(
      children: [
        AppCard(
          variant: AppCardVariant.elevated,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Elevated Card', style: AppTypography.title),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton.secondary(
                    label: 'Dialog',
                    onPressed: () => AppDialog.showConfirmation(
                      context: context,
                      title: 'Confirm',
                      description: 'Are you sure?',
                      confirmText: 'Yes',
                    ),
                  ),
                  AppButton.secondary(
                    label: 'Snackbar',
                    onPressed: () => AppSnackbar.show(
                      context,
                      message: 'Saved successfully!',
                      variant: SnackbarVariant.success,
                    ),
                  ),
                  AppButton.secondary(
                    label: 'Sheet',
                    onPressed: () => AppBottomSheet.show(
                      context: context,
                      child: const Padding(
                        padding: EdgeInsets.all(AppSpacing.xl),
                        child: Text('Bottom Sheet Content'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const AppSkeleton(width: double.infinity, height: 100),
        const SizedBox(height: AppSpacing.lg),
        const EmptyState(
          title: 'No Data',
          description: 'This is what an empty state looks like.',
          icon: Icons.inbox_outlined,
        ),
      ],
    );
  }

  Widget _buildDomainCards() {
    return Column(
      children: [
        StoreCard(
          storeName: 'Green Grocers',
          distance: '1.2 km',
          rating: 4.8,
          onTap: () {},
        ),
        const SizedBox(height: AppSpacing.lg),
        PerspectiveCard(
          child: OfferCard(
            productName: 'Organic Avocados',
            storeName: 'Green Grocers',
            originalPrice: 150.0,
            discountedPrice: 90.0,
            discountPercent: 40.0,
            expiryStatus: ExpiryStatus.urgent,
            stockStatus: StockStatus.lowStock,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  const _Section(this.title, {required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headline),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}
