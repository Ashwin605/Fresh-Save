import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_animations.dart';
import '../../../../core/widgets/buttons/app_button.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/feedback/app_skeleton.dart';
import '../../../../core/widgets/feedback/empty_state_view.dart';
import '../../../../core/widgets/domain/product_card.dart';
import '../../../../core/widgets/layout/interactive_container.dart';
import '../providers/category_products_provider.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../home/domain/models/home_models.dart';

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

  late String _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(categoryProductsProvider.notifier).fetchInitial(_selectedCategoryId);
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
      ref.read(categoryProductsProvider.notifier).loadMore(_selectedCategoryId);
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(categoryProductsProvider.notifier).refresh(_selectedCategoryId);
  }

  void _onSubcategorySelected(String id) {
    if (_selectedCategoryId == id) return;
    setState(() {
      _selectedCategoryId = id;
    });
    ref.read(categoryProductsProvider.notifier).fetchInitial(_selectedCategoryId);
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
        scrolledUnderElevation: 4,
        shadowColor: AppColors.primary.withValues(alpha: 0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
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
            AppButton.primary(
              label: 'Retry',
              onPressed: () => notifier.fetchInitial(widget.categoryId),
            ),
          ],
        ),
      );
    }

    final categoriesAsync = ref.watch(categoriesProvider);
    final mainCategory = categoriesAsync.asData?.value.firstWhere(
      (c) => c.id == widget.categoryId,
      orElse: () => Category(id: widget.categoryId, name: 'Category'),
    );
    final hasSubcategories = mainCategory != null && mainCategory.children.isNotEmpty;

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        // Subcategories Bar
        if (hasSubcategories)
          SliverToBoxAdapter(
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
                children: [
                  _buildSubcategoryChip(
                    id: widget.categoryId,
                    name: 'All ${mainCategory.name}',
                    isSelected: _selectedCategoryId == widget.categoryId,
                  ).animate().fade(duration: AppAnimations.medium).slideX(begin: -0.2, end: 0),
                  ...mainCategory.children.asMap().entries.map((entry) => Padding(
                        padding: const EdgeInsets.only(left: AppSpacing.sm),
                        child: _buildSubcategoryChip(
                          id: entry.value.id,
                          name: entry.value.name,
                          isSelected: _selectedCategoryId == entry.value.id,
                        ),
                      ).animate().fade(
                        duration: AppAnimations.medium,
                        delay: Duration(milliseconds: 100 + (entry.key * 50)),
                      ).slideX(begin: -0.2, end: 0)),
                ],
              ),
            ),
          ),
          
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
                _buildFilterChip('Sort', Icons.sort_rounded),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Price', Icons.attach_money_rounded),
                const SizedBox(width: AppSpacing.sm),
                _buildFilterChip('Offers', Icons.local_offer_outlined),
              ],
            ).animate().fade(duration: AppAnimations.medium, delay: 200.ms),
          ),
        ),
        
        if (state.products.isEmpty)
          const SliverFillRemaining(
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
                  ).animate().fade(
                    duration: AppAnimations.medium,
                    delay: Duration(milliseconds: (index % 6) * 50),
                  ).slideY(begin: 0.1, end: 0);
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
    return InteractiveContainer(
      onTap: () {},
      scaleDown: 0.9,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textPrimary),
            const SizedBox(width: 6),
            Text(label, style: AppTypography.label.copyWith(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubcategoryChip({
    required String id,
    required String name,
    required bool isSelected,
  }) {
    return InteractiveContainer(
      onTap: () => _onSubcategorySelected(id),
      scaleDown: 0.95,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            name,
            style: AppTypography.label.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
