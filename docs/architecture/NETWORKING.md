# FreshSave Network Architecture

This document describes the networking protocol, communication flow, and security architecture of the FreshSave platform.

## 1. FreshSave Network Architecture

FreshSave uses a standard client-server architecture:
*   **Clients:** Flutter mobile application (Customer and Store Owner apps).
*   **Server:** NestJS backend REST API.
*   **Databases:** PostgreSQL (with PostGIS) for persistent relational and spatial data, Redis for caching and session management.

All communication between the clients and the server occurs over the public internet, while communication between the server and databases occurs over private internal networks (e.g., Docker bridge networks).

## 2. HTTPS Flow

The communication flow for API requests is as follows:
1.  **Flutter Client:** Initiates an HTTPS request (e.g., `GET /api/v1/offers`) to the backend API domain.
2.  **Transport:** The payload is encrypted using TLS 1.2+ over TCP.
3.  **TLS Termination:** Occurs either at a Reverse Proxy / Load Balancer (recommended for production) or natively in the NestJS application (supported via environment configuration).
4.  **Backend Processing:** The NestJS application processes the decrypted HTTP request, validates the JWT, applies RBAC, executes business logic, and connects to the databases.
5.  **Response:** The backend returns an HTTP response, which is re-encrypted via TLS and sent back to the Flutter client.

## 3. TLS Termination Location

FreshSave supports two modes of TLS termination:
*   **Native NestJS (Direct Exposure):** By setting `HTTPS_ENABLED=true` and providing paths to certificates (`TLS_KEY_PATH` and `TLS_CERT_PATH`), the NestJS bootstrap process creates an HTTPS listener. This is useful when the Node process is directly exposed to the internet.
*   **Reverse Proxy / Load Balancer (Recommended):** In cloud deployments (e.g., AWS ALB, Render, NGINX), TLS is terminated at the proxy layer, and traffic is forwarded as plain HTTP to the NestJS application on an internal port (e.g., 3000). In this scenario, Native NestJS HTTPS is disabled (`HTTPS_ENABLED=false`).

## 4. TCP Relationship with HTTPS

HTTPS inherently operates over TCP as its underlying transport layer. The robust connection establishment, packet ordering, and reliability guarantees of TCP are fully utilized by the HTTP(S) protocol.

## 5. Application-Level TCP Architecture

*Not implemented.* 
FreshSave does not use custom, raw TCP sockets at the application level. There are no internal microservices requiring lightweight RPC (like gRPC or raw TCP), nor does the Flutter app require real-time, bi-directional raw data streams that would necessitate replacing the existing WebSocket/REST infrastructure. The client requirement for TCP is fully satisfied by the underlying transport layer of the existing HTTPS architecture.

## 6. Flutter → API Communication

The Flutter app utilizes the `Dio` HTTP client.
*   **Base URL:** In production, it targets an HTTPS endpoint. It uses `const String.fromEnvironment('API_URL')` to allow dynamic configuration at build time.
*   **Security:** Certificate validation is enforced. There are no insecure bypass mechanisms (e.g., `badCertificateCallback`) allowing self-signed or invalid certificates in production.
*   **Timeouts & Retries:** Connection and read timeouts are configured (60s), and a retry interceptor handles intermittent network failures automatically.

## 7. JWT Transmission

JSON Web Tokens (JWTs) are used for authentication.
*   **Transmission:** Tokens are transmitted exclusively in the `Authorization` header as Bearer tokens (`Authorization: Bearer <token>`).
*   **Security:** Because they are sent via HTTPS, the tokens are encrypted during transit and protected against Man-in-the-Middle (MitM) attacks. They are never placed in URLs, query parameters, or logged in server logs.

## 8. Authentication vs Authorization

*   **Authentication:** Verifying *who* the user is. This is handled by the `JwtAuthGuard`, which validates the JWT signature and expiration.
*   **Authorization (RBAC):** Verifying *what* the user is allowed to do. This is handled after authentication via Guards (e.g., `RolesGuard`) that check the `role` embedded in the JWT payload (e.g., `ADMIN`, `SHOP_OWNER`, `CUSTOMER`). Security checks ensure a user only accesses resources they own.

## 9. Internal Service Communication

The NestJS backend communicates with PostgreSQL and Redis.
*   This communication happens entirely behind the firewall within the backend infrastructure.
*   It utilizes the native database protocols (PostgreSQL wire protocol and Redis protocol), which operate over raw TCP.

## 10. Docker Networking

For containerized deployments, FreshSave uses Docker `bridge` networking (`freshsave-network`).
*   PostgreSQL and Redis are bound to this internal network and are only accessible by the backend container.
*   In a secure production environment, the database ports (5432, 6379) should *not* be mapped to the public host (`ports: ["5432:5432"]` is strictly for development/bastion access).

## 11. Production Ports

*   **Public Access:** Port `443` (HTTPS)
*   **Backend (Internal):** Port `3000`
*   **Database (Internal):** Port `5432` (PostgreSQL), Port `6379` (Redis)

## 12. Development Ports

*   **Public Access:** Port `3000` (HTTP)
*   **Database (Local Mapping):** Port `5432`, Port `6379`

## 13. Certificate Management

If using Native NestJS HTTPS:
*   Certificates MUST be securely mounted into the Docker container (e.g., `/etc/secrets/`) as read-only.
*   Certificates and private keys are strictly excluded from source control (`.gitignore`).
*   Environment variables `TLS_KEY_PATH` and `TLS_CERT_PATH` point to the mounted files.

## 14. Environment Variables

Key networking configurations:
*   `APP_PORT`: The internal port NestJS binds to (default 3000).
*   `HTTPS_ENABLED`: Boolean to enable/disable native TLS termination.
*   `TLS_KEY_PATH`: Absolute/relative path to the private key.
*   `TLS_CERT_PATH`: Absolute/relative path to the public certificate.

## 15. Security Considerations

*   **Never commit secrets:** Passwords, private keys, and JWT secrets must be injected at runtime or securely mounted.
*   **Database Exposure:** Databases must never be publicly exposed to the internet.
*   **CORS:** Cross-Origin Resource Sharing is restricted in production to known domains.

## 16. Deployment Instructions

To deploy with native HTTPS via Docker Compose:
1. Ensure your certificates are generated and placed in a secure folder on the host (e.g., `./secrets/`).
2. Set `HTTPS_ENABLED=true` in your `.env`.
3. Provide the correct mapping paths for `TLS_KEY_PATH` and `TLS_CERT_PATH`.
4. Update `docker-compose.yml` to mount the `./secrets` folder into the backend container as read-only.
5. Map host port `443` to container port `3000`.

## 17. Troubleshooting

*   **Error: Failed to load TLS certificates:** Verify the file paths in `TLS_KEY_PATH` and ensure the Docker container has read permissions for the mounted volume.
*   **Flutter Network Error:** Ensure the `API_URL` environment variable uses `https://` when deploying to production.
