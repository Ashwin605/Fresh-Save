import '../../../../core/network/result.dart';
import '../../domain/models/owner_offer_models.dart';

abstract class OwnerOfferRepository {
  Future<Result<OwnerOfferPaginatedResponse>> getOffers(
    String storeId, {
    OfferStatus? status,
    String? productId,
    String sortBy = 'createdAt',
    String sortOrder = 'desc',
    int page = 1,
    int limit = 20,
  });

  Future<Result<OwnerOffer>> getOffer(String id);

  Future<Result<OwnerOffer>> createOffer(
    String inventoryId,
    CreateOfferRequest request,
  );

  Future<Result<OwnerOffer>> updateOffer(String id, UpdateOfferRequest request);

  Future<Result<OwnerOffer>> activateOffer(String id);
  Future<Result<OwnerOffer>> pauseOffer(String id);
  Future<Result<OwnerOffer>> cancelOffer(String id);
}
