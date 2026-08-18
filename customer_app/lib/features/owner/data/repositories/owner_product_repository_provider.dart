import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import 'owner_product_repository.dart';
import 'owner_product_repository_impl.dart';

final ownerProductRepositoryProvider = Provider<OwnerProductRepository>((ref) {
  final client = ref.watch(dioProvider);
  return OwnerProductRepositoryImpl(client);
});
