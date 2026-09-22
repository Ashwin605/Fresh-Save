import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/admin_repository.dart';
import '../../../home/domain/models/home_models.dart';

final adminCategoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  final repository = ref.watch(adminRepositoryProvider);
  final data = await repository.getCategories();
  return data.map((json) => Category.fromJson(json as Map<String, dynamic>)).toList();
});

final updateAdminCategoryProvider = FutureProvider.family.autoDispose<void, Map<String, dynamic>>((ref, args) async {
  final repository = ref.watch(adminRepositoryProvider);
  await repository.updateCategory(
    args['id'] as String,
    image: args['image'] as String?,
    sortOrder: args['sortOrder'] as int?,
    status: args['status'] as String?,
  );
  ref.invalidate(adminCategoriesProvider);
});
