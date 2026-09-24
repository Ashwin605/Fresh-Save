import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../domain/models/coupon.dart';

abstract class CouponRepository {
  Future<Result<List<Coupon>>> getAvailableCoupons();
  Future<Result<Map<String, dynamic>>> validateCoupon({required String code, String? storeId, required double subtotal});
  Future<Result<Map<String, dynamic>>> applyCoupon(String code, String cartId);
  Future<Result<void>> removeCoupon(String cartId);
}

class CouponRepositoryImpl implements CouponRepository {
  final Dio _dio;

  CouponRepositoryImpl(this._dio);

  @override
  Future<Result<List<Coupon>>> getAvailableCoupons() async {
    try {
      final response = await _dio.get('/coupons');
      final data = response.data['data'] as Map<String, dynamic>?;
      final items = data?['coupons'] as List?;
      if (items == null || items.isEmpty) return const Success([]);
      final coupons = items.map((json) => Coupon.fromJson(json)).toList();
      return Success(coupons);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> validateCoupon({required String code, String? storeId, required double subtotal}) async {
    try {
      final response = await _dio.post('/coupons/validate', data: {
        'code': code,
        'storeId': storeId,
        'subtotal': subtotal,
      });
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Map<String, dynamic>>> applyCoupon(String code, String cartId) async {
    try {
      final response = await _dio.post('/coupons/apply', data: {
        'code': code,
        'cartId': cartId,
      });
      return Success(response.data);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> removeCoupon(String cartId) async {
    try {
      await _dio.post('/coupons/remove', data: {
        'cartId': cartId,
      });
      return const Success(null);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }
}

final couponRepositoryProvider = Provider<CouponRepository>((ref) {
  return CouponRepositoryImpl(ref.watch(dioProvider));
});
