import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import '../../data/repositories/owner_product_repository_provider.dart';
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
}

final ownerProductListFilterProvider =
    NotifierProvider<OwnerProductListFilterNotifier, Map<String, String?>>(
      OwnerProductListFilterNotifier.new,
    );

final ownerProductListProvider =
    FutureProvider.autoDispose<OwnerProductPaginatedResponse>((ref) async {
      // Watch active store so that switching stores automatically invalidates the product list
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
        limit:
            100, // Load 100 items for catalog for simplicity. Can implement infinite scroll if needed.
        search: filters['search'],
        categoryId: filters['categoryId'],
        brand: filters['brand'],
        status: filters['status'],
      );

      return result.when(
        success: (data) => data,
        failure: (error) => throw Exception(error.message ?? 'Unknown error'),
      );
    });
