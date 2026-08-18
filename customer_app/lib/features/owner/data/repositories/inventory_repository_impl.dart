import '../../../../core/network/dio_client.dart';
import '../../../../../core/network/result.dart';
import '../../domain/models/inventory_models.dart';
import 'inventory_repository.dart';

import 'package:dio/dio.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final Dio _dioClient;

  InventoryRepositoryImpl(this._dioClient);

  @override
  Future<Result<InventoryPaginatedResponse>> getStoreInventory(
    String storeId, {
    int page = 1,
    int limit = 20,
    String? expiryStatus,
    bool? lowStock,
  }) async {
    try {
      final queryParameters = <String, dynamic>{'page': page, 'limit': limit};
      if (expiryStatus != null) queryParameters['expiryStatus'] = expiryStatus;
      if (lowStock != null) queryParameters['lowStock'] = lowStock.toString();

      final response = await _dioClient.get(
        '/stores/$storeId/inventory',
        queryParameters: queryParameters,
      );

      return Result.success(InventoryPaginatedResponse.fromJson(response.data));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<OwnerInventoryItem>> getInventoryDetails(String id) async {
    try {
      final response = await _dioClient.get('/inventory/$id');
      // The single item endpoint might wrap the data or return it directly.
      // Based on typical nestjs controllers, it usually returns the entity directly.
      // E.g. { id: '...', ... }

      // Let's assume it returns { success: true, data: { ... } } if it's consistent,
      // or just { id: ... }. I'll handle { success: true, data: {} } wrapping just in case.

      final data = response.data;
      if (data is Map<String, dynamic> &&
          data.containsKey('success') &&
          data.containsKey('data')) {
        return Result.success(OwnerInventoryItem.fromJson(data['data']));
      }

      return Result.success(OwnerInventoryItem.fromJson(response.data));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<void>> adjustStock(
    String id,
    AdjustStockRequest request,
  ) async {
    try {
      await _dioClient.post(
        '/inventory/$id/adjust-stock',
        data: request.toJson(),
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<OwnerInventoryItem>> createInventory(
    String storeId, {
    required String productId,
    required int stockQuantity,
    required double originalPrice,
    required double sellingPrice,
    required String expiryDate,
    String? batchNumber,
    String? manufacturingDate,
  }) async {
    try {
      final response = await _dioClient.post(
        '/stores/$storeId/inventory',
        data: {
          'productId': productId,
          'stockQuantity': stockQuantity,
          'originalPrice': originalPrice,
          'sellingPrice': sellingPrice,
          'expiryDate': expiryDate,
          if (batchNumber != null && batchNumber.isNotEmpty) 'batchNumber': batchNumber,
          if (manufacturingDate != null && manufacturingDate.isNotEmpty) 'manufacturingDate': manufacturingDate,
        },
      );
      
      final data = response.data;
      if (data is Map<String, dynamic> &&
          data.containsKey('success') &&
          data.containsKey('data')) {
        return Result.success(OwnerInventoryItem.fromJson(data['data']));
      }

      return Result.success(OwnerInventoryItem.fromJson(response.data));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
