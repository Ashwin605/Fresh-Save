import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';

final adminUsersProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, int>((ref, page) async {
  final repository = ref.watch(adminRepositoryProvider);
  return await repository.getUsers(page: page);
});

final suspendUserProvider = FutureProvider.family.autoDispose<void, Map<String, String>>((ref, args) async {
  final repository = ref.watch(adminRepositoryProvider);
  await repository.suspendUser(args['id']!, args['reason']!);
});
