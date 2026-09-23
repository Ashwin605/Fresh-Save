import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';

final adminProductsProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getProducts(page: params['page'] ?? 1, limit: params['limit'] ?? 20);
});