import '../../../../core/network/result.dart';
import '../../domain/models/team_models.dart';

abstract class TeamRepository {
  Future<Result<List<StoreStaff>>> getStoreStaff(String storeId);
  Future<Result<StoreStaff>> addStaffMember(String storeId, String email);
  Future<Result<void>> removeStaffMember(String storeId, String staffId);
}
