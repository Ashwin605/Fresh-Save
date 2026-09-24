import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../coupons/presentation/providers/coupon_providers.dart';
import '../../../coupons/presentation/screens/coupons_screen.dart';

class CouponsSection extends ConsumerWidget {
  const CouponsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final couponsAsync = ref.watch(availableCouponsProvider);

    return couponsAsync.when(
      data: (coupons) {
        if (coupons.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('🎟️ Available Coupons', style: AppTypography.title),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CouponsScreen()));
                    },
                    child: Text('View All', style: AppTypography.label.copyWith(color: AppColors.primary)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 120,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                scrollDirection: Axis.horizontal,
                itemCount: coupons.length > 3 ? 3 : coupons.length,
                separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final coupon = coupons[index];
                  return Container(
                    width: 240,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(coupon.code, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                            if (coupon.shop != null)
                              Text(coupon.shop!.name, style: AppTypography.caption),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(coupon.title, style: AppTypography.body, maxLines: 1, overflow: TextOverflow.ellipsis),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            // Copy to clipboard or show details
                          },
                          child: Text('Tap for details', style: AppTypography.caption.copyWith(color: AppColors.primary)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
