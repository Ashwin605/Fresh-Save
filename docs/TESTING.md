# FreshSave Testing Guide

FreshSave employs a rigorous testing strategy to ensure platform stability, particularly around multi-tenancy rules and inventory transactions.

## Backend (NestJS) Testing

The backend uses Jest as its primary testing framework.

### Running Unit Tests
Unit tests validate isolated services (e.g., ensuring expiration logic correctly identifies expired goods, or geospatial services return accurate distances).
```bash
npm run test
```

### Running E2E Tests
E2E tests spin up the entire application module and run against an isolated test database.
```bash
npm run test:e2e
```

### Coverage
To view test coverage:
```bash
npm run test:cov
```

## Frontend (Flutter) Testing

The Flutter application relies on widget testing and unit testing to ensure the UI behaves predictably.

### Running Tests
```bash
cd customer_app
flutter test
```

### Focus Areas
- **Fulfillment Testing**: Automated widget tests verify the Owner UI accurately responds to QR scanning, including validating successful pickups and rejecting expired/cancelled reservations.
- **State Management**: Unit tests verify Riverpod notifiers appropriately update state (e.g., `networkStatusProvider`, `authStateProvider`).
