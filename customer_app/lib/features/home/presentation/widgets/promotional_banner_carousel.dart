import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/chips_badges/discount_badge.dart';
import '../providers/home_providers.dart';

class PromotionalBannerCarousel extends ConsumerStatefulWidget {
  const PromotionalBannerCarousel({super.key});

  @override
  ConsumerState<PromotionalBannerCarousel> createState() =>
      _PromotionalBannerCarouselState();
}

class _PromotionalBannerCarouselState
    extends ConsumerState<PromotionalBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isUserInteracting = false;
  int _bannerCount = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!_isUserInteracting && _bannerCount > 1 && _pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _bannerCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannersAsync = ref.watch(promotionalBannersProvider);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) return const SizedBox.shrink();
        
        _bannerCount = banners.length;

        return Column(
          children: [
            SizedBox(
              height: 200,
              child: GestureDetector(
                onPanDown: (_) => _isUserInteracting = true,
                onPanCancel: () => _isUserInteracting = false,
                onPanEnd: (_) => _isUserInteracting = false,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final deal = banners[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: GestureDetector(
                        onTap: () => context.push('/offer/${deal.id}'),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                if (deal.imageUrl != null)
                                  AppNetworkImage(
                                    imageUrl: deal.imageUrl!,
                                    fit: BoxFit.cover,
                                    borderRadius: AppRadius.lg,
                                  )
                                else
                                  Container(color: AppColors.surfaceVariant),

                                // Gradient overlay
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.1),
                                        Colors.black.withValues(alpha: 0.7),
                                      ],
                                    ),
                                  ),
                                ),

                                Positioned(
                                  top: AppSpacing.md,
                                  right: AppSpacing.md,
                                  child: DiscountBadge(
                                    discountPercent: deal.discountPercent,
                                  ),
                                ),

                                Positioned(
                                  bottom: AppSpacing.md,
                                  left: AppSpacing.md,
                                  right: AppSpacing.md,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deal.productName,
                                        style: AppTypography.title.copyWith(color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            deal.storeName,
                                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '₹${deal.discountedPrice.toStringAsFixed(2)}',
                                            style: AppTypography.title.copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            if (banners.length > 1) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  banners.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? AppColors.primary
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ]
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: AppSkeleton(
          width: double.infinity,
          height: 200,
          borderRadius: AppRadius.lg,
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
