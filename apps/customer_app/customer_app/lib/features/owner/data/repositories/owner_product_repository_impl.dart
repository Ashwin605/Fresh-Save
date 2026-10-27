import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/owner_product_models.dart';
import '../../domain/models/store_product_model.dart';
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
    String? sku,
    String? barcode,
    String? image,
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
          if (sku != null && sku.isNotEmpty) 'sku': sku,
          if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
          if (image != null && image.isNotEmpty) 'image': image,
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

  @override
  Future<Result<OwnerProduct>> updateProduct(
    String id, {
    String? name,
    String? categoryId,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
  }) async {
    try {
      final response = await _client.patch(
        '/products/$id',
        data: {
          if (name != null && name.isNotEmpty) 'name': name,
          if (categoryId != null && categoryId.isNotEmpty) 'categoryId': categoryId,
          if (description != null) 'description': description,
          if (brand != null) 'brand': brand,
          if (sku != null) 'sku': sku,
          if (barcode != null) 'barcode': barcode,
          if (image != null) 'image': image,
          if (unit != null) 'unit': unit,
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

  // Store-specific products
  @override
  Future<Result<StoreProductPaginatedResponse>> getStoreProducts(
    String storeId, {
    int page = 1,
    int limit = 20,
    String? search,
    String? categoryId,
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
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await _client.get(
        '/stores/$storeId/products',
        queryParameters: queryParameters,
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        return Result.success(StoreProductPaginatedResponse.fromJson(data));
      }

      return Result.failure(AppError.server(message: 'Invalid response format'));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<StoreProduct>> getStoreProductDetails(
    String storeId,
    String identifier,
  ) async {
    try {
      final response = await _client.get('/stores/$storeId/products/$identifier');

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('success') && data.containsKey('data')) {
          return Result.success(StoreProduct.fromJson(data['data'] as Map<String, dynamic>));
        }
        return Result.success(StoreProduct.fromJson(data));
      }

      return Result.failure(AppError.server(message: 'Invalid response format'));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<StoreProduct>> createStoreProduct(
    String storeId, {
    required String name,
    required String categoryId,
    required double sellingPrice,
    required double originalPrice,
    required int initialStockQuantity,
    required String expiryDate,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    String? manufacturingDate,
    String? batchNumber,
    String? productId,
  }) async {
    try {
      final response = await _client.post(
        '/stores/$storeId/products',
        data: {
          'name': name,
          'categoryId': categoryId,
          'sellingPrice': sellingPrice,
          'originalPrice': originalPrice,
          'initialStockQuantity': initialStockQuantity,
          'expiryDate': expiryDate,
          if (description != null && description.isNotEmpty) 'description': description,
          if (brand != null && brand.isNotEmpty) 'brand': brand,
          if (sku != null && sku.isNotEmpty) 'sku': sku,
          if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
          if (image != null && image.isNotEmpty) 'image': image,
          if (unit != null && unit.isNotEmpty) 'unit': unit,
          if (manufacturingDate != null && manufacturingDate.isNotEmpty)
            'manufacturingDate': manufacturingDate,
          if (batchNumber != null && batchNumber.isNotEmpty) 'batchNumber': batchNumber,
          if (productId != null && productId.isNotEmpty) 'productId': productId,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('success') && data.containsKey('data')) {
          return Result.success(StoreProduct.fromJson(data['data'] as Map<String, dynamic>));
        }
        return Result.success(StoreProduct.fromJson(data));
      }

      return Result.failure(AppError.server(message: 'Invalid response format'));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<StoreProduct>> updateStoreProduct(
    String storeId,
    String identifier, {
    String? name,
    String? categoryId,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    double? sellingPrice,
    double? originalPrice,
    int? stockQuantity,
    String? expiryDate,
    String? manufacturingDate,
    String? batchNumber,
    String? inventoryStatus,
  }) async {
    try {
      final response = await _client.patch(
        '/stores/$storeId/products/$identifier',
        data: {
          if (name != null) 'name': name,
          if (categoryId != null) 'categoryId': categoryId,
          if (description != null) 'description': description,
          if (brand != null) 'brand': brand,
          if (sku != null) 'sku': sku,
          if (barcode != null) 'barcode': barcode,
          if (image != null) 'image': image,
          if (unit != null) 'unit': unit,
          if (sellingPrice != null) 'sellingPrice': sellingPrice,
          if (originalPrice != null) 'originalPrice': originalPrice,
          if (stockQuantity != null) 'stockQuantity': stockQuantity,
          if (expiryDate != null) 'expiryDate': expiryDate,
          if (manufacturingDate != null) 'manufacturingDate': manufacturingDate,
          if (batchNumber != null) 'batchNumber': batchNumber,
          if (inventoryStatus != null) 'inventoryStatus': inventoryStatus,
        },
      );

      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('success') && data.containsKey('data')) {
          return Result.success(StoreProduct.fromJson(data['data'] as Map<String, dynamic>));
        }
        return Result.success(StoreProduct.fromJson(data));
      }

      return Result.failure(AppError.server(message: 'Invalid response format'));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<bool>> removeStoreProduct(
    String storeId,
    String identifier,
  ) async {
    try {
      await _client.delete('/stores/$storeId/products/$identifier');
      return const Result.success(true);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<String>> uploadProductImage({
    String? filePath,
    List<int>? fileBytes,
    required String filename,
  }) async {
    try {
      MultipartFile multipartFile;
      if (filePath != null && filePath.isNotEmpty) {
        multipartFile = await MultipartFile.fromFile(filePath, filename: filename);
      } else if (fileBytes != null) {
        multipartFile = MultipartFile.fromBytes(fileBytes, filename: filename);
      } else {
        return Result.failure(AppError.validation(message: 'No file data provided'));
      }

      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final response = await _client.post(
        '/products/upload-image',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      final data = response.data;
      String? url;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('data') && data['data'] is Map<String, dynamic>) {
          url = data['data']['url'] as String?;
        } else {
          url = data['url'] as String?;
        }
      }

      if (url != null && url.isNotEmpty) {
        return Result.success(url);
      }

      return Result.failure(AppError.server(message: 'Failed to retrieve image URL'));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
