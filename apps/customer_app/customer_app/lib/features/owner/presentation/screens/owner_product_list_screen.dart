import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/owner_state_provider.dart';
import '../providers/owner_product_list_provider.dart';
import '../providers/category_list_provider.dart';
import '../widgets/products/store_product_card.dart';
import 'owner_add_product_screen.dart';
import 'owner_edit_product_screen.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/inputs/app_text_field.dart';
import '../../../../../core/widgets/buttons/app_button.dart';

class OwnerProductListScreen extends ConsumerStatefulWidget {
  const OwnerProductListScreen({super.key});

  @override
  ConsumerState<OwnerProductListScreen> createState() =>
      _OwnerProductListScreenState();
}

class _OwnerProductListScreenState
    extends ConsumerState<OwnerProductListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddProduct() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const OwnerAddProductScreen(),
      ),
    ).then((_) {
      ref.invalidate(ownerStoreProductListProvider);
    });
  }

  void _navigateToEditProduct(dynamic product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OwnerEditProductScreen(initialProduct: product),
      ),
    ).then((_) {
      ref.invalidate(ownerStoreProductListProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ownerState = ref.watch(ownerStateProvider);

    if (ownerState.contextState == OwnerContextState.loading ||
        ownerState.contextState == OwnerContextState.initial) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    final activeStore = ownerState.activeStore;
    if (activeStore == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 64,
                  color: AppColors.textDisabled,
                ),
                const SizedBox(height: AppSpacing.md),
                Text('No Active Store', style: AppTypography.headline),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Please select or register a store to manage your product catalog.',
                  textAlign: TextAlign.center,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final productsState = ref.watch(ownerStoreProductListProvider);
    final categoriesState = ref.watch(categoryListProvider);
    final activeFilters = ref.watch(ownerProductListFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddProduct,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(activeStore.name),
            _buildSearchBar(),
            const SizedBox(height: AppSpacing.xs),
            _buildCategoryFilters(categoriesState, activeFilters['categoryId']),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  ref.invalidate(ownerStoreProductListProvider);
                },
                child: productsState.when(
                  data: (response) {
                    final products = response.data.items;
                    if (products.isEmpty) {
                      return _buildEmptyState(
                        isFiltered: (activeFilters['search'] != null &&
                                activeFilters['search']!.isNotEmpty) ||
                            activeFilters['categoryId'] != null,
                      );
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                        left: AppSpacing.md,
                        right: AppSpacing.md,
                        top: AppSpacing.sm,
                        bottom: 80, // Space for FAB
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return StoreProductCard(
                          product: product,
                          onEdit: () => _navigateToEditProduct(product),
                          onTap: () => _navigateToEditProduct(product),
                        ).animate().fade(
                              duration: 300.ms,
                              delay: (index * 40).ms,
                            ).slideY(
                              begin: 0.08,
                              end: 0,
                              curve: Curves.easeOutQuad,
                            );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                  error: (error, stack) => Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Failed to load products',
                            style: AppTypography.title,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            error.toString().replaceAll('Exception: ', ''),
                            textAlign: TextAlign.center,
                            style: AppTypography.body.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            onPressed: () {
                              ref.invalidate(ownerStoreProductListProvider);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String storeName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (Navigator.of(context).canPop())
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              if (Navigator.of(context).canPop())
                const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Store Products', style: AppTypography.headline),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        storeName,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          IconButton.filledTonal(
            tooltip: 'Add New Product',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              foregroundColor: AppColors.primary,
            ),
            icon: const Icon(Icons.add),
            onPressed: _navigateToAddProduct,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: AppTextField(
        controller: _searchController,
        hintText: 'Search products by name, SKU, or barcode...',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _searchController.clear();
                  ref
                      .read(ownerProductListFilterProvider.notifier)
                      .updateFilter('search', null);
                  setState(() {});
                },
              )
            : null,
        onChanged: (val) {
          ref
              .read(ownerProductListFilterProvider.notifier)
              .updateFilter('search', val.trim().isEmpty ? null : val.trim());
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCategoryFilters(
    CategoryListState categoriesState,
    String? selectedCategoryId,
  ) {
    if (categoriesState.isLoading) {
      return const SizedBox(height: 38);
    }

    final list = categoriesState.categories.where((c) => c.parentId == null).toList();
    if (list.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        scrollDirection: Axis.horizontal,
        itemCount: list.length + 1,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = selectedCategoryId == null;
            return ChoiceChip(
              label: const Text('All Categories'),
              selected: isSelected,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              onSelected: (_) {
                ref
                    .read(ownerProductListFilterProvider.notifier)
                    .updateFilter('categoryId', null);
              },
            );
          }

          final cat = list[index - 1];
          final isSelected = selectedCategoryId == cat.id;

          return ChoiceChip(
            label: Text(cat.name),
            selected: isSelected,
            selectedColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 12,
            ),
            onSelected: (_) {
              ref
                  .read(ownerProductListFilterProvider.notifier)
                  .updateFilter(
                    'categoryId',
                    isSelected ? null : cat.id,
                  );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({required bool isFiltered}) {
    if (isFiltered) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_outlined,
                size: 64,
                color: AppColors.textDisabled.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('No Matching Products', style: AppTypography.title),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'No products match your current search or category filter.',
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              OutlinedButton(
                onPressed: () {
                  _searchController.clear();
                  ref.read(ownerProductListFilterProvider.notifier).reset();
                  setState(() {});
                },
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_shopping_cart_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Products in Your Store',
              style: AppTypography.headline.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Start adding products with photos, prices, discounts, and inventory to attract nearby customers.',
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: AppButton(
                label: 'Add First Product',
                onPressed: _navigateToAddProduct,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
