import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/inventory_models.dart';
import '../../data/repositories/inventory_repository_provider.dart';
import '../../../../../core/network/result.dart';

final inventoryDetailProvider = FutureProvider.autoDispose
    .family<OwnerInventoryItem, String>((ref, id) async {
      final repo = ref.watch(inventoryRepositoryProvider);
      final result = await repo.getInventoryDetails(id);
      if (result is Success<OwnerInventoryItem>) {
        return result.data;
      }
      throw Exception((result as Failure).error.message ?? 'Unknown error');
    });
