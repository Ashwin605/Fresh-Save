import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../home/domain/models/home_models.dart';
import '../../../discovery/domain/models/discovery_state.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';

abstract class SearchRepository {
  Future<Result<List<Deal>>> searchDeals({
    required double lat,
    required double lng,
    required String query,
    required DiscoveryFilters filters,
    required DiscoverySort sort,
    int limit = 10,
  });

  Future<Result<List<Store>>> searchStores({
    required double lat,
    required double lng,
    required String query,
    int limit = 10,
  });

  Future<Result<List<Product>>> searchProducts({
    required String query,
    int limit = 10,
  });

  Future<Result<List<Product>>> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  });
}

class SearchRepositoryImpl implements SearchRepository {
  final Dio _dio;

  SearchRepositoryImpl(this._dio);

  @override
  Future<Result<List<Deal>>> searchDeals({
    required double lat,
    required double lng,
    required String query,
    required DiscoveryFilters filters,
    required DiscoverySort sort,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'latitude': lat,
        'longitude': lng,
        'search': query,
        'page': 1,
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

      return Result.success(
        items.map((e) => Deal.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<Store>>> searchStores({
    required double lat,
    required double lng,
    required String query,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/discovery/stores/nearby',
        queryParameters: {
          'latitude': lat,
          'longitude': lng,
          'search': query,
          'page': 1,
          'limit': limit,
        },
      );
      final inner = response.data['data'] as Map<String, dynamic>?;
      final items = inner?['items'] as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      return Result.success(
        items.map((e) => Store.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<Product>>> searchProducts({
    required String query,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/discovery/products',
        queryParameters: {'search': query, 'page': 1, 'limit': limit},
      );
      final inner = response.data['data'] as Map<String, dynamic>?;
      final realData = inner?['data'] as Map<String, dynamic>?;
      final items = (realData != null ? realData['items'] : inner?['items']) as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      return Result.success(
        items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<Product>>> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/discovery/products',
        queryParameters: {
          'categoryId': categoryId,
          'page': page,
          'limit': limit,
        },
      );
      final inner = response.data['data'] as Map<String, dynamic>?;
      final realData = inner?['data'] as Map<String, dynamic>?;
      final items = (realData != null ? realData['items'] : inner?['items']) as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      return Result.success(
        items.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.watch(dioProvider));
});
