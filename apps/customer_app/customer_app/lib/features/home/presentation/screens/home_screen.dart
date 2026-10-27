import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/home_header.dart';
import '../widgets/search_entry_bar.dart';
import '../widgets/main_category_cards.dart';
import '../widgets/best_deals_store_cards.dart';
import '../widgets/packaged_food_categories_grid.dart';
import '../widgets/section_header.dart';
import '../widgets/budget_price_tiles.dart';
import '../widgets/product_carousel_section.dart';
import '../widgets/stores_in_spotlight_grid.dart';
import '../widgets/featured_category_promos.dart';
import '../widgets/full_width_promo_banner.dart';
import '../widgets/promotional_banner_carousel.dart';
import '../widgets/product_catalogue_section.dart';
import '../widgets/nearby_stores_section.dart';
import '../providers/home_providers.dart';
import '../../domain/models/home_models.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final show = _scrollController.offset > 350;
      if (show != _showScrollToTop) {
        setState(() {
          _showScrollToTop = show;
        });
      }
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  List<ProductCarouselItem> _mapDealsToCarouselItems(
    List<Deal> deals,
    List<String> keywords,
  ) {
    return deals.where((d) {
      final name = d.productName.toLowerCase();
      return keywords.any((k) => name.contains(k));
    }).map((d) => ProductCarouselItem(
      id: d.id,
      name: d.productName,
      imageUrl: d.imageUrl,
      originalPrice: d.originalPrice,
      discountedPrice: d.discountedPrice,
      discountPercent: d.discountPercent,
      savingsAmount: (d.originalPrice > d.discountedPrice)
          ? (d.originalPrice - d.discountedPrice)
          : null,
    )).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dealsAsync = ref.watch(nearbyDealsProvider);
    final deals = dealsAsync.asData?.value ?? [];

    final biscuitItems = _mapDealsToCarouselItems(
      deals,
      ['biscuit', 'cookie', 'rusk', 'sweet', 'snack', 'cake'],
    );

    final personalItems = _mapDealsToCarouselItems(
      deals,
      ['soap', 'shampoo', 'body wash', 'hand wash', 'oil', 'cream', 'lotion', 'paste', 'care'],
    );

    final homeItems = _mapDealsToCarouselItems(
      deals,
      ['cleaner', 'detergent', 'floor', 'toilet', 'dish', 'wash', 'bleach', 'kitchen'],
    );

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: _showScrollToTop
          ? Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: FloatingActionButton.small(
                heroTag: 'home_scroll_to_top',
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 4,
                shape: const CircleBorder(),
                onPressed: _scrollToTop,
                tooltip: 'Return to top',
                child: const Icon(Icons.keyboard_arrow_up_rounded, size: 24),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(promotionalBannersProvider);
          ref.invalidate(nearbyStoresProvider);
          ref.invalidate(nearbyDealsProvider);
          try {
            await Future.wait([
              ref.read(promotionalBannersProvider.future),
              ref.read(nearbyStoresProvider.future),
            ]);
          } catch (_) {}
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            const HomeHeader(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  // 1. Search Bar with dynamic rotating search cues
                  const SearchEntryBar(),
                  const SizedBox(height: AppSpacing.sm),

                  // 2. Main Category Navigation (Groceries, Clothing, Food)
                  const MainCategoryCards(),
                  const SizedBox(height: AppSpacing.md),

                  // 3. Best Deals Ever!!! (Routes directly to price threshold search)
                  const BestDealsStoreCards(),
                  const SizedBox(height: AppSpacing.lg),

                  // 3. Real Category Grid from backend database
                  const PackagedFoodCategoriesGrid(),
                  const SizedBox(height: AppSpacing.lg),

                  // 4. Packet in Pocket (Budget Corner ₹29, ₹49, ₹69, ₹99)
                  const SectionHeader(
                    title: 'Packet in Pocket',
                    subtitle: 'Budget Corner',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const BudgetPriceTilesSection(),
                  const SizedBox(height: AppSpacing.lg),

                  // 5. Product Carousel 1: Biscuits and Cookies (Shown when real deals exist)
                  if (biscuitItems.isNotEmpty) ...[
                    ProductCarouselSection(
                      title: 'Biscuits and Cookies',
                      subtitle: 'Delight In Every Bite',
                      items: biscuitItems,
                      onViewAll: () => context.push('/search?query=Biscuits'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // 6. Stores In Spotlight (Real categories from database)
                  const StoresInSpotlightGrid(),
                  const SizedBox(height: AppSpacing.lg),

                  // 7. Product Carousel 2: Personal Needs (Shown when real deals exist)
                  if (personalItems.isNotEmpty) ...[
                    ProductCarouselSection(
                      title: 'Personal Needs',
                      subtitle: 'Everyday Care....Everyday Glow',
                      items: personalItems,
                      onViewAll: () => context.push('/search?query=Personal%20Care'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // 8. Featured Real Category Promos
                  const FeaturedCategoryPromos(),
                  const SizedBox(height: AppSpacing.lg),

                  // 9. Promotional Banners (Real deals from backend)
                  const PromotionalBannerCarousel(),
                  const SizedBox(height: AppSpacing.lg),

                  // 10. Product Carousel 3: Home Needs (Shown when real deals exist)
                  if (homeItems.isNotEmpty) ...[
                    ProductCarouselSection(
                      title: 'Home Needs',
                      subtitle: 'From Detergents to Cleaners',
                      items: homeItems,
                      onViewAll: () => context.push('/search?query=Home%20Needs'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],

                  // 11. Real Featured Deal / Platform Banner
                  const FullWidthPromoBanner(),
                  const SizedBox(height: AppSpacing.xl),

                  // 12. Real Nearby Stores
                  const NearbyStoresSection(),
                  const SizedBox(height: AppSpacing.xl),

                  // 13. Real Product Catalogue
                  const ProductCatalogueSection(),
                  const SizedBox(height: 80), // Padding above bottom navigation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
