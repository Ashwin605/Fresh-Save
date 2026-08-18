import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../../../../../app/theme/app_typography.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../providers/owner_product_detail_provider.dart';

class OwnerProductDetailScreen extends ConsumerWidget {
  final String productId;

  const OwnerProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(ownerProductDetailProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productState.when(
        data: (product) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: AppColors.surface,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () => context.pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: product.image != null && product.image!.isNotEmpty
                      ? Image.network(
                          product.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: AppColors.surfaceVariant,
                                child: const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 64,
                                  color: AppColors.textDisabled,
                                ),
                              ),
                        )
                      : Container(
                          color: AppColors.surfaceVariant,
                          child: const Icon(
                            Icons.inventory_2_outlined,
                            size: 64,
                            color: AppColors.textDisabled,
                          ),
                        ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppTypography.headline,
                            ),
                          ),
                          _buildStatusBadge(product.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      if (product.category != null)
                        Chip(
                          label: Text(
                            product.category!.name,
                            style: AppTypography.bodySmall,
                          ),
                          backgroundColor: AppColors.surfaceVariant,
                          side: BorderSide.none,
                        ),
                      const SizedBox(height: AppSpacing.lg),
                      if (product.description != null &&
                          product.description!.isNotEmpty) ...[
                        Text('Description', style: AppTypography.title),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          product.description!,
                          style: AppTypography.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                      Text('Details', style: AppTypography.title),
                      const SizedBox(height: AppSpacing.sm),
                      _buildDetailRow('Brand', product.brand ?? 'N/A'),
                      _buildDetailRow('Unit', product.unit ?? 'N/A'),
                      _buildDetailRow('SKU', product.sku ?? 'N/A'),
                      _buildDetailRow('Barcode', product.barcode ?? 'N/A'),
                      const SizedBox(height: AppSpacing.xl),
                      AppButton(
                        label: 'Add to Inventory',
                        onPressed: () {
                          // This would route to the Stock Adjustment sheet or inventory creation with this Product ID
                          // For now, route back to inventory screen.
                          context.go('/owner/inventory');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Failed to load product details',
                style: AppTypography.title,
              ),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(ownerProductDetailProvider(productId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status == 'ACTIVE';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.success.withAlpha(20)
            : AppColors.error.withAlpha(20),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: AppTypography.label.copyWith(
          color: isActive ? AppColors.success : AppColors.error,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            value,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
