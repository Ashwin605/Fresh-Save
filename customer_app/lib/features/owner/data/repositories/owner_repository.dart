import '../../../../core/network/result.dart';
import '../../domain/models/store_owner_models.dart';

abstract class OwnerRepository {
  Future<Result<OwnerBusiness>> getMyBusiness();
  Future<Result<List<OwnerStore>>> getBusinessStores(String businessId);
  Future<Result<DashboardMetrics>> getDashboardMetrics(String storeId);
  Future<Result<OwnerBusiness>> createBusiness(CreateBusinessRequest request);
  Future<Result<OwnerStore>> createStore(
    String businessId,
    CreateStoreRequest request,
  );
  Future<Result<OwnerBusiness>> updateBusiness(
    String id,
    UpdateBusinessRequest request,
  );
  Future<Result<OwnerStore>> updateStore(
    String storeId,
    UpdateStoreRequest request,
  );
}
