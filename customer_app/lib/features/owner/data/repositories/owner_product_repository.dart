import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';

abstract class OwnerProductRepository {
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
    String? unit,
  });
}
