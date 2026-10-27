import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:customer_app/features/home/presentation/widgets/main_category_cards.dart';
import 'package:customer_app/features/home/presentation/providers/home_providers.dart';
import 'package:customer_app/features/home/domain/models/home_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MainCategoryCards Widget Tests', () {
    const testFoodCategory = Category(
      id: '00d6248a-2a48-4293-aba9-c84f41978a52',
      name: 'Food',
      slug: 'food',
      children: [
        Category(
          id: '34be788d-d49c-48e2-bbb2-16124e835ea3',
          name: 'Dairy',
          slug: 'dairy',
        ),
      ],
    );

    const testProduceCategory = Category(
      id: '4c70c147-17ce-4795-8c70-e0b4bfc9c0f8',
      name: 'Produce',
      slug: 'produce',
      children: [
        Category(
          id: '3213bf46-213a-4155-a24d-54c5fa18fa84',
          name: 'Fruits',
          slug: 'fruits',
        ),
      ],
    );

    const testClothingCategory = Category(
      id: 'clothing-1234-5678-90ab',
      name: 'Clothing',
      slug: 'clothing',
    );

    testWidgets('Renders all three main category cards: Groceries, Clothing, Food', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWith((ref) => Future.value([
              testFoodCategory,
              testProduceCategory,
            ])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: MainCategoryCards(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);

      expect(find.byKey(const Key('main_category_groceries')), findsOneWidget);
      expect(find.byKey(const Key('main_category_clothing')), findsOneWidget);
      expect(find.byKey(const Key('main_category_food')), findsOneWidget);
    });

    testWidgets('Tapping Food navigates to /category/00d6248a-2a48-4293-aba9-c84f41978a52', (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: MainCategoryCards(),
            ),
          ),
          GoRoute(
            path: '/category/:id',
            builder: (context, state) {
              navigatedRoute = '/category/${state.pathParameters['id']}';
              return const Scaffold(body: Text('Category Screen'));
            },
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) {
              navigatedRoute = '/search?query=${state.uri.queryParameters['query']}';
              return const Scaffold(body: Text('Search Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWith((ref) => Future.value([
              testFoodCategory,
              testProduceCategory,
            ])),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('main_category_food')));
      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/category/00d6248a-2a48-4293-aba9-c84f41978a52'));
    });

    testWidgets('Tapping Groceries navigates to existing category id or fallback query', (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: MainCategoryCards(),
            ),
          ),
          GoRoute(
            path: '/category/:id',
            builder: (context, state) {
              navigatedRoute = '/category/${state.pathParameters['id']}';
              return const Scaffold(body: Text('Category Screen'));
            },
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) {
              navigatedRoute = '/search?query=${state.uri.queryParameters['query']}';
              return const Scaffold(body: Text('Search Screen'));
            },
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWith((ref) => Future.value([
              testFoodCategory,
              testProduceCategory,
            ])),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('main_category_groceries')));
      await tester.pumpAndSettle();

      // Groceries resolved to testProduceCategory
      expect(navigatedRoute, equals('/category/4c70c147-17ce-4795-8c70-e0b4bfc9c0f8'));
    });

    testWidgets('Tapping Clothing navigates to category when present or search fallback', (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: MainCategoryCards(),
            ),
          ),
          GoRoute(
            path: '/category/:id',
            builder: (context, state) {
              navigatedRoute = '/category/${state.pathParameters['id']}';
              return const Scaffold(body: Text('Category Screen'));
            },
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) {
              navigatedRoute = '/search?query=${state.uri.queryParameters['query']}';
              return const Scaffold(body: Text('Search Screen'));
            },
          ),
        ],
      );

      // Case 1: Clothing not in DB -> search fallback
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWith((ref) => Future.value([
              testFoodCategory,
              testProduceCategory,
            ])),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('main_category_clothing')));
      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/search?query=Clothing'));
    });

    testWidgets('Tapping Clothing navigates to category route when Clothing is present in DB', (tester) async {
      String? navigatedRoute;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(
              body: MainCategoryCards(),
            ),
          ),
          GoRoute(
            path: '/category/:id',
            builder: (context, state) {
              navigatedRoute = '/category/${state.pathParameters['id']}';
              return const Scaffold(body: Text('Category Screen'));
            },
          ),
        ],
      );

      // Case 2: Clothing is present in DB
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWith((ref) => Future.value([
              testFoodCategory,
              testProduceCategory,
              testClothingCategory,
            ])),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('main_category_clothing')));
      await tester.pumpAndSettle();

      expect(navigatedRoute, equals('/category/clothing-1234-5678-90ab'));
    });

    testWidgets('No horizontal overflow on small mobile screen width (320px)', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWith((ref) => Future.value([
              testFoodCategory,
              testProduceCategory,
            ])),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: MainCategoryCards(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Clothing'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
    });
  });
}
