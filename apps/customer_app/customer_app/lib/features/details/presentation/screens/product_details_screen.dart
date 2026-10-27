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
import '../../domain/models/customer_product_detail.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int _quantity = 1;
  int _selectedOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(customerProductDetailsProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: detailAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => AppErrorView(
          message: error.toString().replaceAll('Exception: ', ''),
          onRetry: () => ref.invalidate(customerProductDetailsProvider(widget.productId)),
        ),
        data: (detail) => _buildContent(context, detail),
      ),
      bottomNavigationBar: detailAsync.hasValue
          ? _buildStickyCTA(context, detailAsync.value!)
          : null,
    );
  }

  Widget _buildContent(BuildContext context, CustomerProductDetail detail) {
    final product = detail.product;
    final options = detail.inventory;
    final selectedOption = (options.isNotEmpty && _selectedOptionIndex < options.length)
        ? options[_selectedOptionIndex]
        : null;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        _buildSliverAppBar(context, product.image),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(product).animate().fade(duration: AppAnimations.medium).slideY(begin: 0.2, end: 0),
                const SizedBox(height: AppSpacing.lg),

                // Pricing & Store Availability Section
                if (selectedOption != null) ...[
                  _buildPricingCard(selectedOption, options)
                      .animate()
                      .fade(duration: AppAnimations.medium, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                ] else ...[
                  _buildOutOfStockCard(product.name)
                      .animate()
                      .fade(duration: AppAnimations.medium, delay: 100.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xl),
                ],

                // Product Description
                if (product.description != null && product.description!.isNotEmpty) ...[
                  _buildDescriptionSection(product.description!)
                      .animate()
                      .fade(duration: AppAnimations.medium, delay: 200.ms)
                      .slideY(begin: 0.1, end: 0),
                  const SizedBox(height: AppSpacing.xxl * 2),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, String? imageUrl) {
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
            imageUrl != null && imageUrl.isNotEmpty
                ? AppNetworkImage(imageUrl: imageUrl, fit: BoxFit.cover)
                : Container(
                    color: AppColors.surfaceVariant,
                    child: const Icon(
                      Icons.fastfood,
                      size: 64,
                      color: AppColors.textDisabled,
                    ),
                  ),
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

  Widget _buildHeader(dynamic product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (product.brand != null && product.brand!.isNotEmpty)
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
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (product.category != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  product.category!.name,
                  style: AppTypography.label.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (product.unit != null && product.unit!.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Text(
                  product.unit!,
                  style: AppTypography.label.copyWith(
                    color: const Color(0xFF0369A1),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingCard(
    ProductInventoryOption selectedOption,
    List<ProductInventoryOption> allOptions,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Store Info
          Row(
            children: [
              const Icon(Icons.storefront_rounded, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedOption.storeName,
                      style: AppTypography.title.copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (selectedOption.storeAddress != null)
                      Text(
                        selectedOption.storeAddress!,
                        style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (selectedOption.isInStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${selectedOption.availableQuantity} in stock',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF15803D),
                    ),
                  ),
                ),
            ],
          ),
          const Divider(height: 24, color: AppColors.border),

          // Price & Discount row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '₹${selectedOption.effectivePrice.toStringAsFixed(0)}',
                        style: AppTypography.headline.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 26,
                        ),
                      ),
                      if (selectedOption.hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${selectedOption.originalPrice.toStringAsFixed(0)}',
                          style: AppTypography.bodySmall.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (selectedOption.hasDiscount)
                    Text(
                      'Save ₹${selectedOption.savingsAmount.toStringAsFixed(0)} (${selectedOption.discountPercentage.toStringAsFixed(0)}% OFF)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF16A34A),
                      ),
                    ),
                ],
              ),

              // Quantity Selector
              if (selectedOption.isInStock)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: _quantity > 1
                            ? () => setState(() => _quantity--)
                            : null,
                        visualDensity: VisualDensity.compact,
                      ),
                      Text(
                        '$_quantity',
                        style: AppTypography.title.copyWith(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: _quantity < selectedOption.availableQuantity
                            ? () => setState(() => _quantity++)
                            : null,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Store selector if multiple stores stock this item
          if (allOptions.length > 1) ...[
            const SizedBox(height: 14),
            Text(
              'Available from ${allOptions.length} stores:',
              style: AppTypography.label.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: allOptions.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  final opt = allOptions[idx];
                  final isSelected = idx == _selectedOptionIndex;
                  return ChoiceChip(
                    label: Text('${opt.storeName} (₹${opt.effectivePrice.toStringAsFixed(0)})'),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedOptionIndex = idx;
                          _quantity = 1;
                        });
                      }
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOutOfStockCard(String productName) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline_rounded, color: Color(0xFFD97706), size: 22),
              SizedBox(width: 8),
              Text(
                'Currently Out of Stock',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'This item is currently unavailable in nearby stores. You can search for alternative products or check nearby deals.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.brown.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About this product', style: AppTypography.title),
        const SizedBox(height: AppSpacing.sm),
        Text(
          description,
          style: AppTypography.body.copyWith(
            height: 1.6,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStickyCTA(BuildContext context, CustomerProductDetail detail) {
    final options = detail.inventory;
    final selectedOption = (options.isNotEmpty && _selectedOptionIndex < options.length)
        ? options[_selectedOptionIndex]
        : null;

    final canReserve = selectedOption != null && selectedOption.isInStock;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.5))),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: AppButton(
            label: canReserve
                ? 'Reserve Now • ₹${(selectedOption.effectivePrice * _quantity).toStringAsFixed(0)}'
                : 'Search Nearby Deals',
            variant: AppButtonVariant.primary,
            onPressed: () {
              if (canReserve) {
                if (selectedOption.offerId != null) {
                  context.push('/reservation/review/${selectedOption.offerId}');
                } else {
                  context.push('/search?query=${Uri.encodeComponent(detail.product.name)}');
                }
              } else {
                context.push('/search?query=${Uri.encodeComponent(detail.product.name)}');
              }
            },
          ),
        ),
      ),
    ).animate().slideY(begin: 1.0, end: 0, duration: AppAnimations.medium, curve: Curves.easeOutCubic);
  }
}
