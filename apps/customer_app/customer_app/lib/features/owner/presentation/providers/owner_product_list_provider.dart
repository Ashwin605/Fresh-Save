import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/owner_product_models.dart';
import '../../domain/models/store_product_model.dart';
import '../../data/repositories/owner_product_repository_provider.dart';
import '../../../../core/network/result.dart';
import 'owner_state_provider.dart';

class OwnerProductListFilterNotifier extends Notifier<Map<String, String?>> {
  @override
  Map<String, String?> build() => {
    'search': null,
    'categoryId': null,
    'brand': null,
    'status': null,
  };

  void updateFilter(String key, String? value) {
    state = {...state, key: value};
  }

  void reset() {
    state = {
      'search': null,
      'categoryId': null,
      'brand': null,
      'status': null,
    };
  }
}

final ownerProductListFilterProvider =
    NotifierProvider<OwnerProductListFilterNotifier, Map<String, String?>>(
      OwnerProductListFilterNotifier.new,
    );

/// Store-specific products provider for the shopkeeper's store catalog
final ownerStoreProductListProvider =
    FutureProvider.autoDispose<StoreProductPaginatedResponse>((ref) async {
      final activeStore = ref.watch(
        ownerStateProvider.select((s) => s.activeStore),
      );
      if (activeStore == null) {
        throw Exception('No active store available');
      }

      final filters = ref.watch(ownerProductListFilterProvider);
      final repository = ref.watch(ownerProductRepositoryProvider);

      final result = await repository.getStoreProducts(
        activeStore.id,
        page: 1,
        limit: 100,
        search: filters['search'],
        categoryId: filters['categoryId'],
        status: filters['status'],
      );

      return result.map(
        success: (s) => s.data,
        failure: (f) => throw Exception(f.error.message ?? 'Failed to load store products'),
      );
    });

/// Global product catalog lookup provider
final ownerProductListProvider =
    FutureProvider.autoDispose<OwnerProductPaginatedResponse>((ref) async {
      final activeStore = ref.watch(
        ownerStateProvider.select((s) => s.activeStore),
      );
      if (activeStore == null) {
        throw Exception('No active store');
      }

      final filters = ref.watch(ownerProductListFilterProvider);
      final repository = ref.watch(ownerProductRepositoryProvider);

      final result = await repository.getProducts(
        page: 1,
        limit: 100,
        search: filters['search'],
        categoryId: filters['categoryId'],
        brand: filters['brand'],
        status: filters['status'],
      );

      return result.map(
        success: (s) => s.data,
        failure: (f) => throw Exception(f.error.message ?? 'Unknown error'),
      );
    });
