import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/features/admin/presentation/screens/admin_dashboard_screen.dart';
import 'package:customer_app/features/admin/presentation/screens/admin_products_screen.dart';
import 'package:customer_app/features/admin/presentation/screens/admin_shopkeepers_screen.dart';
import 'package:customer_app/features/admin/presentation/screens/admin_stores_screen.dart';
import 'package:customer_app/features/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:customer_app/features/admin/presentation/providers/admin_products_provider.dart';
import 'package:customer_app/features/admin/presentation/providers/admin_shopkeepers_provider.dart';
import 'package:customer_app/features/admin/presentation/providers/admin_stores_provider.dart';

void main() {
  group('Admin Dashboard & Governance Screens Tests', () {
    testWidgets('AdminDashboardScreen displays genuine operational & financial KPI cards', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockMetrics = {
        'orders': {'total': 42, 'completed': 35, 'cancelled': 4, 'pending': 3},
        'revenue': {'gross': 50000, 'discounts': 7500, 'net': 42500},
        'coupons': {'active': 5, 'usage': 28},
        'offers': {'active': 12, 'expired': 4},
        'ratings': {'average': 4.9, 'total': 86, 'fiveStar': 75, 'oneStar': 1},
        'stores': {'total': 18, 'active': 15, 'pendingVerification': 3},
        'shopkeepers': {'total': 12, 'active': 11, 'suspended': 1},
        'products': {'total': 250, 'active': 230, 'inactive': 20},
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminDashboardMetricsProvider.overrideWith((ref) => Future.value(mockMetrics)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: AdminDashboardScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // Verify Page Title
      expect(find.text('Dashboard'), findsWidgets);

      // Verify Operational KPI cards
      expect(find.text('Total Stores'), findsOneWidget);
      expect(find.text('18'), findsOneWidget);

      expect(find.text('Registered Shopkeepers'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);

      expect(find.text('Published Products'), findsOneWidget);
      expect(find.text('230'), findsOneWidget);

      expect(find.text('Active Promotions'), findsOneWidget);
      expect(find.text('17'), findsOneWidget); // 12 offers + 5 coupons

      // Verify Financial KPI cards
      expect(find.text('Total Orders'), findsOneWidget);
      expect(find.text('42'), findsOneWidget);

      expect(find.text('Net Revenue'), findsOneWidget);
      expect(find.text('₹42500'), findsOneWidget);
    });

    testWidgets('AdminProductsScreen displays catalog table, search, and status badges', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockProductsResponse = {
        'data': [
          {
            'id': 'p1',
            'name': 'Organic Whole Milk 1L',
            'brand': 'DairyFarm',
            'sku': 'DF-MILK-1L',
            'barcode': '890123456789',
            'unit': '1 L',
            'status': 'ACTIVE',
            'category': {'id': 'c1', 'name': 'Dairy & Eggs'},
            'createdAt': '2026-10-20T10:00:00.000Z',
            'inventory': [
              {
                'id': 'inv1',
                'sellingPrice': 65,
                'originalPrice': 70,
                'stockQuantity': 40,
                'status': 'ACTIVE',
                'store': {'id': 's1', 'name': 'Fresh Corner'},
              }
            ],
          },
          {
            'id': 'p2',
            'name': 'Artisan Sourdough Loaf',
            'brand': 'BakeHouse',
            'sku': 'BH-SOURDOUGH',
            'status': 'INACTIVE',
            'category': {'id': 'c2', 'name': 'Bakery'},
            'createdAt': '2026-10-21T11:00:00.000Z',
            'inventory': [],
          },
        ],
        'total': 2,
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminProductsProvider(1)
                .overrideWith((ref) => Future.value(mockProductsResponse)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: AdminProductsScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Product Catalog & Governance'), findsOneWidget);
      expect(find.text('Organic Whole Milk 1L'), findsOneWidget);
      expect(find.text('Artisan Sourdough Loaf'), findsOneWidget);
      expect(find.text('ACTIVE'), findsWidgets);
      expect(find.text('INACTIVE'), findsWidgets);
    });

    testWidgets('AdminShopkeepersScreen displays shopkeeper records and status', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockShopkeepersResponse = {
        'data': [
          {
            'id': 'u1',
            'name': 'Alice Sharma',
            'email': 'alice@freshsave.in',
            'phone': '+919876543210',
            'role': 'SHOP_OWNER',
            'status': 'ACTIVE',
            'createdAt': '2026-10-15T08:00:00.000Z',
            'businesses': [
              {
                'id': 'b1',
                'businessName': 'Sharma Grocers',
                'verificationStatus': 'VERIFIED',
                'stores': [
                  {
                    'id': 's1',
                    'name': 'Sharma Mart',
                    'verificationStatus': 'VERIFIED',
                    'address': 'Main Street',
                  }
                ],
              }
            ],
          },
          {
            'id': 'u2',
            'name': 'Bob Mehta',
            'email': 'bob@mehtamart.com',
            'role': 'SHOP_OWNER',
            'status': 'SUSPENDED',
            'createdAt': '2026-10-18T09:30:00.000Z',
            'businesses': [],
          },
        ],
        'total': 2,
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminShopkeepersProvider(1)
                .overrideWith((ref) => Future.value(mockShopkeepersResponse)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: AdminShopkeepersScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Shopkeeper Management'), findsOneWidget);
      expect(find.text('Alice Sharma'), findsOneWidget);
      expect(find.text('Bob Mehta'), findsOneWidget);
      expect(find.text('ACTIVE'), findsWidgets);
      expect(find.text('SUSPENDED'), findsWidgets);
    });

    testWidgets('AdminStoresScreen displays store management table with verification status', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final mockStoresResponse = {
        'data': [
          {
            'id': 'store-1',
            'name': 'Downtown Organic Store',
            'address': '42 Market Road',
            'status': 'ACTIVE',
            'verificationStatus': 'VERIFIED',
            'createdAt': '2026-10-12T12:00:00.000Z',
            'business': {
              'id': 'biz-1',
              'businessName': 'Green Harvest Ltd',
              'owner': {
                'id': 'user-1',
                'name': 'Kavita Singh',
                'email': 'kavita@greenharvest.com',
              },
            },
          },
          {
            'id': 'store-2',
            'name': 'Eastside Fresh Deli',
            'address': '109 Station Ave',
            'status': 'ACTIVE',
            'verificationStatus': 'PENDING',
            'createdAt': '2026-10-22T14:30:00.000Z',
            'business': {
              'id': 'biz-2',
              'businessName': 'Eastside Deli Co',
              'owner': {
                'id': 'user-2',
                'name': 'Ramesh Patel',
                'email': 'ramesh@eastside.com',
              },
            },
          },
        ],
        'total': 2,
      };

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminStoresProvider(1)
                .overrideWith((ref) => Future.value(mockStoresResponse)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: AdminStoresScreen(),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      expect(find.text('Store Management'), findsOneWidget);
      expect(find.text('Downtown Organic Store'), findsOneWidget);
      expect(find.text('Eastside Fresh Deli'), findsOneWidget);
      expect(find.text('VERIFIED'), findsWidgets);
      expect(find.text('PENDING'), findsWidgets);
    });
  });
}
