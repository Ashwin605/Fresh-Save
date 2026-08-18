import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import 'owner_product_repository.dart';

class OwnerProductRepositoryImpl implements OwnerProductRepository {
  final Dio _client;

  OwnerProductRepositoryImpl(this._client);

  @override
  Future<Result<OwnerProductPaginatedResponse>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? categoryId,
    String? brand,
    String? status,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'page': page, 'limit': limit};

      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (categoryId != null && categoryId.isNotEmpty) {
        queryParameters['categoryId'] = categoryId;
      }
      if (brand != null && brand.isNotEmpty) queryParameters['brand'] = brand;
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await _client.get(
        '/products',
        queryParameters: queryParameters,
      );

      return Result.success(
        OwnerProductPaginatedResponse.fromJson(response.data),
      );
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<OwnerProduct>> getProductDetails(String id) async {
    try {
      final response = await _client.get('/products/$id');

      final data = response.data;
      if (data is Map<String, dynamic> &&
          data.containsKey('success') &&
          data.containsKey('data')) {
        return Result.success(OwnerProduct.fromJson(data['data']));
      }

      return Result.success(OwnerProduct.fromJson(response.data));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<OwnerProduct>> createProduct({
    required String name,
    required String categoryId,
    String? description,
    String? brand,
    String? unit,
  }) async {
    try {
      final response = await _client.post(
        '/products',
        data: {
          'name': name,
          'categoryId': categoryId,
          if (description != null && description.isNotEmpty) 'description': description,
          if (brand != null && brand.isNotEmpty) 'brand': brand,
          if (unit != null && unit.isNotEmpty) 'unit': unit,
        },
      );
      
      final data = response.data;
      if (data is Map<String, dynamic> &&
          data.containsKey('success') &&
          data.containsKey('data')) {
        return Result.success(OwnerProduct.fromJson(data['data']));
      }

      return Result.success(OwnerProduct.fromJson(response.data));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
