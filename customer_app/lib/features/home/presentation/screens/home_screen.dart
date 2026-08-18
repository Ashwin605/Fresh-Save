import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../widgets/home_header.dart';
import '../widgets/search_entry_bar.dart';
import '../widgets/featured_deal_section.dart';
import '../widgets/categories_section.dart';
import '../widgets/nearby_deals_section.dart';
import '../widgets/nearby_stores_section.dart';
import '../providers/home_providers.dart';
import '../../../recommendations/presentation/widgets/ai_recommendations_section.dart';
import '../../../recommendations/presentation/providers/recommendation_provider.dart';

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
          ref.invalidate(featuredDealProvider);
          ref.invalidate(nearbyDealsProvider);
          ref.invalidate(nearbyStoresProvider);
          ref.invalidate(recommendationProvider);
          // Wait for at least one critical provider to resolve for smoother UX
          try {
            await ref.read(nearbyDealsProvider.future);
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
                  const AiRecommendationsSection(),
                  const SizedBox(height: AppSpacing.lg),
                  const FeaturedDealSection(),
                  const SizedBox(height: AppSpacing.lg),
                  const CategoriesSection(),
                  const SizedBox(height: AppSpacing.xl),
                  const NearbyDealsSection(),
                  const SizedBox(height: AppSpacing.xl),
                  const NearbyStoresSection(),
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
