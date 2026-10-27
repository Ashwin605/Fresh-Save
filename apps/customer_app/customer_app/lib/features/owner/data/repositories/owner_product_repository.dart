import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import '../../domain/models/store_product_model.dart';

abstract class OwnerProductRepository {
  // Global / Master catalog methods
  Future<Result<OwnerProductPaginatedResponse>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? categoryId,
    String? brand,
    String? status,
  });

  Future<Result<OwnerProduct>> getProductDetails(String id);

  Future<Result<OwnerProduct>> createProduct({
    required String name,
    required String categoryId,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
  });

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
  });

  // Store-specific product catalog management
  Future<Result<StoreProductPaginatedResponse>> getStoreProducts(
    String storeId, {
    int page = 1,
    int limit = 20,
    String? search,
    String? categoryId,
    String? status,
  });

  Future<Result<StoreProduct>> getStoreProductDetails(
    String storeId,
    String identifier,
  );

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
  });

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
  });

  Future<Result<bool>> removeStoreProduct(
    String storeId,
    String identifier,
  );

  // Real Image Upload API
  Future<Result<String>> uploadProductImage({
    String? filePath,
    List<int>? fileBytes,
    required String filename,
  });
}
