import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/features/home/presentation/screens/offers_screen.dart';
import 'package:customer_app/features/home/presentation/providers/home_providers.dart';
import 'package:customer_app/features/home/domain/models/home_models.dart';
import 'package:customer_app/features/coupons/domain/models/coupon.dart';
import 'package:customer_app/features/coupons/presentation/providers/coupon_providers.dart';
import 'package:customer_app/features/details/domain/models/customer_product_detail.dart';
import 'package:customer_app/features/details/domain/models/details_models.dart';
import 'package:customer_app/features/details/presentation/providers/details_providers.dart';
import 'package:customer_app/features/details/presentation/screens/product_details_screen.dart';
import 'package:customer_app/features/home/presentation/widgets/budget_price_tiles.dart';
import 'package:customer_app/features/home/presentation/widgets/product_catalogue_section.dart';
import 'package:customer_app/features/search/presentation/screens/search_screen.dart';
import 'package:customer_app/features/search/presentation/providers/search_provider.dart';
import 'package:customer_app/features/search/domain/models/search_state.dart';
import 'package:customer_app/core/widgets/chips_badges/expiry_badge.dart';
import 'package:customer_app/core/widgets/domain/stock_indicator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Customer Shopping Experience Tests', () {
    testWidgets('OffersScreen displays Deals and toggles to Coupons with copy action', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const testDeal = Deal(
        id: 'deal-1',
        productName: 'Organic Alphonso Mangoes',
        storeName: 'Green Mart Supermarket',
        storeId: 'store-1',
        originalPrice: 200.0,
        discountedPrice: 120.0,
        discountPercent: 40.0,
        expiryStatus: ExpiryStatus.fresh,
        stockStatus: StockStatus.available,
        distance: 1.2,
      );

      final testCoupon = Coupon(
        id: 'coupon-1',
        code: 'SAVE50',
        title: 'Flat ₹50 Off on Fresh Produce',
        description: 'Valid on orders above ₹299',
        discountType: 'FIXED_AMOUNT',
        discountValue: 50.0,
        minimumOrderAmount: 299.0,
        expiryDate: DateTime.now().add(const Duration(days: 7)),
        shop: const ShopInfo(id: 'store-1', name: 'Green Mart Supermarket'),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyDealsProvider.overrideWith((ref) => Future.value([testDeal])),
            availableCouponsProvider.overrideWith((ref) => Future.value([testCoupon])),
          ],
          child: const MaterialApp(
            home: OffersScreen(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify Header and Segmented Control
      expect(find.text('Offers & Deals'), findsOneWidget);
      expect(find.text('Product Deals'), findsOneWidget);
      expect(find.text('Coupons & Vouchers'), findsOneWidget);

      // Verify Product Deals list is visible by default
      expect(find.text('Organic Alphonso Mangoes'), findsOneWidget);
      expect(find.text('Green Mart Supermarket'), findsOneWidget);

      // Tap Coupons Segment
      await tester.tap(find.text('Coupons & Vouchers'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify Coupons view is now visible
      expect(find.text('SAVE50'), findsOneWidget);
      expect(find.text('Flat ₹50 Off on Fresh Produce'), findsOneWidget);
      expect(find.byIcon(Icons.copy_rounded), findsOneWidget);
      expect(find.text('Terms & conditions'), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('ProductDetailsScreen renders product info, store availability, and updates reserve total', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final detail = CustomerProductDetail(
        product: const ProductDetail(
          id: 'prod-123',
          name: 'Amul Taaza Homogenised Toned Milk',
          brand: 'Amul',
          unit: '1 Litre',
          description: 'Rich toned milk with essential calcium and vitamins.',
        ),
        inventory: [
          ProductInventoryOption(
            id: 'inv-1',
            stockQuantity: 10,
            reservedQuantity: 2,
            sellingPrice: 72.0,
            originalPrice: 80.0,
            discountedPrice: 65.0,
            discountValue: 18.75,
            discountType: 'PERCENTAGE',
            expiryDate: DateTime.now().add(const Duration(days: 3)),
            storeId: 'store-1',
            storeName: 'Sunrise Grocery Store',
            storeAddress: '14 MG Road',
            storeCity: 'Bangalore',
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerProductDetailsProvider('prod-123').overrideWith((ref) => Future.value(detail)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ProductDetailsScreen(productId: 'prod-123'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify Product Name, Brand, Unit, and Store
      expect(find.text('Amul Taaza Homogenised Toned Milk'), findsOneWidget);
      expect(find.text('AMUL'), findsOneWidget);
      expect(find.text('1 Litre'), findsOneWidget);
      expect(find.text('Sunrise Grocery Store'), findsOneWidget);

      // Verify In Stock indicator (10 - 2 = 8 available)
      expect(find.text('8 in stock'), findsOneWidget);

      // Verify Pricing display
      expect(find.text('₹65'), findsOneWidget);
      expect(find.text('₹80'), findsOneWidget);

      // Initial Reserve Button should show total for quantity 1 (₹65)
      expect(find.text('Reserve Now • ₹65'), findsOneWidget);

      // Increment quantity
      final plusButton = find.byIcon(Icons.add);
      expect(plusButton, findsOneWidget);
      await tester.tap(plusButton);
      await tester.pump();

      // Quantity should now be 2, button text should update to ₹130
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Reserve Now • ₹130'), findsOneWidget);

      // Decrement quantity back to 1
      final minusButton = find.byIcon(Icons.remove);
      expect(minusButton, findsOneWidget);
      await tester.tap(minusButton);
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('Reserve Now • ₹65'), findsOneWidget);
    });

    testWidgets('ProductDetailsScreen displays Out of Stock card when inventory is zero', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const outOfStockDetail = CustomerProductDetail(
        product: ProductDetail(
          id: 'prod-out',
          name: 'Farm Fresh Organic Eggs',
          brand: 'Eggy Farm',
          unit: 'Pack of 6',
          description: 'Nutritious farm fresh eggs.',
        ),
        inventory: [],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            customerProductDetailsProvider('prod-out').overrideWith((ref) => Future.value(outOfStockDetail)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ProductDetailsScreen(productId: 'prod-out'),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Currently Out of Stock'), findsOneWidget);
      expect(find.text('Search Nearby Deals'), findsOneWidget);
    });

    testWidgets('BudgetPriceTilesSection renders curated price points (₹29, ₹49, ₹69, ₹99)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BudgetPriceTilesSection(),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('₹29'), findsOneWidget);
      expect(find.text('₹49'), findsOneWidget);
      expect(find.text('₹69'), findsOneWidget);
      expect(find.text('₹99'), findsOneWidget);
      expect(find.text('STORE'), findsNWidgets(4));
    });

    testWidgets('SearchScreen renders empty state when query returns no items', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchProvider.overrideWith(
              () => _TestSearchNotifier(
                const SearchState(
                  query: 'DragonFruit',
                  status: SearchStatus.empty,
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialQuery: 'DragonFruit'),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
      expect(find.text('Clear Search'), findsOneWidget);
    });

    testWidgets('SearchScreen renders Deals when matching items found', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const testDeal = Deal(
        id: 'deal-mango',
        productName: 'Fresh Mango Alphonso',
        storeName: 'QuickMart',
        storeId: 'store-qm',
        originalPrice: 150.0,
        discountedPrice: 99.0,
        discountPercent: 34.0,
        expiryStatus: ExpiryStatus.fresh,
        stockStatus: StockStatus.available,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            searchProvider.overrideWith(
              () => _TestSearchNotifier(
                const SearchState(
                  query: 'Mango',
                  status: SearchStatus.results,
                  deals: [testDeal],
                ),
              ),
            ),
          ],
          child: const MaterialApp(
            home: SearchScreen(initialQuery: 'Mango'),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Deals'), findsOneWidget);
      expect(find.text('Fresh Mango Alphonso'), findsOneWidget);
    });

    testWidgets('ProductCatalogueSection renders ReferenceProductCard with price badge, strikethrough, and coin indicator', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      const testDeal = Deal(
        id: 'deal-cat',
        productName: 'Britannia Good Day Butter Biscuits',
        storeName: 'Royal Mart',
        storeId: 'store-rm',
        originalPrice: 40.0,
        discountedPrice: 30.0,
        discountPercent: 25.0,
        expiryStatus: ExpiryStatus.fresh,
        stockStatus: StockStatus.available,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            nearbyDealsProvider.overrideWith((ref) => Future.value([testDeal])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: ProductCatalogueSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('Product Catalogue'), findsOneWidget);
      expect(find.text('Britannia Good Day Butter Biscuits'), findsOneWidget);
      expect(find.text('+ ADD'), findsOneWidget);
      expect(find.text('₹30'), findsOneWidget);
      expect(find.text('₹40'), findsOneWidget);
      expect(find.text('25% off'), findsOneWidget);
      expect(find.text('Earn 3 coins'), findsOneWidget);
    });
  });
}

class _TestSearchNotifier extends SearchNotifier {
  final SearchState _initial;
  _TestSearchNotifier(this._initial);

  @override
  SearchState build() => _initial;

  @override
  void executeSearch(String query, {double? maxPrice}) {}
}
