import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/team_models.dart';
import 'team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepositoryImpl(ref.watch(dioProvider));
});

class TeamRepositoryImpl implements TeamRepository {
  final Dio _dio;

  TeamRepositoryImpl(this._dio);

  @override
  Future<Result<List<StoreStaff>>> getStoreStaff(String storeId) async {
    try {
      final response = await _dio.get('/stores/$storeId/staff');
      final data = (response.data as List)
          .map((e) => StoreStaff.fromJson(e))
          .toList();
      return Result.success(data);
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<StoreStaff>> addStaffMember(
    String storeId,
    String email,
  ) async {
    try {
      final response = await _dio.post(
        '/stores/$storeId/staff',
        data: {'email': email},
      );
      return Result.success(StoreStaff.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> removeStaffMember(String storeId, String staffId) async {
    try {
      await _dio.delete('/stores/$storeId/staff/$staffId');
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(ApiErrorHandler.handle(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
