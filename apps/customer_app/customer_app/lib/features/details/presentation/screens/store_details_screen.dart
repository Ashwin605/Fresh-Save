import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/feedback/empty_state_view.dart';
import '../../../../core/widgets/chips_badges/distance_badge.dart';
import '../../../../core/widgets/domain/offer_card.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../../domain/models/store_details_models.dart';
import '../../domain/models/details_models.dart';
import '../../data/repositories/store_details_repository_impl.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../../location/domain/models/location_models.dart';
import '../../../../core/network/result.dart';
import '../../../home/domain/models/home_models.dart';
import '../../domain/models/rating_models.dart';
import '../../data/repositories/shop_ratings_repository.dart';
import '../../../home/presentation/widgets/coupons_section.dart';

class StoreDetailsScreen extends ConsumerStatefulWidget {
  final String storeId;

  const StoreDetailsScreen({super.key, required this.storeId});

  @override
  ConsumerState<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends ConsumerState<StoreDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  StoreProfileState _state = const StoreProfileState(
    status: StoreDetailsStatus.loading,
  );
  int _lastRequestId = 0;
  static const int _limit = 20;

  ShopRatingSummary? _ratingSummary;
  List<ShopRating> _recentReviews = [];
  bool _isLoadingRatings = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    Future.microtask(() {
      _fetchPage(1);
      _fetchRatings();
    });
  }

  Future<void> _fetchRatings() async {
    final repo = ref.read(shopRatingsRepositoryProvider);
    final summaryResult = await repo.getRatingSummary(widget.storeId);
    final reviewsResult = await repo.getRatings(widget.storeId, page: 1, limit: 3);

    if (mounted) {
      setState(() {
        _isLoadingRatings = false;
        if (summaryResult is Success<ShopRatingSummary>) {
          _ratingSummary = summaryResult.data;
        }
        if (reviewsResult is Success<List<ShopRating>>) {
          _recentReviews = reviewsResult.data;
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (_state.status != StoreDetailsStatus.loading &&
          _state.status != StoreDetailsStatus.loadingMore &&
          _state.hasMore) {
        setState(() {
          _state = _state.copyWith(status: StoreDetailsStatus.loadingMore);
        });
        _fetchPage(_state.currentPage + 1);
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _state = _state.copyWith(currentPage: 1, hasMore: true);
      _isLoadingRatings = true;
    });
    await Future.wait([
      _fetchPage(1),
      _fetchRatings(),
    ]);
  }

  Future<void> _fetchPage(int page) async {
    final locationState = ref.read(locationProvider);
    final lat = locationState.status == LocationStatus.available
        ? locationState.location?.latitude
        : null;
    final lng = locationState.status == LocationStatus.available
        ? locationState.location?.longitude
        : null;

    final requestId = ++_lastRequestId;
    final repo = ref.read(storeDetailsRepositoryProvider);

    final result = await repo.getStoreDeals(
      widget.storeId,
      page: page,
      limit: _limit,
      lat: lat,
      lng: lng,
    );

    if (requestId != _lastRequestId || !mounted) return;

    if (result is Success<List<Deal>>) {
      final newOffers = result.data;
      final hasMore = newOffers.length == _limit;

      DealStore? extractedStore = _state.storeMetadata;
      DealDistance? extractedDistance = _state.storeDistance;

      if (extractedStore == null && newOffers.isNotEmpty) {
        final firstDeal = newOffers.first;
        extractedStore = DealStore(
          id: firstDeal.storeId,
          name: firstDeal.storeName,
          logo: firstDeal.storeLogo,
          address: firstDeal.storeAddress,
          city: firstDeal.storeCity,
        );
        extractedDistance = firstDeal.distance != null
            ? DealDistance(value: firstDeal.distance!, unit: 'km')
            : null;
      }

      setState(() {
        _state = _state.copyWith(
          offers: page == 1 ? newOffers : [..._state.offers, ...newOffers],
          storeMetadata: extractedStore,
          storeDistance: extractedDistance,
          currentPage: page,
          hasMore: hasMore,
          status: StoreDetailsStatus.loaded,
          errorMessage: null,
        );
      });
    } else if (result is Failure<List<Deal>>) {
      setState(() {
        _state = _state.copyWith(
          status: StoreDetailsStatus.error,
          errorMessage: result.error.message,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColors.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            _buildSliverAppBar(context, _state.storeMetadata),
            if (_state.status == StoreDetailsStatus.loading &&
                _state.storeMetadata == null)
              const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_state.status == StoreDetailsStatus.error &&
                _state.storeMetadata == null)
              SliverFillRemaining(
                child: AppErrorView(
                  message: _state.errorMessage ?? 'Failed to load store',
                  onRetry: _refresh,
                ),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStoreIdentity(
                        _state.storeMetadata,
                        _state.storeDistance,
                      ).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: AppSpacing.lg),
                      if (_isLoadingRatings)
                        AppSkeleton(width: 150, height: 24, borderRadius: AppRadius.sm)
                      else if (_ratingSummary != null && _ratingSummary!.totalRatings > 0)
                        _buildRatingSummary(),
                      const SizedBox(height: AppSpacing.xxl),
                      if (!_isLoadingRatings && _recentReviews.isNotEmpty) ...[
                        _buildReviewsSection(),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                      const CouponsSection(),
                      const SizedBox(height: AppSpacing.xxl),
                      Text('Offers', style: AppTypography.title).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.2, end: 0),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ),
              if (_state.offers.isEmpty &&
                  _state.status == StoreDetailsStatus.loaded)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                    child: EmptyStateView(
                      icon: Icons.local_offer_outlined,
                      title: 'No deals right now',
                      description: 'This store hasn\'t posted any fresh deals currently.',
                    ),
                  ).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.1, end: 0),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _state.offers.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.md,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: OfferCard(
                            productName: _state.offers[index].productName,
                            storeName: _state.offers[index].storeName,
                            originalPrice: _state.offers[index].originalPrice,
                            discountedPrice:
                                _state.offers[index].discountedPrice,
                            discountPercent:
                                _state.offers[index].discountPercent,
                            expiryStatus: _state.offers[index].expiryStatus,
                            stockStatus: _state.offers[index].stockStatus,
                            imageUrl: _state.offers[index].imageUrl,
                            distance: _state.offers[index].distance != null
                                ? '${_state.offers[index].distance!.toStringAsFixed(1)} km'
                                : null,
                            onTap: () => context.push(
                              '/offer/${_state.offers[index].id}',
                            ),
                          ),
                        ).animate().fade(
                          duration: AppAnimations.medium,
                          delay: Duration(milliseconds: (index % 10) * 50),
                        ).slideY(begin: 0.1, end: 0);
                      },
                      childCount:
                          _state.offers.length +
                          (_state.status == StoreDetailsStatus.loadingMore
                              ? 1
                              : 0),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, DealStore? store) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.surface,
      leadingWidth: 64,
      leading: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 16.0),
          width: 40,
          height: 40,
          child: InteractiveContainer(
            onTap: () => context.pop(),
            scaleDown: 0.9,
            child: const GlassSurface(
              borderRadius: 20.0,
              padding: EdgeInsets.zero,
              child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
            ),
          ),
        ),
      ),
      actions: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 40,
            height: 40,
            child: InteractiveContainer(
              onTap: () {}, // Future step: Share
              scaleDown: 0.9,
              child: const GlassSurface(
                borderRadius: 20.0,
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.share_outlined,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            store != null && store.logo != null
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(store.logo!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.storefront,
                      size: 64,
                      color: AppColors.textDisabled,
                    ),
                  ),
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 120,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background.withValues(alpha: 0.0),
                      AppColors.background,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreIdentity(DealStore? store, DealDistance? distance) {
    if (store == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeleton(width: 200, height: 32, borderRadius: AppRadius.sm),
          SizedBox(height: AppSpacing.sm),
          AppSkeleton(width: 120, height: 16, borderRadius: AppRadius.sm),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(store.name, style: AppTypography.headline)),
            if (distance != null)
              DistanceBadge(
                distanceText:
                    '${distance.value.toStringAsFixed(1)} ${distance.unit}',
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Text(
                store.address ?? store.city ?? 'Address unavailable',
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.amber, size: 24),
        const SizedBox(width: AppSpacing.xs),
        Text('${_ratingSummary!.averageRating}', style: AppTypography.headline.copyWith(fontSize: 20)),
        const SizedBox(width: AppSpacing.sm),
        Text('(${_ratingSummary!.totalRatings} ratings)', style: AppTypography.body.copyWith(color: AppColors.textSecondary)),
      ],
    ).animate().fade(duration: AppAnimations.medium);
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Customer Reviews', style: AppTypography.title),
        const SizedBox(height: AppSpacing.md),
        ..._recentReviews.take(2).map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < review.rating ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                  if (review.review != null && review.review!.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '"${review.review}"',
                      style: AppTypography.body.copyWith(fontStyle: FontStyle.italic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
        Center(
          child: TextButton(
            onPressed: () {
              // Note: using go_router, requires route setup or push
              import('store_reviews_screen.dart').then((m) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => m.StoreReviewsScreen(storeId: widget.storeId),
                ));
              });
            },
            child: Text('View all reviews', style: AppTypography.button.copyWith(color: AppColors.primary)),
          ),
        ),
      ],
    ).animate().fade(duration: AppAnimations.medium);
  }
}
