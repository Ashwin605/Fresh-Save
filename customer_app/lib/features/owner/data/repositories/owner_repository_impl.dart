import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/store_owner_models.dart';
import 'owner_repository.dart';

final ownerRepositoryProvider = Provider<OwnerRepository>((ref) {
  return OwnerRepositoryImpl(ref.watch(dioProvider));
});

class OwnerRepositoryImpl implements OwnerRepository {
  final Dio _dio;

  OwnerRepositoryImpl(this._dio);

  @override
  Future<Result<OwnerBusiness>> getMyBusiness() async {
    try {
      final response = await _dio.get('/businesses/my');
      // UnwrapInterceptor already strips the envelope,
      // so response.data is the business object directly.
      if (response.data != null) {
        final businessData = response.data is List
            ? response.data.first
            : response.data;
        return Result.success(
          OwnerBusiness.fromJson(businessData as Map<String, dynamic>),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to load business'),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Result.failure(
          AppError.notFound(message: 'No business found'),
        );
      }
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<OwnerStore>>> getBusinessStores(String businessId) async {
    try {
      final response = await _dio.get('/businesses/$businessId/stores');

      if (response.data != null) {
        final list = response.data is List ? response.data : [response.data];
        final items = (list as List)
            .map((json) => OwnerStore.fromJson(json as Map<String, dynamic>))
            .toList();
        return Result.success(items);
      }
      return const Result.failure(
        AppError.server(message: 'Failed to load stores'),
      );
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<DashboardMetrics>> getDashboardMetrics(String storeId) async {
    try {
      final response = await _dio.get('/stores/$storeId/dashboard');

      if (response.data != null) {
        return Result.success(
          DashboardMetrics.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to load dashboard metrics'),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return const Result.failure(
          AppError.notFound(message: 'Dashboard metrics unavailable'),
        );
      }
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerBusiness>> createBusiness(
    CreateBusinessRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/businesses',
        data: request.toJson(),
      );

      if (response.data != null) {
        return Result.success(
          OwnerBusiness.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to create business'),
      );
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerStore>> createStore(
    String businessId,
    CreateStoreRequest request,
  ) async {
    try {
      final response = await _dio.post(
        '/businesses/$businessId/stores',
        data: request.toJson(),
      );

      if (response.data != null) {
        return Result.success(
          OwnerStore.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to create store'),
      );
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerBusiness>> updateBusiness(
    String id,
    UpdateBusinessRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/businesses/$id',
        data: request.toJson(),
      );

      if (response.data != null) {
        return Result.success(
          OwnerBusiness.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to update business'),
      );
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerStore>> updateStore(
    String storeId,
    UpdateStoreRequest request,
  ) async {
    try {
      final response = await _dio.patch(
        '/stores/$storeId',
        data: request.toJson(),
      );

      if (response.data != null) {
        return Result.success(
          OwnerStore.fromJson(response.data as Map<String, dynamic>),
        );
      }
      return const Result.failure(
        AppError.server(message: 'Failed to update store'),
      );
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
