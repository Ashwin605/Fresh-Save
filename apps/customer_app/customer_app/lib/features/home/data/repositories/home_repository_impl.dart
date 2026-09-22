import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/home_models.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';

abstract class HomeRepository {
  Future<Result<List<Category>>> getCategories();
  Future<Result<List<Deal>>> getNearbyDeals({
    required double lat,
    required double lng,
    int limit = 20,
  });
  Future<Result<Deal?>> getFeaturedDeal({
    required double lat,
    required double lng,
  });
  Future<Result<List<Store>>> getNearbyStores({
    required double lat,
    required double lng,
  });
  Future<Result<List<Product>>> getNearbyProducts({
    required double lat,
    required double lng,
    int limit = 20,
  });
}

class HomeRepositoryImpl implements HomeRepository {
  final Dio _dio;

  HomeRepositoryImpl(this._dio);

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      final response = await _dio.get('/discovery/categories');

      final data = response.data;
      if (data == null) return const Result.success([]);
      final list = data is List ? data : <dynamic>[];

      final topLevel = list
          .map((e) => Category.fromJson(e as Map<String, dynamic>))
          .toList();

      return Result.success(topLevel);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<Deal>>> getNearbyDeals({
    required double lat,
    required double lng,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/discovery/deals/nearby',
        queryParameters: {'latitude': lat, 'longitude': lng, 'limit': limit},
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
  Future<Result<Deal?>> getFeaturedDeal({
    required double lat,
    required double lng,
  }) async {
    try {
      // Get the absolute closest/best deal by limiting to 1
      final result = await getNearbyDeals(lat: lat, lng: lng, limit: 1);

      if (result is Success<List<Deal>>) {
        return Result.success(
          result.data.isNotEmpty ? result.data.first : null,
        );
      } else if (result is Failure<List<Deal>>) {
        return Result.failure(result.error);
      }

      return const Result.success(null);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<Store>>> getNearbyStores({
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await _dio.get(
        '/discovery/stores/nearby',
        queryParameters: {'latitude': lat, 'longitude': lng},
      );

      final inner = response.data['data'] as Map<String, dynamic>?;
      final items = inner?['items'] as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      final stores = items
          .map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(stores);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<List<Product>>> getNearbyProducts({
    required double lat,
    required double lng,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/discovery/products',
        queryParameters: {'latitude': lat, 'longitude': lng, 'limit': limit},
      );

      final inner = response.data['data'] as Map<String, dynamic>?;
      final items = inner?['items'] as List?;
      if (items == null || items.isEmpty) return const Result.success([]);

      final products = items
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
      return Result.success(products);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(ref.watch(dioProvider));
});
