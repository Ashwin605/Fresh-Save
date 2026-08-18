import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/glass_surface.dart';
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
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(context, product),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(product),
                const SizedBox(height: AppSpacing.xl),
                if (product.description != null) ...[
                  _buildDescriptionSection(product),
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
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GlassSurface(
          borderRadius: 100.0,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: product.image != null
            ? AppNetworkImage(imageUrl: product.image!, fit: BoxFit.cover)
            : Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.fastfood,
                  size: 64,
                  color: AppColors.textDisabled,
                ),
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
            ),
          ),
        const SizedBox(height: AppSpacing.xs),
        Text(product.name, style: AppTypography.headline),
        if (product.category != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(product.category!.name, style: AppTypography.label),
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
          style: AppTypography.body.copyWith(height: 1.5),
        ),
      ],
    );
  }

  Widget _buildStickyCTA(BuildContext context, ProductDetail product) {
    return GlassSurface(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: AppButton(
            label: 'Find Nearby Deals',
            onPressed: () {
              // Future: Route to search with this product as a filter
              context.push('/search');
            },
          ),
        ),
      ),
    );
  }
}
