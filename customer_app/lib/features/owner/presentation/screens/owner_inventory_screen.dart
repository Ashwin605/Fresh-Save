import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_spacing.dart';
import '../providers/inventory_list_provider.dart';
import '../widgets/inventory/inventory_card.dart';

class OwnerInventoryScreen extends ConsumerStatefulWidget {
  const OwnerInventoryScreen({super.key});

  @override
  ConsumerState<OwnerInventoryScreen> createState() =>
      _OwnerInventoryScreenState();
}

class _OwnerInventoryScreenState extends ConsumerState<OwnerInventoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(inventoryListProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryListProvider);
    final notifier = ref.read(inventoryListProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Inventory',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: state.activeFilter == 'ALL',
                  onSelected: () => notifier.setFilter('ALL'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Low Stock',
                  isSelected: state.activeFilter == 'LOW_STOCK',
                  onSelected: () => notifier.setFilter('LOW_STOCK'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Expiring Soon',
                  isSelected: state.activeFilter == 'EXPIRING_SOON',
                  onSelected: () => notifier.setFilter('EXPIRING_SOON'),
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Expired',
                  isSelected: state.activeFilter == 'EXPIRED',
                  onSelected: () => notifier.setFilter('EXPIRED'),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notifier.loadInitial(),
              child: _buildListContent(state),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/owner/inventory/add'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.surface),
      ),
    );
  }

  Widget _buildListContent(InventoryListState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!, style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () =>
                  ref.read(inventoryListProvider.notifier).loadInitial(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return ListView(
        children: [
          SizedBox(height: 100),
          Center(
            child: Text(
              'No inventory items found.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: state.items.length + (state.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.items.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final item = state.items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: InventoryCard(
            item: item,
            onTap: () => context.goNamed(
              'owner_inventory_detail',
              pathParameters: {'id': item.id},
            ),
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      checkmarkColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
      ),
    );
  }
}
