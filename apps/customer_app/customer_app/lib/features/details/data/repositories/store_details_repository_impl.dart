import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../../home/domain/models/home_models.dart';

abstract class StoreDetailsRepository {
  Future<Result<List<Deal>>> getStoreDeals(
    String storeId, {
    required int page,
    required int limit,
    double? lat,
    double? lng,
  });
}

class StoreDetailsRepositoryImpl implements StoreDetailsRepository {
  final Dio _dio;

  StoreDetailsRepositoryImpl(this._dio);

  @override
  Future<Result<List<Deal>>> getStoreDeals(
    String storeId, {
    required int page,
    required int limit,
    double? lat,
    double? lng,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'storeId': storeId,
        'page': page,
        'limit': limit,
      };

      // If location is provided, backend can calculate distance
      if (lat != null && lng != null) {
        queryParams['latitude'] = lat;
        queryParams['longitude'] = lng;
      }

      final response = await _dio.get(
        '/discovery/deals/nearby',
        queryParameters: queryParams,
      );

      final inner = response.data['data'] as Map<String, dynamic>?;
      final items = inner?['items'] as List?;
      if (items == null || items.isEmpty) return const Result.success([]);
      final deals = items.map((json) => Deal.fromJson(json)).toList();
      return Success(deals);
    } on DioException catch (e) {
      return Failure(AppError.network(message: e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }
}

final storeDetailsRepositoryProvider = Provider<StoreDetailsRepository>((ref) {
  return StoreDetailsRepositoryImpl(ref.watch(dioProvider));
});
