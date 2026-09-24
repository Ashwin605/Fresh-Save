import '../../../../core/network/result.dart';
import '../../../../core/network/dio_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/reservation_models.dart';

abstract class PricingRepository {
  Future<Result<Map<String, dynamic>>> calculateCartPrice(CreateReservationRequest request);
}

class PricingRepositoryImpl implements PricingRepository {
  final Dio _dio;

  PricingRepositoryImpl(this._dio);

  @override
  Future<Result<Map<String, dynamic>>> calculateCartPrice(CreateReservationRequest request) async {
    try {
      final response = await _dio.post('/cart/calculate', data: request.toJson());
      return Success(response.data['data']);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.response?.data?['message'] ?? e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }
}

final pricingRepositoryProvider = Provider<PricingRepository>((ref) {
  return PricingRepositoryImpl(ref.watch(dioProvider));
});
