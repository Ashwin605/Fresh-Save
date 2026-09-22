import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/repositories/inventory_repository_impl.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final client = ref.watch(dioProvider);
  return InventoryRepositoryImpl(client);
});
