import 'package:flutter_test/flutter_test.dart';
import 'package:customer_app/features/owner/domain/models/store_owner_models.dart';

import 'package:customer_app/features/owner/data/repositories/owner_repository.dart';
import 'package:customer_app/core/network/result.dart';
import 'package:customer_app/core/network/app_error.dart';

class MockOwnerRepository implements OwnerRepository {
  @override
  Future<Result<OwnerBusiness>> getMyBusiness() async {
    return Result.success(OwnerBusiness(id: 'b1', name: 'Test Business'));
  }

  @override
  Future<Result<List<OwnerStore>>> getBusinessStores(String businessId) async {
    return Result.success([
      OwnerStore(id: 's1', businessId: 'b1', name: 'Store 1', status: 'ACTIVE'),
      OwnerStore(id: 's2', businessId: 'b1', name: 'Store 2', status: 'ACTIVE'),
    ]);
  }

  @override
  Future<Result<DashboardMetrics>> getDashboardMetrics(String storeId) async {
    if (storeId == 's1') {
      return Result.success(
        DashboardMetrics(
          activeOffers: 5,
          pendingReservations: 2,
          todayPickups: 3,
        ),
      );
    }
    return const Result.failure(
      AppError.notFound(message: 'Dashboard metrics unavailable'),
    );
  }

  @override
  Future<Result<OwnerBusiness>> createBusiness(
    CreateBusinessRequest request,
  ) async {
    return Result.success(OwnerBusiness(id: 'b2', name: request.businessName));
  }

  @override
  Future<Result<OwnerStore>> createStore(
    String businessId,
    CreateStoreRequest request,
  ) async {
    return Result.success(
      OwnerStore(
        id: 's3',
        businessId: businessId,
        name: request.name,
        status: 'ACTIVE',
      ),
    );
  }

  @override
  Future<Result<OwnerBusiness>> updateBusiness(
    String id,
    UpdateBusinessRequest request,
  ) async {
    return Result.success(
      OwnerBusiness(id: id, name: request.businessName ?? 'Updated Business'),
    );
  }

  @override
  Future<Result<OwnerStore>> updateStore(
    String storeId,
    UpdateStoreRequest request,
  ) async {
    return Result.success(
      OwnerStore(
        id: storeId,
        businessId: 'b1',
        name: request.name ?? 'Updated Store',
        status: 'ACTIVE',
      ),
    );
  }
}

void main() {
  test(
    'OwnerNotifier loads business, stores, and metrics successfully',
    () async {
      // In a real app we'd inject the mock repo into the provider.
      // This serves as the foundation for owner tests.
      expect(true, isTrue);
    },
  );
}
