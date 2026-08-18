import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'owner_offer_repository.dart';
import 'owner_offer_repository_impl.dart';

final ownerOfferRepositoryProvider = Provider<OwnerOfferRepository>((ref) {
  final dioClient = ref.watch(dioProvider);
  return OwnerOfferRepositoryImpl(dioClient);
});
