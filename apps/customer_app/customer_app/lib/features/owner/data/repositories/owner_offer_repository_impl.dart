import 'package:dio/dio.dart';

import '../../../../core/network/result.dart';
import '../../../../core/network/app_error.dart';
import '../../domain/models/owner_offer_models.dart';
import 'owner_offer_repository.dart';

class OwnerOfferRepositoryImpl implements OwnerOfferRepository {
  final Dio _dioClient;

  OwnerOfferRepositoryImpl(this._dioClient);

  @override
  Future<Result<OwnerOfferPaginatedResponse>> getOffers(
    String storeId, {
    OfferStatus? status,
    String? productId,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
      };

      if (status != null) {
        // Map enum back to string
        final statusStr = status.toString().split('.').last.toUpperCase();
        queryParams['status'] = statusStr;
      }
      if (productId != null && productId.isNotEmpty) {
        queryParams['productId'] = productId;
      }

      final response = await _dioClient.get(
        '/stores/$storeId/offers',
        queryParameters: queryParams,
      );

      return Result.success(
        OwnerOfferPaginatedResponse.fromJson(response.data),
      );
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerOffer>> getOffer(String id) async {
    try {
      final response = await _dioClient.get('/offers/$id');
      return Result.success(OwnerOffer.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerOffer>> createOffer(
    String inventoryId,
    CreateOfferRequest request,
  ) async {
    try {
      final response = await _dioClient.post(
        '/inventory/$inventoryId/offers',
        data: request.toJson(),
      );
      return Result.success(OwnerOffer.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerOffer>> updateOffer(
    String id,
    UpdateOfferRequest request,
  ) async {
    try {
      final response = await _dioClient.patch(
        '/offers/$id',
        data: request.toJson(),
      );
      return Result.success(OwnerOffer.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerOffer>> activateOffer(String id) async {
    try {
      final response = await _dioClient.post('/offers/$id/activate');
      return Result.success(OwnerOffer.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerOffer>> pauseOffer(String id) async {
    try {
      final response = await _dioClient.post('/offers/$id/pause');
      return Result.success(OwnerOffer.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<OwnerOffer>> cancelOffer(String id) async {
    try {
      final response = await _dioClient.post('/offers/$id/cancel');
      return Result.success(OwnerOffer.fromJson(response.data));
    } on DioException catch (e) {
      return Result.failure(
        AppError.unknown(message: e.message ?? e.toString()),
      );
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
