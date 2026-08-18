# FreshSave Security Guidelines

Security is paramount in FreshSave. The system is designed to prevent data leakage between stores, secure customer reservations, and log administrative actions.

## 1. Authentication
- **JSON Web Tokens (JWT)**: FreshSave uses stateless JWTs. Access tokens have a short lifespan (e.g., 15 minutes), while refresh tokens have a longer lifespan. 
- **Refresh Flow**: The Flutter frontend implements a `Dio` interceptor (`AuthInterceptor`) that automatically intercepts `401 Unauthorized` responses, calls the `/auth/refresh` endpoint, and retries the original request seamlessly.

## 2. Authorization & Role Separation (RBAC)
- **Roles**: Users are assigned roles: `CUSTOMER`, `OWNER`, `STAFF`, `ADMIN`, `SUPER_ADMIN`.
- **Global Enforcement**: By default, all backend endpoints are locked down. Public endpoints (like `/discovery`) must explicitly opt-out of authentication.
- **Role Guards**: Endpoints restricted to specific roles use the `@Roles()` decorator paired with `RolesGuard`. For example, only `ADMIN` roles can hit the `/admin` endpoints.

## 3. Multi-Tenant Isolation
- **Data Boundaries**: Stores belong to a `Business`. A user with an `OWNER` role is tied to a specific `businessId`.
- **Controller Enforcement**: Any request to modify store inventory or offers (`/api/v1/stores/:storeId/...`) strictly validates that the authenticated user possesses ownership or staff rights over the requested `storeId`. **Insecure Direct Object Reference (IDOR) attacks are mitigated by enforcing these checks at the service level.**

## 4. Secret Management
- **Environment Variables**: No secrets (JWT keys, AI API keys, database passwords) are stored in the source code. They are exclusively loaded via `.env` in development and secure environment injection in production.
- **Frontend Exfiltration**: The backend never returns sensitive internal IDs or password hashes to the frontend.

## 5. Audit Logging
- Highly privileged administrative actions (e.g., verifying a store, deleting a user) are logged to the `AuditLog` table, tracking the actor, the action, and the timestamp for compliance and rollback capabilities.
