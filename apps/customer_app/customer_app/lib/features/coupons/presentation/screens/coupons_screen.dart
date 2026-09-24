import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/network/result.dart';
import '../data/repositories/coupon_repository.dart';
import '../domain/models/coupon.dart';
import 'package:intl/intl.dart';

class CouponsScreen extends ConsumerStatefulWidget {
  const CouponsScreen({super.key});

  @override
  ConsumerState<CouponsScreen> createState() => _CouponsScreenState();
}

class _CouponsScreenState extends ConsumerState<CouponsScreen> {
  List<Coupon> _coupons = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCoupons();
  }

  Future<void> _fetchCoupons() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    final repo = ref.read(couponRepositoryProvider);
    final result = await repo.getAvailableCoupons();

    if (!mounted) return;

    if (result is Success<List<Coupon>>) {
      setState(() {
        _coupons = result.data;
        _isLoading = false;
      });
    } else if (result is Failure<List<Coupon>>) {
      setState(() {
        _errorMessage = result.error.message;
        _isLoading = false;
      });
    }
  }

  void _showCouponDetails(Coupon coupon) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Coupon Code:', style: AppTypography.caption),
              Text(coupon.code, style: AppTypography.headline),
              const SizedBox(height: AppSpacing.md),
              Text(coupon.title, style: AppTypography.title.copyWith(color: AppColors.primary)),
              if (coupon.description != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(coupon.description!, style: AppTypography.body),
              ],
              const SizedBox(height: AppSpacing.lg),
              if (coupon.minimumOrderAmount != null)
                Text('Minimum order: ₹${coupon.minimumOrderAmount!.toStringAsFixed(0)}', style: AppTypography.body),
              if (coupon.maximumDiscountAmount != null)
                Text('Maximum discount: ₹${coupon.maximumDiscountAmount!.toStringAsFixed(0)}', style: AppTypography.body),
              Text('Valid until: ${DateFormat.yMMMd().format(coupon.expiryDate)}', style: AppTypography.body),
              const SizedBox(height: AppSpacing.lg),
              Text('Terms & Conditions:', style: AppTypography.subtitle),
              const SizedBox(height: AppSpacing.xs),
              Text('• Valid on eligible orders.\n• One use per customer (if restricted).\n• Cannot be combined with incompatible promotions.', style: AppTypography.caption),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: 'Close',
                variant: AppButtonVariant.secondary,
                onPressed: () => context.pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Offers & Coupons', style: AppTypography.title),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!, style: AppTypography.body.copyWith(color: AppColors.error)))
              : _coupons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🎟️', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: AppSpacing.md),
                          Text('No coupons available right now.', style: AppTypography.subtitle),
                          const SizedBox(height: AppSpacing.xs),
                          Text('Check back later for new offers.', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: _coupons.length,
                      separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final coupon = _coupons[index];
                        return InkWell(
                          onTap: () => _showCouponDetails(coupon),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('🎟 ${coupon.code}', style: AppTypography.subtitle.copyWith(fontWeight: FontWeight.bold)),
                                    if (coupon.shop != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryLight.withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(AppRadius.sm),
                                        ),
                                        child: Text(coupon.shop!.name, style: AppTypography.caption.copyWith(color: AppColors.primary)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(coupon.title, style: AppTypography.title.copyWith(color: AppColors.primary)),
                                if (coupon.minimumOrderAmount != null) ...[
                                  const SizedBox(height: AppSpacing.xs),
                                  Text('Minimum order ₹${coupon.minimumOrderAmount!.toStringAsFixed(0)}', style: AppTypography.caption),
                                ],
                                const SizedBox(height: AppSpacing.xs),
                                Text('Valid until ${DateFormat.MMMd().format(coupon.expiryDate)}', style: AppTypography.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
