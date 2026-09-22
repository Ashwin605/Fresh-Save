import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/details_models.dart';

abstract class DetailsRepository {
  Future<Result<DealDetail>> getDealDetail(
    String offerId, {
    double? lat,
    double? lng,
  });
  Future<Result<ProductDetail>> getProductDetail(String productId);
}

class DetailsRepositoryImpl implements DetailsRepository {
  final Dio _dio;

  DetailsRepositoryImpl(this._dio);

  @override
  Future<Result<DealDetail>> getDealDetail(
    String offerId, {
    double? lat,
    double? lng,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (lat != null && lng != null) {
        queryParams['latitude'] = lat;
        queryParams['longitude'] = lng;
      }

      final response = await _dio.get(
        '/discovery/deals/$offerId',
        queryParameters: queryParams,
      );
      return Success(DealDetail.fromJson(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Failure(
          AppError.notFound(
            message: 'Deal not found or is no longer available',
          ),
        );
      }
      return Failure(AppError.network(message: e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<ProductDetail>> getProductDetail(String productId) async {
    try {
      final response = await _dio.get('/products/$productId');
      return Success(ProductDetail.fromJson(response.data));
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Failure(AppError.notFound(message: 'Product not found'));
      }
      return Failure(AppError.network(message: e.message));
    } catch (e) {
      return Failure(AppError.unknown(message: e.toString()));
    }
  }
}

final detailsRepositoryProvider = Provider<DetailsRepository>((ref) {
  return DetailsRepositoryImpl(ref.watch(dioProvider));
});
