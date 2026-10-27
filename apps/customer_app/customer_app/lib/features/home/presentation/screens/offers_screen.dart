import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/domain/offer_card.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../providers/home_providers.dart';
import '../../../coupons/presentation/providers/coupon_providers.dart';
import '../../../coupons/domain/models/coupon.dart';

enum OffersViewTab { deals, coupons }

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen> {
  OffersViewTab _activeTab = OffersViewTab.deals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 2,
        title: Text('Offers & Deals', style: AppTypography.title),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(nearbyDealsProvider);
          ref.invalidate(availableCouponsProvider);
          try {
            await Future.wait([
              ref.read(nearbyDealsProvider.future),
              ref.read(availableCouponsProvider.future),
            ]);
          } catch (_) {}
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // Segmented Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.md,
                  AppSpacing.sm,
                ),
                child: SegmentedButton<OffersViewTab>(
                  segments: const [
                    ButtonSegment(
                      value: OffersViewTab.deals,
                      icon: Icon(Icons.local_offer_rounded),
                      label: Text('Product Deals'),
                    ),
                    ButtonSegment(
                      value: OffersViewTab.coupons,
                      icon: Icon(Icons.confirmation_number_outlined),
                      label: Text('Coupons & Vouchers'),
                    ),
                  ],
                  selected: {_activeTab},
                  onSelectionChanged: (Set<OffersViewTab> selection) {
                    setState(() {
                      _activeTab = selection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.primary;
                      }
                      return AppColors.surface;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return AppColors.textPrimary;
                    }),
                  ),
                ),
              ),
            ),

            if (_activeTab == OffersViewTab.deals)
              _buildDealsSection()
            else
              _buildCouponsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDealsSection() {
    final dealsAsync = ref.watch(nearbyDealsProvider);

    return dealsAsync.when(
      data: (deals) {
        if (deals.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_offer_outlined,
                      size: 64,
                      color: AppColors.textDisabled.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No active deals right now',
                      style: AppTypography.title.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Stores nearby haven\'t posted any discount deals today. Check back soon!',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          sliver: SliverList.separated(
            itemCount: deals.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final deal = deals[index];
              return OfferCard(
                productName: deal.productName,
                storeName: deal.storeName,
                originalPrice: deal.originalPrice,
                discountedPrice: deal.discountedPrice,
                discountPercent: deal.discountPercent,
                expiryStatus: deal.expiryStatus,
                stockStatus: deal.stockStatus,
                imageUrl: deal.imageUrl,
                distance: deal.distance != null
                    ? '${deal.distance!.toStringAsFixed(1)} km'
                    : null,
                onTap: () => context.push('/offer/${deal.id}'),
              ).animate().fade(
                duration: AppAnimations.medium,
                delay: Duration(milliseconds: (index % 8) * 40),
              ).slideY(begin: 0.08, end: 0);
            },
          ),
        );
      },
      loading: () => SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverList.separated(
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, _) => const AppSkeleton(
            width: double.infinity,
            height: 120,
            borderRadius: 16,
          ),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text('Failed to load deals', style: AppTypography.title),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: () => ref.invalidate(nearbyDealsProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponsSection() {
    final couponsAsync = ref.watch(availableCouponsProvider);

    return couponsAsync.when(
      data: (coupons) {
        if (coupons.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_number_outlined,
                      size: 64,
                      color: AppColors.textDisabled.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No coupons available right now',
                      style: AppTypography.title.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Check back soon for seasonal promotional codes and vouchers.',
                      style: AppTypography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.xxl,
          ),
          sliver: SliverList.separated(
            itemCount: coupons.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return _CouponCard(
                coupon: coupon,
                onCopy: () {
                  Clipboard.setData(ClipboardData(text: coupon.code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Coupon code "${coupon.code}" copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                onViewDetails: () => _showCouponModal(context, coupon),
              ).animate().fade(
                duration: AppAnimations.medium,
                delay: Duration(milliseconds: (index % 8) * 40),
              ).slideY(begin: 0.08, end: 0);
            },
          ),
        );
      },
      loading: () => SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.md),
        sliver: SliverList.separated(
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (_, _) => const AppSkeleton(
            width: double.infinity,
            height: 140,
            borderRadius: 16,
          ),
        ),
      ),
      error: (error, _) => SliverFillRemaining(
        hasScrollBody: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text('Failed to load coupons', style: AppTypography.title),
              const SizedBox(height: AppSpacing.sm),
              FilledButton.icon(
                onPressed: () => ref.invalidate(availableCouponsProvider),
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCouponModal(BuildContext context, Coupon coupon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(ctx).padding.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Coupon Code', style: AppTypography.caption),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: coupon.code));
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied "${coupon.code}"!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.copy, size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text('Copy Code', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(coupon.code, style: AppTypography.headline.copyWith(color: AppColors.primary)),
              const SizedBox(height: AppSpacing.md),
              Text(coupon.title, style: AppTypography.title),
              if (coupon.description != null && coupon.description!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(coupon.description!, style: AppTypography.bodySmall),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (coupon.minimumOrderAmount != null)
                Text('• Minimum order: ₹${coupon.minimumOrderAmount!.toStringAsFixed(0)}', style: AppTypography.bodySmall),
              if (coupon.maximumDiscountAmount != null)
                Text('• Maximum discount: ₹${coupon.maximumDiscountAmount!.toStringAsFixed(0)}', style: AppTypography.bodySmall),
              Text('• Valid until: ${DateFormat.yMMMd().format(coupon.expiryDate)}', style: AppTypography.bodySmall),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Close',
                variant: AppButtonVariant.secondary,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CouponCard extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onCopy;
  final VoidCallback onViewDetails;

  const _CouponCard({
    required this.coupon,
    required this.onCopy,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Icon(
                    Icons.percent_rounded,
                    color: Color(0xFF15803D),
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.title,
                        style: AppTypography.title.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (coupon.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          coupon.description!,
                          style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        'Expires ${DateFormat.yMMMd().format(coupon.expiryDate)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Dashed divider line
          CustomPaint(
            painter: _DashedLinePainter(color: const Color(0xFFE2E8F0)),
            size: const Size(double.infinity, 1),
          ),

          // Bottom Code & Copy Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onViewDetails,
                  child: Text(
                    'Terms & conditions',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                InkWell(
                  onTap: onCopy,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          coupon.code,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.copy_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ],
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
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 5.0;
    const dashSpace = 3.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
