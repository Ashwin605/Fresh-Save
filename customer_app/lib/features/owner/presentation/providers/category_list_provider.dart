import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../domain/models/owner_product_models.dart';
import '../../data/repositories/category_repository.dart';

class CategoryListState {
  final bool isLoading;
  final String? error;
  final List<OwnerProductCategory> categories;

  const CategoryListState({
    this.isLoading = false,
    this.error,
    this.categories = const [],
  });

  CategoryListState copyWith({
    bool? isLoading,
    String? error,
    List<OwnerProductCategory>? categories,
  }) {
    return CategoryListState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      categories: categories ?? this.categories,
    );
  }
}

class CategoryListNotifier extends Notifier<CategoryListState> {
  @override
  CategoryListState build() {
    Future.microtask(() => loadCategories());
    return const CategoryListState();
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);
    
    final result = await ref.read(categoryRepositoryProvider).getCategories();
    
    if (result is Success<List<OwnerProductCategory>>) {
      state = state.copyWith(isLoading: false, categories: result.data);
    } else if (result is Failure<List<OwnerProductCategory>>) {
      state = state.copyWith(isLoading: false, error: result.error.message);
    }
  }

  Future<OwnerProductCategory?> createCategory(String name, String? description) async {
    final result = await ref.read(categoryRepositoryProvider).createCategory(name, description);
    
    if (result is Success<OwnerProductCategory>) {
      // Add to list and sort
      final newCategories = List<OwnerProductCategory>.from(state.categories)..add(result.data);
      newCategories.sort((a, b) => a.name.compareTo(b.name));
      state = state.copyWith(categories: newCategories);
      return result.data;
    }
    return null;
  }
}

final categoryListProvider = NotifierProvider<CategoryListNotifier, CategoryListState>(() {
  return CategoryListNotifier();
});
