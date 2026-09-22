import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_offer_models.dart';
import '../../data/repositories/owner_offer_repository_provider.dart';
import 'owner_state_provider.dart';

class OwnerOfferListFilterNotifier extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() => {
    'status': null,
    'productId': null,
    'sortBy': 'createdAt',
    'sortOrder': 'desc',
    'page': 1,
    'limit': 20,
  };

  void updateFilter(String key, dynamic value) {
    state = {...state, key: value};
  }

  void resetPage() {
    state = {...state, 'page': 1};
  }

  void loadMore() {
    state = {...state, 'page': (state['page'] as int) + 1};
  }
}

final ownerOfferListFilterProvider =
    NotifierProvider<OwnerOfferListFilterNotifier, Map<String, dynamic>>(
      OwnerOfferListFilterNotifier.new,
    );

final ownerOfferListProvider =
    FutureProvider.autoDispose<OwnerOfferPaginatedResponse>((ref) async {
      final filters = ref.watch(ownerOfferListFilterProvider);
      final storeId = ref.watch(
        ownerStateProvider.select((state) => state.activeStore?.id),
      );

      if (storeId == null) {
        throw Exception('No active store selected');
      }

      final repository = ref.watch(ownerOfferRepositoryProvider);

      final result = await repository.getOffers(
        storeId,
        status: filters['status'],
        productId: filters['productId'],
        sortBy: filters['sortBy'],
        sortOrder: filters['sortOrder'],
        page: filters['page'],
        limit: filters['limit'],
      );

      return result.when(
        success: (data) => data,
        failure: (error) => throw Exception(error.message ?? 'Unknown error'),
      );
    });
