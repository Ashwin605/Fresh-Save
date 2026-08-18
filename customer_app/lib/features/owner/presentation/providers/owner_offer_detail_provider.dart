import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_offer_models.dart';
import '../../data/repositories/owner_offer_repository_provider.dart';

final ownerOfferDetailProvider = FutureProvider.autoDispose
    .family<OwnerOffer, String>((ref, id) async {
      final repository = ref.watch(ownerOfferRepositoryProvider);
      final result = await repository.getOffer(id);

      return result.when(
        success: (data) => data,
        failure: (error) => throw Exception(error.message ?? 'Unknown error'),
      );
    });
