import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
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
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastLinearToSlowEaseIn,
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
                  physics: const BouncingScrollPhysics(),
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
                      child: InteractiveContainer(
                        onTap: () => context.push('/offer/${deal.id}'),
                        scaleDown: 0.98,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
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
                                        Colors.black.withValues(alpha: 0.05),
                                        Colors.black.withValues(alpha: 0.8),
                                      ],
                                      stops: const [0.4, 1.0],
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
                                        style: AppTypography.title.copyWith(color: Colors.white, fontSize: 20),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(Icons.storefront_rounded, size: 14, color: Colors.white.withValues(alpha: 0.8)),
                                          const SizedBox(width: 4),
                                          Text(
                                            deal.storeName,
                                            style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                                          ),
                                          const Spacer(),
                                          Text(
                                            '₹${deal.discountedPrice.toStringAsFixed(2)}',
                                            style: AppTypography.title.copyWith(color: AppColors.primaryLight),
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
                    curve: Curves.easeOutCubic,
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
        ).animate().fade(duration: AppAnimations.medium, delay: 500.ms).slideY(begin: 0.1, end: 0);
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
