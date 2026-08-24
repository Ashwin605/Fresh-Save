import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/auth_models.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    dio: ref.watch(dioProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio dio;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({required this.dio, required this.tokenStorage});

  @override
  Future<Result<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final loginResponse = LoginResponse.fromJson(response.data as Map<String, dynamic>);
      await tokenStorage.saveTokens(
        accessToken: loginResponse.tokens.accessToken,
        refreshToken: loginResponse.tokens.refreshToken,
      );
      return Result.success(loginResponse);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<User>> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final data = {'name': name, 'email': email, 'password': password};
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await dio.post('/auth/register', data: data);
      return Result.success(User.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
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
  }) async {
    try {
      final data = {
        'ownerName': ownerName,
        'email': email,
        'password': password,
        'businessName': businessName,
        'storeName': storeName,
        'storeAddress': storeAddress,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
      };
      if (phone != null && phone.isNotEmpty) {
        data['phone'] = phone;
      }

      final response = await dio.post('/auth/register-business', data: data);
      return Result.success(User.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<User>> getCurrentUser() async {
    try {
      final response = await dio.get('/auth/me');
      return Result.success(User.fromJson(response.data as Map<String, dynamic>));
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await dio.post('/auth/logout');
    } catch (e) {
      // Ignore network errors on logout, we still clear local session
    } finally {
      await tokenStorage.clearTokens();
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await dio.post(
        '/auth/change-password',
        data: {'oldPassword': currentPassword, 'newPassword': newPassword},
      );
      return const Result.success(null);
    } catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    }
  }
}
