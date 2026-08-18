import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/feedback/empty_state_view.dart';
import '../../../../core/widgets/domain/product_card.dart';
import '../providers/category_products_provider.dart';

class CategoryDiscoveryScreen extends ConsumerStatefulWidget {
  final String categoryId;

  const CategoryDiscoveryScreen({super.key, required this.categoryId});

  @override
  ConsumerState<CategoryDiscoveryScreen> createState() =>
      _CategoryDiscoveryScreenState();
}

class _CategoryDiscoveryScreenState
    extends ConsumerState<CategoryDiscoveryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    print('[1] CATEGORY TAPPED');
    print('category name: Unknown');
    print('category ID: ${widget.categoryId}');
    print('[2] NAVIGATION');
    print('destination: CategoryDiscoveryScreen');
    print('arguments: {categoryId: ${widget.categoryId}}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryProductsProvider.notifier).fetchInitial(widget.categoryId);
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(categoryProductsProvider.notifier).loadMore(widget.categoryId);
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(categoryProductsProvider.notifier).refresh(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(categoryProductsProvider);
    final notifier = ref.read(categoryProductsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Products', style: AppTypography.title),
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: _onRefresh,
        child: _buildBody(state, notifier),
      ),
    );
  }

  Widget _buildBody(CategoryProductsState state, CategoryProductsNotifier notifier) {
    if (state.isLoading && state.products.isEmpty) {
      return GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.7,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => const AppSkeleton(
          width: double.infinity,
          height: 240,
          borderRadius: 16,
        ),
      );
    }

    if (state.errorMessage != null && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.sm),
            Text('Couldn\'t load products.', style: AppTypography.title),
            const SizedBox(height: 4),
            Text(
              state.errorMessage!,
              style: AppTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Retry',
              onPressed: () => notifier.fetchInitial(widget.categoryId),
            ),
          ],
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Filter / Sort Bar
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                _buildFilterChip('Sort', Icons.sort),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Price', Icons.attach_money),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Offers', Icons.local_offer_outlined),
              ],
            ),
          ),
        ),
        
        if (state.products.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyStateView(
              icon: Icons.category_outlined,
              title: 'No products available',
              description: 'There aren\'t any products in this category nearby yet.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.md,
                crossAxisSpacing: AppSpacing.md,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = state.products[index];
                  return ProductCard(
                    id: product.id,
                    name: product.name,
                    brand: product.brand,
                    imageUrl: product.image,
                    onTap: () => context.push('/product/${product.id}'),
                  );
                },
                childCount: state.products.length,
              ),
            ),
          ),
          
        if (state.isPaginating)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.textPrimary),
          const SizedBox(width: 4),
          Text(label, style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
