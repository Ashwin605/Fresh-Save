import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/home_header.dart';
import '../widgets/search_entry_bar.dart';
import '../widgets/categories_section.dart';
import '../widgets/promotional_banner_carousel.dart';
import '../widgets/product_catalogue_section.dart';
import '../widgets/nearby_stores_section.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () async {
          ref.invalidate(categoriesProvider);
          ref.invalidate(promotionalBannersProvider);
          ref.invalidate(nearbyStoresProvider);
          ref.invalidate(nearbyDealsProvider); // Used for catalogue
          // Wait for critical providers
          try {
            await Future.wait([
              ref.read(promotionalBannersProvider.future),
              ref.read(nearbyStoresProvider.future),
            ]);
          } catch (_) {}
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            const HomeHeader(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.md),
                  const SearchEntryBar(),
                  const SizedBox(height: AppSpacing.lg),
                  const CategoriesSection(),
                  const SizedBox(height: AppSpacing.lg),
                  const PromotionalBannerCarousel(),
                  const SizedBox(height: AppSpacing.xl),
                  const NearbyStoresSection(),
                  const SizedBox(height: AppSpacing.xl),
                  const ProductCatalogueSection(),
                  const SizedBox(height: 100), // Bottom padding for shell navigation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
