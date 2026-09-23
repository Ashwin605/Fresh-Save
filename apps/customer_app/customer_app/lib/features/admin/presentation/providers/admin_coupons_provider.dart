import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';

final adminCouponsProvider = FutureProvider.family<dynamic, Map<String, dynamic>>((ref, params) async {
  final repository = ref.read(adminRepositoryProvider);
  return repository.getCoupons(page: params['page'] ?? 1, limit: params['limit'] ?? 20);
});