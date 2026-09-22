import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class CategoryRepository {
  Future<Result<List<OwnerProductCategory>>> getCategories();
  Future<Result<OwnerProductCategory>> createCategory(String name, String? description);
}

class CategoryRepositoryImpl implements CategoryRepository {
  final Dio _client;

  CategoryRepositoryImpl(this._client);

  @override
  Future<Result<List<OwnerProductCategory>>> getCategories() async {
    try {
      final response = await _client.get('/categories');
      // The API returns a raw JSON array of categories
      final data = (response.data as List).map((e) => OwnerProductCategory.fromJson(e as Map<String, dynamic>)).toList();
      return Result.success(data);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<OwnerProductCategory>> createCategory(String name, String? description) async {
    try {
      final response = await _client.post(
        '/categories',
        data: {
          'name': name,
          if (description != null && description.isNotEmpty) 'description': description,
        },
      );
      return Result.success(OwnerProductCategory.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.watch(dioProvider));
});
