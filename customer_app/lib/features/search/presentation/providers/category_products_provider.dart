import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/result.dart';
import '../../../home/domain/models/home_models.dart';
import '../../data/repositories/search_repository_impl.dart';

class CategoryProductsState {
  final bool isLoading;
  final bool isPaginating;
  final List<Product> products;
  final String? errorMessage;
  final int currentPage;
  final bool hasMore;

  const CategoryProductsState({
    this.isLoading = false,
    this.isPaginating = false,
    this.products = const [],
    this.errorMessage,
    this.currentPage = 1,
    this.hasMore = true,
  });

  CategoryProductsState copyWith({
    bool? isLoading,
    bool? isPaginating,
    List<Product>? products,
    String? errorMessage,
    int? currentPage,
    bool? hasMore,
  }) {
    return CategoryProductsState(
      isLoading: isLoading ?? this.isLoading,
      isPaginating: isPaginating ?? this.isPaginating,
      products: products ?? this.products,
      errorMessage: errorMessage, // Note: Setting this allows clearing the error by passing null, but we don't handle clearing correctly here if we omit it. We need to be able to set it to null.
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  CategoryProductsState clearError() {
    return CategoryProductsState(
      isLoading: isLoading,
      isPaginating: isPaginating,
      products: products,
      errorMessage: null,
      currentPage: currentPage,
      hasMore: hasMore,
    );
  }
}

class CategoryProductsNotifier extends Notifier<CategoryProductsState> {
  @override
  CategoryProductsState build() {
    return const CategoryProductsState();
  }

  Future<void> fetchInitial(String categoryId) async {
    print('[3] API REQUEST');
    print('endpoint: /api/v1/discovery/products');
    print('HTTP method: GET');
    print('category ID: $categoryId');
    print('query parameters: {categoryId: $categoryId, page: 1, limit: 20}');

    if (state.isLoading) return;

    state = state.clearError().copyWith(isLoading: true);

    try {
      final result = await ref.read(searchRepositoryProvider).getProductsByCategory(
        categoryId,
        page: 1,
      );

      switch (result) {
        case Success(:final data):
          print('[5] PARSING');
          print('parsed response successfully: true');
          print('number of products: ${data.length}');
          
          state = state.copyWith(
            isLoading: false,
            products: data,
            currentPage: 1,
            hasMore: data.length == 20,
          );
          print('[6] UI STATE');
          print('loading: false, success: true, empty: ${data.isEmpty}, error: false');
          break;
        case Failure(:final error):
          print('[4] API RESPONSE');
          print('status code: error');
          print('response body: ${error.message}');
          print('[7] EXCEPTION');
          print('exception: ${error.message}');
          
          state = state.copyWith(
            isLoading: false,
            errorMessage: error.message,
          );
          print('[6] UI STATE');
          print('loading: false, success: false, empty: true, error: true');
          break;
      }
    } catch (e, st) {
      print('[7] EXCEPTION');
      print('exception: $e');
      print('stack trace: $st');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadMore(String categoryId) async {
    if (state.isLoading || state.isPaginating || !state.hasMore) return;

    state = state.copyWith(isPaginating: true);
    final nextPage = state.currentPage + 1;

    final result = await ref.read(searchRepositoryProvider).getProductsByCategory(
      categoryId,
      page: nextPage,
    );

    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          isPaginating: false,
          products: [...state.products, ...data],
          currentPage: nextPage,
          hasMore: data.length == 20,
        );
        break;
      case Failure():
        state = state.copyWith(isPaginating: false);
        break;
    }
  }

  Future<void> refresh(String categoryId) async {
    await fetchInitial(categoryId);
  }
}

final categoryProductsProvider = NotifierProvider<CategoryProductsNotifier, CategoryProductsState>(
  CategoryProductsNotifier.new,
);
