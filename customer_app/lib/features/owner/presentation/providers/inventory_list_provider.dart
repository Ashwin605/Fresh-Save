import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/inventory_models.dart';
import '../../data/repositories/inventory_repository_provider.dart';
import 'owner_state_provider.dart';
import '../../../../../core/network/result.dart';

class InventoryListState {
  final List<OwnerInventoryItem> items;
  final bool isLoading;
  final bool isFetchingMore;
  final String? error;
  final int currentPage;
  final int totalPages;
  final String activeFilter; // 'ALL', 'LOW_STOCK', 'EXPIRING_SOON', 'EXPIRED'

  const InventoryListState({
    this.items = const [],
    this.isLoading = true,
    this.isFetchingMore = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.activeFilter = 'ALL',
  });

  InventoryListState copyWith({
    List<OwnerInventoryItem>? items,
    bool? isLoading,
    bool? isFetchingMore,
    String? error,
    int? currentPage,
    int? totalPages,
    String? activeFilter,
  }) {
    return InventoryListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}

class InventoryListNotifier extends Notifier<InventoryListState> {
  @override
  InventoryListState build() {
    final activeStore = ref.watch(
      ownerStateProvider.select((s) => s.activeStore),
    );

    if (activeStore != null) {
      Future.microtask(() => loadInitial());
      return const InventoryListState(isLoading: true);
    }
    return const InventoryListState(isLoading: false, error: 'No active store');
  }

  Future<void> loadInitial() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: 1,
      items: [],
    );
    await _fetchPage(1);
  }

  Future<void> loadMore() async {
    if (state.isLoading ||
        state.isFetchingMore ||
        state.currentPage >= state.totalPages) {
      return;
    }
    state = state.copyWith(isFetchingMore: true);
    await _fetchPage(state.currentPage + 1);
  }

  Future<void> setFilter(String filter) async {
    if (state.activeFilter == filter) return;
    state = state.copyWith(
      activeFilter: filter,
      isLoading: true,
      items: [],
      currentPage: 1,
      error: null,
    );
    await _fetchPage(1);
  }

  Future<void> _fetchPage(int page) async {
    final store = ref.read(ownerStateProvider).activeStore;
    if (store == null) {
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: 'No active store',
      );
      return;
    }

    final repo = ref.read(inventoryRepositoryProvider);

    bool? lowStock;
    String? expiryStatus;

    if (state.activeFilter == 'LOW_STOCK') {
      lowStock = true;
    } else if (state.activeFilter == 'EXPIRING_SOON') {
      expiryStatus = 'EXPIRING_SOON';
    } else if (state.activeFilter == 'EXPIRED') {
      expiryStatus = 'EXPIRED';
    }

    final result = await repo.getStoreInventory(
      store.id,
      page: page,
      limit: 20,
      lowStock: lowStock,
      expiryStatus: expiryStatus,
    );

    if (result is Success<InventoryPaginatedResponse>) {
      final response = result.data;
      final newItems = page == 1
          ? response.data.items
          : [...state.items, ...response.data.items];
      state = state.copyWith(
        items: newItems,
        currentPage: response.data.pagination.page,
        totalPages: response.data.pagination.totalPages,
        isLoading: false,
        isFetchingMore: false,
      );
    } else if (result is Failure<InventoryPaginatedResponse>) {
      state = state.copyWith(
        error: result.error.message,
        isLoading: false,
        isFetchingMore: false,
      );
    }
  }
}

final inventoryListProvider =
    NotifierProvider<InventoryListNotifier, InventoryListState>(() {
      return InventoryListNotifier();
    });
