import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:customer_app/features/owner/domain/models/owner_reservation_models.dart';
import 'package:customer_app/features/owner/data/repositories/owner_reservation_repository_provider.dart';
import 'package:customer_app/features/owner/data/repositories/owner_reservation_repository.dart';
import 'package:customer_app/features/owner/presentation/screens/owner_fulfillment_screen.dart';
import 'package:customer_app/features/owner/presentation/screens/owner_qr_scanner_screen.dart';
import 'package:customer_app/features/owner/presentation/widgets/reservations/pickup_confirmation_sheet.dart';
import 'package:customer_app/features/owner/presentation/providers/owner_state_provider.dart';
import 'package:customer_app/features/owner/domain/models/store_owner_models.dart';
import 'package:customer_app/core/network/result.dart';
import 'package:go_router/go_router.dart';

class MockOwnerReservationRepository extends Mock
    implements OwnerReservationRepository {}

class TestOwnerNotifier extends OwnerNotifier {
  @override
  OwnerState build() {
    return OwnerState(
      activeStore: OwnerStore(
        id: 'store_1',
        businessId: 'b1',
        name: 'Test Store',
        status: 'ACTIVE',
      ),
    );
  }

  @override
  Future<void> loadDashboardMetrics(String storeId) async {}
}

void main() {
  late MockOwnerReservationRepository mockRepository;

  setUp(() {
    mockRepository = MockOwnerReservationRepository();
  });

  Widget createFulfillmentScreen() {
    return ProviderScope(
      overrides: [
        ownerReservationRepositoryProvider.overrideWithValue(mockRepository),
        ownerStateProvider.overrideWith(() => TestOwnerNotifier()),
      ],
      child: const MaterialApp(home: OwnerFulfillmentScreen()),
    );
  }

  Widget createQrScannerScreen({String? initialCode}) {
    final router = GoRouter(
      initialLocation: '/scan',
      routes: [
        GoRoute(
          path: '/scan',
          builder: (context, state) =>
              OwnerQrScannerScreen(initialCode: initialCode),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        ownerReservationRepositoryProvider.overrideWithValue(mockRepository),
        ownerStateProvider.overrideWith(() => TestOwnerNotifier()),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  final testReservationReady = OwnerReservation(
    id: 'res_1',
    reservationCode: 'FS-READY123',
    customerId: 'cust_1',
    storeId: 'store_1',
    status: ReservationStatus.ready,
    totalAmount: 15.0,
    subtotal: 15.0,
    totalDiscount: 0,
    items: [],
    reservedAt: DateTime.now(),
    expiresAt: DateTime.now().add(const Duration(hours: 1)),
  );

  final testReservationExpired = testReservationReady.copyWith(
    status: ReservationStatus.expired,
    reservationCode: 'FS-EXPIRED123',
  );

  final testReservationCompleted = testReservationReady.copyWith(
    status: ReservationStatus.completed,
    reservationCode: 'FS-COMPLETED123',
  );

  final testReservationCancelled = testReservationReady.copyWith(
    status: ReservationStatus.cancelled,
    reservationCode: 'FS-CANCELLED123',
  );

  group('OwnerFulfillmentScreen Tests', () {
    testWidgets('Displays ready reservations and verifies screen structure', (
      tester,
    ) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: any(named: 'storeId'),
          status: ReservationStatus.ready,
          reservationCode: any(named: 'reservationCode'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
          page: any(named: 'page'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer(
        (_) async => Result.success(
          OwnerReservationPaginatedResponse(
            items: [testReservationReady],
            meta: const OwnerReservationPaginationMeta(
              total: 1,
              page: 1,
              limit: 20,
              totalPages: 1,
            ),
          ),
        ),
      );

      await tester.pumpWidget(createFulfillmentScreen());
      await tester.pumpAndSettle();

      expect(find.text('Fulfillment'), findsOneWidget);
      expect(find.text('Scan QR Code'), findsOneWidget);
      expect(find.text('Ready for Pickup'), findsOneWidget);
      expect(find.text('FS-READY123'), findsOneWidget);
    });
  });

  group('OwnerQrScannerScreen Tests', () {
    testWidgets('Valid code shows confirmation sheet', (tester) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: 'store_1',
          reservationCode: 'FS-READY123',
        ),
      ).thenAnswer(
        (_) async => Result.success(
          OwnerReservationPaginatedResponse(
            items: [testReservationReady],
            meta: const OwnerReservationPaginationMeta(
              total: 1,
              page: 1,
              limit: 20,
              totalPages: 1,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        createQrScannerScreen(initialCode: 'FS-READY123'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(PickupConfirmationSheet), findsOneWidget);
      expect(find.text('Complete Pickup?'), findsOneWidget);
    });

    testWidgets('Invalid/Wrong store code shows error', (tester) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: 'store_1',
          reservationCode: 'FS-INVALID123',
        ),
      ).thenAnswer(
        (_) async => Result.success(
          const OwnerReservationPaginatedResponse(
            items: [],
            meta: OwnerReservationPaginationMeta(
              total: 0,
              page: 1,
              limit: 20,
              totalPages: 0,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        createQrScannerScreen(initialCode: 'FS-INVALID123'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.text('Reservation not found or belongs to another store.'),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 2)); // let the timer expire
    });

    testWidgets('Expired reservation shows error', (tester) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: 'store_1',
          reservationCode: 'FS-EXPIRED123',
        ),
      ).thenAnswer(
        (_) async => Result.success(
          OwnerReservationPaginatedResponse(
            items: [testReservationExpired],
            meta: const OwnerReservationPaginationMeta(
              total: 1,
              page: 1,
              limit: 20,
              totalPages: 1,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        createQrScannerScreen(initialCode: 'FS-EXPIRED123'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Reservation has expired.'), findsOneWidget);
    });

    testWidgets('Cancelled reservation shows error', (tester) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: 'store_1',
          reservationCode: 'FS-CANCELLED123',
        ),
      ).thenAnswer(
        (_) async => Result.success(
          OwnerReservationPaginatedResponse(
            items: [testReservationCancelled],
            meta: const OwnerReservationPaginationMeta(
              total: 1,
              page: 1,
              limit: 20,
              totalPages: 1,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        createQrScannerScreen(initialCode: 'FS-CANCELLED123'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Reservation has been cancelled.'), findsOneWidget);
    });

    testWidgets('Completed reservation shows error', (tester) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: 'store_1',
          reservationCode: 'FS-COMPLETED123',
        ),
      ).thenAnswer(
        (_) async => Result.success(
          OwnerReservationPaginatedResponse(
            items: [testReservationCompleted],
            meta: const OwnerReservationPaginationMeta(
              total: 1,
              page: 1,
              limit: 20,
              totalPages: 1,
            ),
          ),
        ),
      );

      await tester.pumpWidget(
        createQrScannerScreen(initialCode: 'FS-COMPLETED123'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.text('Reservation has already been completed.'),
        findsOneWidget,
      );
    });
  });

  group('PickupConfirmationSheet Tests', () {
    testWidgets('Tapping Complete Pickup successfully completes reservation', (
      tester,
    ) async {
      when(
        () => mockRepository.getStoreReservations(
          storeId: 'store_1',
          reservationCode: 'FS-READY123',
        ),
      ).thenAnswer(
        (_) async => Result.success(
          OwnerReservationPaginatedResponse(
            items: [testReservationReady],
            meta: const OwnerReservationPaginationMeta(
              total: 1,
              page: 1,
              limit: 20,
              totalPages: 1,
            ),
          ),
        ),
      );

      when(
        () => mockRepository.completeReservation('res_1'),
      ).thenAnswer((_) async => Result.success(testReservationCompleted));

      await tester.pumpWidget(
        createQrScannerScreen(initialCode: 'FS-READY123'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(PickupConfirmationSheet), findsOneWidget);

      final button = find.text('Complete Pickup');
      expect(button, findsOneWidget);

      await tester.tap(button);
      await tester.pump();
      await tester.pump(
        const Duration(milliseconds: 500),
      ); // allow action to finish

      verify(() => mockRepository.completeReservation('res_1')).called(1);
    });
  });
}
