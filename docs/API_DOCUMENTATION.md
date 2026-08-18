# FreshSave API Documentation

The FreshSave backend provides a RESTful API built on NestJS. All non-public endpoints require a Bearer token (`Authorization: Bearer <token>`).

## Authentication API (`/auth`)
- `POST /auth/register`: Register a new customer or business owner.
- `POST /auth/login`: Authenticate and receive `accessToken` and `refreshToken`.
- `POST /auth/refresh`: Issue a new access token using a valid refresh token.
- `GET /auth/me`: Retrieve the authenticated user's profile and roles.

## Discovery API (`/discovery`) — *Public*
- `GET /discovery/deals/nearby`: Find active discounted deals near a specific coordinate.
- `GET /discovery/stores/nearby`: Discover active verified stores.
- `GET /discovery/products`: Browse the public product catalog.
- `GET /discovery/deals/:offerId`: Fetch full details of an active offer.

## Customer Reservations (`/api/v1/reservations`)
- `POST /api/v1/reservations`: Create a reservation for an active offer.
- `GET /api/v1/reservations`: List the authenticated customer's reservations.
- `GET /api/v1/reservations/:id`: Get full details of a specific reservation (including QR Code data).
- `PATCH /api/v1/reservations/:id/cancel`: Cancel a pending reservation.

## Store Owner Operations (`/api/v1/stores/:storeId`)
*(Requires `OWNER` or `STAFF` role associated with the specific store)*
- `GET /api/v1/stores/:storeId/inventory`: Fetch store inventory.
- `POST /api/v1/stores/:storeId/inventory`: Add new stock.
- `GET /api/v1/stores/:storeId/offers`: List store's published offers.
- `POST /api/v1/stores/:storeId/offers`: Publish a new offer.
- `GET /api/v1/stores/:storeId/reservations`: List incoming customer reservations for the store.
- `POST /api/v1/stores/:storeId/reservations/:id/complete`: Complete a reservation (Fulfillment).

## Admin Operations (`/admin`)
*(Requires `SUPER_ADMIN` or `ADMIN` role)*
- `GET /admin/users`: List all platform users.
- `GET /admin/stores`: List all stores and verification statuses.
- `PATCH /admin/stores/:storeId/verify`: Approve a store for the platform.
- `GET /admin/audit-logs`: Review platform-wide audit trails.
- `GET /admin/health`: System health and metrics.

## AI Services (`/api/v1/ai`)
- `POST /api/v1/ai/inventory/recommendations`: Request Gemini AI to recommend pricing and deal descriptions based on current stock levels and expiry dates.

---
*Note: This is a high-level overview. For exhaustive request/response schemas, refer to the generated Swagger/OpenAPI specification when running the backend in development mode (`/api-docs`).*
