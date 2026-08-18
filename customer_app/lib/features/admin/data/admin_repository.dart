import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.read(dioProvider));
});

class AdminRepository {
  final Dio _dio;

  AdminRepository(this._dio);

  Future<Map<String, dynamic>> getDashboardMetrics() async {
    try {
      final response = await _dio.get('/admin/dashboard');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch dashboard metrics');
    }
  }

  Future<Map<String, dynamic>> getUsers({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/users', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch users');
    }
  }

  Future<Map<String, dynamic>> getStores({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/stores', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch stores');
    }
  }

  Future<Map<String, dynamic>> getAuditLogs({int page = 1, int limit = 50}) async {
    try {
      final response = await _dio.get('/admin/audit-logs', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch audit logs');
    }
  }

  Future<void> suspendUser(String id, String reason) async {
    try {
      await _dio.patch('/admin/users/$id/suspend', data: {'reason': reason});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to suspend user');
    }
  }

  Future<void> updateStoreStatus(String id, String status) async {
    try {
      await _dio.patch('/admin/stores/$id/status', data: {'status': status});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to update store status');
    }
  }

  Future<void> createStore({
    required String name,
    required String address,
    required String ownerEmail,
    required bool verifyInstantly,
  }) async {
    try {
      await _dio.post('/admin/stores', data: {
        'ownerEmail': ownerEmail,
        'storeData': {
          'name': name,
          'address': address,
        },
        'verifyInstantly': verifyInstantly,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to create store');
    }
  }

  Future<void> updateStore({
    required String storeId,
    required String name,
    required String address,
  }) async {
    try {
      await _dio.patch('/admin/stores/$storeId', data: {
        'name': name,
        'address': address,
      });
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to update store');
    }
  }

  Future<void> deleteStore(String storeId) async {
    try {
      await _dio.delete('/admin/stores/$storeId');
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to delete store');
    }
  }
}
