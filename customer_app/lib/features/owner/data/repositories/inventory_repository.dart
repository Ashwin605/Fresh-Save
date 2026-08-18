import '../../../../../core/network/result.dart';
import '../../domain/models/inventory_models.dart';

abstract class InventoryRepository {
  /// Fetches a paginated list of inventory items for a store.
  ///
  /// [expiryStatus] can be 'CRITICAL', 'URGENT', 'EXPIRING_SOON', 'FRESH', 'EXPIRED'
  Future<Result<InventoryPaginatedResponse>> getStoreInventory(
    String storeId, {
    int page = 1,
    int limit = 20,
    String? expiryStatus,
    bool? lowStock,
  });

  /// Fetches the details of a single inventory item.
  Future<Result<OwnerInventoryItem>> getInventoryDetails(String id);

  /// Adjusts the stock of a specific inventory item.
  Future<Result<void>> adjustStock(String id, AdjustStockRequest request);

  /// Creates a new inventory item
  Future<Result<OwnerInventoryItem>> createInventory(
    String storeId, {
    required String productId,
    required int stockQuantity,
    required double originalPrice,
    required double sellingPrice,
    required String expiryDate,
    String? batchNumber,
    String? manufacturingDate,
  });
}
