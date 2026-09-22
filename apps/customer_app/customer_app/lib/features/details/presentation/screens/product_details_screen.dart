import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/glass_surface.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../providers/details_providers.dart';
import '../../domain/models/details_models.dart';

class ProductDetailsScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailsProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => AppErrorView(
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.invalidate(productDetailsProvider(productId)),
        ),
        data: (product) => _buildContent(context, product),
      ),
      bottomNavigationBar: productAsync.hasValue
          ? _buildStickyCTA(context, productAsync.value!)
          : null,
    );
  }

  Widget _buildContent(BuildContext context, ProductDetail product) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        _buildSliverAppBar(context, product),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(product).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.xl),
                if (product.description != null) ...[
                  _buildDescriptionSection(product).animate().fade(duration: AppAnimations.medium, delay: 100.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xxl * 2),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ProductDetail product) {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InteractiveContainer(
          onTap: () => context.pop(),
          scaleDown: 0.9,
          child: const GlassSurface(
            borderRadius: 100.0,
            child: Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            product.image != null
                ? AppNetworkImage(imageUrl: product.image!, fit: BoxFit.cover)
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.fastfood,
                      size: 64,
                      color: AppColors.textDisabled,
                    ),
                  ),
            // Bottom gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 100,
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

  Widget _buildHeader(ProductDetail product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.brand != null)
          Text(
            product.brand!.toUpperCase(),
            style: AppTypography.label.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(product.name, style: AppTypography.headline),
        if (product.category != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              product.category!.name,
              style: AppTypography.label.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDescriptionSection(ProductDetail product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About this product', style: AppTypography.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          product.description!,
          style: AppTypography.body.copyWith(
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyCTA(BuildContext context, ProductDetail product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.9),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: AppButton(
            label: 'Find Nearby Deals',
            variant: AppButtonVariant.primary,
            onPressed: () {
              // Future: Route to search with this product as a filter
              context.push('/search');
            },
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0, duration: AppAnimations.medium, curve: Curves.easeOutCubic);
  }
}
