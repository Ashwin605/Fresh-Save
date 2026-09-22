import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import '../../data/repositories/owner_product_repository_provider.dart';

final ownerProductDetailProvider = FutureProvider.autoDispose
    .family<OwnerProduct, String>((ref, id) async {
      final repository = ref.watch(ownerProductRepositoryProvider);

      final result = await repository.getProductDetails(id);

      return result.when(
        success: (data) => data,
        failure: (error) => throw Exception(error.message ?? 'Unknown error'),
      );
    });
