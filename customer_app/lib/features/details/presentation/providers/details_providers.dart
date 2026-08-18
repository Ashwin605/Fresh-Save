import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../location/presentation/providers/location_provider.dart';
import '../../data/repositories/details_repository_impl.dart';
import '../../domain/models/details_models.dart';

final offerDetailsProvider = FutureProvider.family<DealDetail, String>((
  ref,
  offerId,
) async {
  final repo = ref.watch(detailsRepositoryProvider);
  final locationState = ref.watch(locationProvider);

  final lat = locationState.location?.latitude;
  final lng = locationState.location?.longitude;

  final result = await repo.getDealDetail(offerId, lat: lat, lng: lng);
  if (result is Success<DealDetail>) {
    return result.data;
  } else if (result is Failure<DealDetail>) {
    throw Exception(result.error.message ?? 'Failed to load deal');
  }
  throw Exception('Unknown error');
});

final productDetailsProvider = FutureProvider.family<ProductDetail, String>((
  ref,
  productId,
) async {
  final repo = ref.watch(detailsRepositoryProvider);

  final result = await repo.getProductDetail(productId);
  if (result is Success<ProductDetail>) {
    return result.data;
  } else if (result is Failure<ProductDetail>) {
    throw Exception(result.error.message ?? 'Failed to load product');
  }
  throw Exception('Unknown error');
});
