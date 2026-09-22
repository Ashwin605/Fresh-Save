import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/home_models.dart';
import '../../domain/models/discovery_state.dart';
import '../../domain/models/nearby_store_model.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';

abstract class DiscoveryRepository {
  Future<Result<List<Deal>>> searchDeals({
    required double lat,
    required double lng,
    required DiscoveryFilters filters,
    required DiscoverySort sort,
    required int page,
    int limit = 20,
  });

  Future<Result<List<NearbyStore>>> searchStores({
    required double lat,
    required double lng,
    String? search,
    String? categoryId,
    required int page,
    int limit = 20,
    double radius = 5.0,
  });
}

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final Dio _dio;

  DiscoveryRepositoryImpl(this._dio);

  @override
  Future<Result<List<Deal>>> searchDeals({
    required double lat,
    required double lng,
    required DiscoveryFilters filters,
    required DiscoverySort sort,
    required int page,
    int limit = 20,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'latitude': lat,
        'longitude': lng,
        'page': page,
        'limit': limit,
        'sortBy': sort.name,
        'sortOrder':
            sort == DiscoverySort.newest || sort == DiscoverySort.discount
            ? 'desc'
            : 'asc',
      };

      if (filters.radius != null) queryParams['radius'] = filters.radius;
      if (filters.categoryId != null) {
        queryParams['categoryId'] = filters.categoryId;
      }
      if (filters.minDiscount != null) {
        queryParams['minDiscount'] = filters.minDiscount;
      }
      if (filters.expiryWithinHours != null) {
        queryParams['expiryWithinHours'] = filters.expiryWithinHours;
      }

      final response = await _dio.get(
        '/discovery/deals/nearby',
        queryParameters: queryParams,
      );

      final inner = response.data['data'] as Map<String, dynamic>?;
      final items = inner?['items'] as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      final deals = items
          .map((e) => Deal.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(deals);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<NearbyStore>>> searchStores({
    required double lat,
    required double lng,
    String? search,
    String? categoryId,
    required int page,
    int limit = 20,
    double radius = 5.0,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'latitude': lat,
        'longitude': lng,
        'radius': radius,
        'page': page,
        'limit': limit,
      };

      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }

      final response = await _dio.get(
        '/discovery/stores/nearby',
        queryParameters: queryParams,
      );

      final inner = response.data['data'] as Map<String, dynamic>?;
      final items = inner?['items'] as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      final stores = items
          .map((e) => NearbyStore.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(stores);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepositoryImpl(ref.watch(dioProvider));
});
