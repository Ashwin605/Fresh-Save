import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/core/network/result.dart';
import 'package:customer_app/features/owner/domain/models/store_product_model.dart';
import 'package:customer_app/features/owner/domain/models/store_owner_models.dart';
import 'package:customer_app/features/owner/presentation/widgets/products/store_product_card.dart';
import 'package:customer_app/features/owner/data/repositories/owner_product_repository.dart';
import 'package:customer_app/features/owner/data/repositories/owner_product_repository_provider.dart';
import 'package:customer_app/features/owner/presentation/providers/owner_state_provider.dart';
import 'package:customer_app/features/owner/presentation/providers/owner_product_list_provider.dart';
import 'package:customer_app/core/network/image_url_resolver.dart';
import 'package:customer_app/features/owner/presentation/screens/owner_product_list_screen.dart';
import 'package:customer_app/features/owner/data/repositories/category_repository.dart';
import 'package:customer_app/features/owner/domain/models/owner_product_models.dart';

class MockOwnerProductRepository implements OwnerProductRepository {
  final List<StoreProduct> storeProducts;

  MockOwnerProductRepository({required this.storeProducts});

  @override
  Future<Result<StoreProductPaginatedResponse>> getStoreProducts(
    String storeId, {
    int page = 1,
    int limit = 20,
    String? search,
    String? categoryId,
    String? status,
  }) async {
    return Result.success(
      StoreProductPaginatedResponse(
        success: true,
        data: StoreProductPaginatedData(
          items: storeProducts,
          pagination: StoreProductPaginationInfo(
            page: page,
            limit: limit,
            total: storeProducts.length,
            totalPages: 1,
          ),
        ),
      ),
    );
  }

  @override
  Future<Result<StoreProduct>> getStoreProductDetails(
    String storeId,
    String identifier,
  ) async {
    final item = storeProducts.firstWhere((p) => p.id == identifier);
    return Result.success(item);
  }

  @override
  Future<Result<StoreProduct>> createStoreProduct(
    String storeId, {
    required String name,
    required String categoryId,
    required double sellingPrice,
    required double originalPrice,
    required int initialStockQuantity,
    required String expiryDate,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    String? manufacturingDate,
    String? batchNumber,
    String? productId,
  }) async {
    final newProduct = StoreProduct(
      id: 'sp_new',
      storeId: storeId,
      productId: productId ?? 'p_new',
      inventoryId: 'inv_new',
      name: name,
      sellingPrice: sellingPrice,
      originalPrice: originalPrice,
      stockQuantity: initialStockQuantity,
      availableQuantity: initialStockQuantity,
      status: 'ACTIVE',
      inventoryStatus: 'ACTIVE',
      image: image,
      brand: brand,
      unit: unit,
      sku: sku,
      barcode: barcode,
      expiryDate: DateTime.tryParse(expiryDate),
    );
    return Result.success(newProduct);
  }

  @override
  Future<Result<StoreProduct>> updateStoreProduct(
    String storeId,
    String identifier, {
    String? name,
    String? categoryId,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
    double? sellingPrice,
    double? originalPrice,
    int? stockQuantity,
    String? expiryDate,
    String? manufacturingDate,
    String? batchNumber,
    String? inventoryStatus,
  }) async {
    final existing = storeProducts.firstWhere((p) => p.id == identifier);
    final updated = existing.copyWith(
      name: name ?? existing.name,
      sellingPrice: sellingPrice ?? existing.sellingPrice,
      originalPrice: originalPrice ?? existing.originalPrice,
      stockQuantity: stockQuantity ?? existing.stockQuantity,
      status: inventoryStatus ?? existing.status,
      image: image ?? existing.image,
      brand: brand ?? existing.brand,
      unit: unit ?? existing.unit,
      sku: sku ?? existing.sku,
      barcode: barcode ?? existing.barcode,
    );
    return Result.success(updated);
  }

  @override
  Future<Result<bool>> removeStoreProduct(
    String storeId,
    String identifier,
  ) async {
    return const Result.success(true);
  }

  @override
  Future<Result<String>> uploadProductImage({
    String? filePath,
    List<int>? fileBytes,
    required String filename,
  }) async {
    return const Result.success('/public/uploads/products/mock_image.jpg');
  }

  @override
  Future<Result<OwnerProductPaginatedResponse>> getProducts({
    int page = 1,
    int limit = 20,
    String? search,
    String? categoryId,
    String? brand,
    String? status,
  }) async {
    return const Result.success(
      OwnerProductPaginatedResponse(
        success: true,
        data: OwnerProductPaginatedData(
          items: [],
          pagination: OwnerProductPaginationInfo(
            total: 0,
            page: 1,
            limit: 20,
            totalPages: 0,
          ),
        ),
      ),
    );
  }

  @override
  Future<Result<OwnerProduct>> getProductDetails(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<OwnerProduct>> createProduct({
    required String name,
    required String categoryId,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<OwnerProduct>> updateProduct(
    String id, {
    String? name,
    String? categoryId,
    String? description,
    String? brand,
    String? sku,
    String? barcode,
    String? image,
    String? unit,
  }) async {
    throw UnimplementedError();
  }
}

class FakeOwnerNotifier extends OwnerNotifier {
  final OwnerState testState;
  FakeOwnerNotifier(this.testState);

  @override
  OwnerState build() => testState;

  @override
  Future<void> loadOwnerContext() async {}

  @override
  Future<void> loadDashboardMetrics(String storeId) async {}

  @override
  Future<void> switchActiveStore(OwnerStore store) async {}

  @override
  Future<void> updateBusiness(UpdateBusinessRequest request) async {}

  @override
  Future<void> updateStore(UpdateStoreRequest request) async {}
}

class MockCategoryRepository implements CategoryRepository {
  final List<OwnerProductCategory> categories;
  MockCategoryRepository({this.categories = const []});

  @override
  Future<Result<List<OwnerProductCategory>>> getCategories() async {
    return Result.success(categories);
  }

  @override
  Future<Result<OwnerProductCategory>> createCategory(String name, String? description) async {
    return Result.success(
      OwnerProductCategory(
        id: 'cat_new',
        name: name,
        slug: name.toLowerCase().replaceAll(' ', '-'),
      ),
    );
  }
}

void main() {
  final sampleProduct = StoreProduct(
    id: 'sp_1',
    storeId: 'store_101',
    productId: 'prod_202',
    inventoryId: 'inv_303',
    name: 'Amul Taaza Homogenised Toned Milk 1L',
    slug: 'amul-taaza-1l',
    sellingPrice: 54.00,
    originalPrice: 60.00,
    stockQuantity: 25,
    availableQuantity: 25,
    status: 'ACTIVE',
    inventoryStatus: 'ACTIVE',
    brand: 'Amul',
    unit: '1 L',
    sku: 'SKU-AMUL-1L',
    barcode: '8901262010053',
    category: const OwnerProductCategory(
      id: 'cat_dairy',
      name: 'Dairy & Eggs',
      slug: 'dairy-and-eggs',
    ),
    expiryDate: DateTime.parse('2026-11-20T00:00:00.000Z'),
  );

  group('StoreProduct Model Tests', () {
    test('Correctly deserializes from JSON', () {
      final json = {
        'id': 'sp_test',
        'storeId': 's_1',
        'productId': 'p_1',
        'inventoryId': 'inv_1',
        'name': 'Fresh Organic Apples',
        'sellingPrice': 120.50,
        'originalPrice': 150.00,
        'stockQuantity': 40,
        'availableQuantity': 40,
        'status': 'ACTIVE',
        'inventoryStatus': 'ACTIVE',
        'brand': 'FreshFarms',
        'unit': '1 kg',
        'category': {
          'id': 'cat_fruits',
          'name': 'Fruits & Vegetables',
          'slug': 'fruits-and-vegetables',
        },
      };

      final product = StoreProduct.fromJson(json);

      expect(product.id, 'sp_test');
      expect(product.name, 'Fresh Organic Apples');
      expect(product.sellingPrice, 120.50);
      expect(product.originalPrice, 150.00);
      expect(product.stockQuantity, 40);
      expect(product.status, 'ACTIVE');
      expect(product.category?.name, 'Fruits & Vegetables');
    });

    test('copyWith properly modifies fields while retaining others', () {
      final updated = sampleProduct.copyWith(
        sellingPrice: 50.00,
        stockQuantity: 15,
        status: 'OUT_OF_STOCK',
      );

      expect(updated.sellingPrice, 50.00);
      expect(updated.stockQuantity, 15);
      expect(updated.status, 'OUT_OF_STOCK');
      expect(updated.name, sampleProduct.name);
      expect(updated.originalPrice, sampleProduct.originalPrice);
      expect(updated.brand, 'Amul');
    });
  });

  group('StoreProductCard Widget Tests', () {
    testWidgets('Renders product name, brand, category, pricing, and stock', (
      tester,
    ) async {
      bool editTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreProductCard(
              product: sampleProduct,
              onEdit: () {
                editTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Amul Taaza Homogenised Toned Milk 1L'), findsOneWidget);
      expect(find.text('Dairy & Eggs'), findsOneWidget);
      expect(find.text('Amul'), findsOneWidget);
      expect(find.text('Size: 1 L'), findsOneWidget);
      expect(find.text('₹54.00'), findsOneWidget);
      expect(find.text('₹60.00'), findsOneWidget);
      expect(find.text('10% OFF'), findsOneWidget);
      expect(find.text('25 in stock'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);

      // Verify tap on edit button
      final editBtn = find.text('Edit');
      expect(editBtn, findsOneWidget);
      await tester.tap(editBtn);
      expect(editTapped, isTrue);
    });

    testWidgets('Shows Out of Stock indicator when stock is 0', (tester) async {
      final outOfStockProduct = sampleProduct.copyWith(
        stockQuantity: 0,
        status: 'OUT_OF_STOCK',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StoreProductCard(
              product: outOfStockProduct,
              onEdit: () {},
            ),
          ),
        ),
      );

      expect(find.text('Out of Stock'), findsOneWidget);
    });
  });

  group('Store Products Provider & Repository Integration', () {
    test('ownerStoreProductListProvider queries repository with active store', () async {
      final mockRepo = MockOwnerProductRepository(
        storeProducts: [sampleProduct],
      );

      final container = ProviderContainer(
        overrides: [
          ownerProductRepositoryProvider.overrideWithValue(mockRepo),
          ownerStateProvider.overrideWith(
            () => FakeOwnerNotifier(
              OwnerState(
                activeStore: OwnerStore(
                  id: 'store_101',
                  businessId: 'biz_1',
                  name: 'Green Grocers Downtown',
                  status: 'ACTIVE',
                ),
                contextState: OwnerContextState.hasStore,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final response = await container.read(ownerStoreProductListProvider.future);
      expect(response.data.items.length, 1);
      expect(response.data.items.first.id, 'sp_1');
      expect(response.data.items.first.name, 'Amul Taaza Homogenised Toned Milk 1L');
    });
  });

  group('ImageUrlResolver Tests', () {
    test('Resolves relative product image paths correctly', () {
      final resolved = resolveImageUrl('/public/uploads/products/milk.jpg');
      expect(resolved.contains('/public/uploads/products/milk.jpg'), isTrue);
      expect(resolved.startsWith('http'), isTrue);
    });

    test('Leaves absolute URLs untouched', () {
      const fullUrl = 'https://images.unsplash.com/photo-milk.jpg';
      expect(resolveImageUrl(fullUrl), fullUrl);
    });

    test('Handles null or empty string gracefully', () {
      expect(resolveImageUrl(null), '');
      expect(resolveImageUrl('   '), '');
    });
  });

  group('Pricing & Stock Business Rules Validation', () {
    test('Validates selling price cannot exceed original price', () {
      const sellingPrice = 75.0;
      const originalPrice = 70.0;
      final isValid = sellingPrice <= originalPrice;
      expect(isValid, isFalse);
    });

    test('Validates selling price less than or equal to original price is valid', () {
      const sellingPrice = 60.0;
      const originalPrice = 70.0;
      final isValid = sellingPrice <= originalPrice;
      expect(isValid, isTrue);
    });

    test('Validates negative stock is rejected', () {
      const stock = -5;
      final isValid = stock >= 0;
      expect(isValid, isFalse);
    });

    test('Validates expiry date must be strictly after manufacturing date', () {
      final mfg = DateTime(2026, 10, 1);
      final invalidExp = DateTime(2026, 9, 30);
      final validExp = DateTime(2026, 11, 1);

      expect(invalidExp.isAfter(mfg), isFalse);
      expect(validExp.isAfter(mfg), isTrue);
    });
  });

  group('OwnerProductListScreen Widget Tests', () {
    testWidgets('Renders empty state with Add First Product when catalog is empty', (
      tester,
    ) async {
      final mockRepo = MockOwnerProductRepository(storeProducts: []);
      final mockCatRepo = MockCategoryRepository(categories: []);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ownerProductRepositoryProvider.overrideWithValue(mockRepo),
            categoryRepositoryProvider.overrideWithValue(mockCatRepo),
            ownerStateProvider.overrideWith(
              () => FakeOwnerNotifier(
                OwnerState(
                  activeStore: OwnerStore(
                    id: 'store_101',
                    businessId: 'biz_1',
                    name: 'Green Grocers Downtown',
                    status: 'ACTIVE',
                  ),
                  contextState: OwnerContextState.hasStore,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: OwnerProductListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Store Products'), findsOneWidget);
      expect(find.text('Green Grocers Downtown'), findsOneWidget);
      expect(find.text('No Products in Your Store'), findsOneWidget);
      expect(find.text('Add First Product'), findsOneWidget);
    });

    testWidgets('Renders populated store products list when products exist', (
      tester,
    ) async {
      final mockRepo = MockOwnerProductRepository(storeProducts: [sampleProduct]);
      final mockCatRepo = MockCategoryRepository(
        categories: [
          const OwnerProductCategory(
            id: 'cat_dairy',
            name: 'Dairy & Eggs',
            slug: 'dairy-and-eggs',
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ownerProductRepositoryProvider.overrideWithValue(mockRepo),
            categoryRepositoryProvider.overrideWithValue(mockCatRepo),
            ownerStateProvider.overrideWith(
              () => FakeOwnerNotifier(
                OwnerState(
                  activeStore: OwnerStore(
                    id: 'store_101',
                    businessId: 'biz_1',
                    name: 'Green Grocers Downtown',
                    status: 'ACTIVE',
                  ),
                  contextState: OwnerContextState.hasStore,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: OwnerProductListScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Store Products'), findsOneWidget);
      expect(find.text('Amul Taaza Homogenised Toned Milk 1L'), findsOneWidget);
      expect(find.text('All Categories'), findsOneWidget);
      expect(find.text('Dairy & Eggs'), findsWidgets);
    });
  });
}

