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

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _dio.get('/categories');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch categories');
    }
  }

  Future<void> updateCategory(String categoryId, {String? image, int? sortOrder, String? status}) async {
    try {
      final data = <String, dynamic>{};
      if (image != null) data['image'] = image;
      if (sortOrder != null) data['sortOrder'] = sortOrder;
      if (status != null) data['status'] = status;
      
      await _dio.patch('/categories/$categoryId', data: data);
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to update category');
  Future<Map<String, dynamic>> getProducts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/products', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch products');
    }
  }

  Future<void> updateProductStatus(String id, String status) async {
    try {
      await _dio.patch('/admin/products/$id/status', data: {'status': status});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to update product status');
    }
  }

  Future<Map<String, dynamic>> getInventory({int page = 1, int limit = 20, String? storeId, String? search}) async {
    try {
      final response = await _dio.get('/admin/inventory', queryParameters: {
        'page': page, 'limit': limit,
        if (storeId != null) 'storeId': storeId,
        if (search != null) 'search': search,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch inventory');
    }
  }

  Future<Map<String, dynamic>> getInventoryMovements({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/inventory/movements', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch inventory movements');
    }
  }

  Future<Map<String, dynamic>> getReservations({int page = 1, int limit = 20, String? status}) async {
    try {
      final response = await _dio.get('/admin/reservations', queryParameters: {
        'page': page, 'limit': limit,
        if (status != null) 'status': status,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch reservations');
    }
  }

  Future<List<dynamic>> getDailyLoginStats() async {
    try {
      final response = await _dio.get('/admin/users/login-activity');
      return response.data as List<dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch login stats');
    }
  }

  Future<Map<String, dynamic>> getShopkeepers({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/shopkeepers', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch shopkeepers');
    }
  }

  Future<Map<String, dynamic>> getOffers({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/offers', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch offers');
    }
  }

  Future<Map<String, dynamic>> getCoupons({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/coupons', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch coupons');
    }
  }

  Future<Map<String, dynamic>> getContacts({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get('/admin/contacts', queryParameters: {'page': page, 'limit': limit});
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to fetch contacts');
    }
  }

  Future<void> updateContactStatus(String id, String status) async {
    try {
      await _dio.patch('/admin/contacts/$id/status', data: {'status': status});
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? e.message ?? 'Failed to update contact status');
    }
  }
}
