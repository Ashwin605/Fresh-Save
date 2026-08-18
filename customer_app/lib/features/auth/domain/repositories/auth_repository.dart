import '../../../../core/network/result.dart';
import '../models/auth_models.dart';

abstract class AuthRepository {
  Future<Result<AuthTokens>> login({
    required String email,
    required String password,
  });
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  Future<Result<User>> registerBusiness({
    required String ownerName,
    required String email,
    required String password,
    String? phone,
    required String businessName,
    required String storeName,
    required String storeAddress,
    double? latitude,
    double? longitude,
  });
  Future<Result<User>> getCurrentUser();
  Future<Result<void>> logout();
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
