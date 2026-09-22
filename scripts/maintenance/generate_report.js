const fs = require('fs');
const path = require('path');

const reportPath = path.join('C:', 'Users', 'ASHWIN', '.gemini', 'antigravity-ide', 'brain', '57554f20-2378-4cc7-88fb-b1db9756d45e', 'freshsave_codebase_intelligence_report.md');
const apiInventory = JSON.parse(fs.readFileSync('api_inventory.json', 'utf8'));

let md = `# FreshSave — Complete Codebase Intelligence Report

> [!NOTE]
> This is a read-only codebase intelligence audit and technical knowledge base of the FreshSave application, intended for engineering and security review.

## 1. Executive Summary
FreshSave is a full-stack platform designed to connect consumers with local businesses to purchase inventory, reserve items, and discover deals. It acts as an anti-food-waste and local deal discovery tool. The system consists of a NestJS backend utilizing PostgreSQL (with PostGIS for geospatial queries), Redis for session management, and a Flutter-based mobile frontend for customers and shop owners.

## 2. Scope
- **Backend:** NestJS, Prisma, PostgreSQL, Redis (\`src/\`, \`prisma/\`).
- **Frontend:** Flutter, Riverpod, GoRouter (\`customer_app/\`).
- **Infrastructure:** Docker, Docker Compose, environment configurations.

## 3. Audit Methodology
The audit was conducted via a read-only static analysis and architectural reverse-engineering of the codebase. Tools utilized include filesystem walking, regex parsing of decorators for API mapping, Prisma schema extraction for database design, and dependency analysis.

## 4. Repository Structure
\`\`\`text
FreshSave/
├── customer_app/       # Flutter Frontend Application
│   ├── lib/            # Source code
│   │   ├── app/        # App routing and theme
│   │   ├── core/       # Networking, providers, widgets
│   │   └── features/   # Domain modules (auth, home, owner, discovery, etc.)
│   └── pubspec.yaml    # Frontend dependencies
├── src/                # NestJS Backend Application
│   ├── auth/           # Authentication logic
│   ├── admin/          # Admin features and dashboard
│   ├── inventory/      # Product inventory management
│   ├── reservations/   # Order & reservation management
│   ├── ai/             # AI insights and predictions
│   └── main.ts         # Backend entry point
├── prisma/             # Database ORM
│   └── schema.prisma   # Schema definition
├── docker-compose.yml  # Local infrastructure
├── Dockerfile          # Production backend image
├── .env.example        # Environment template
└── *.js                # Various one-off maintenance scripts (technical debt)
\`\`\`

## 5. Technology Stack

### Frontend
- **Framework:** Flutter (SDK ^3.12.0)
- **State Management:** flutter_riverpod (^3.4.2)
- **Router:** go_router (^17.5.0)
- **Storage:** flutter_secure_storage, shared_preferences
- **API Client:** dio (^5.11.0)
- **UI Libraries:** flutter_animate, google_fonts, mobile_scanner

### Backend
- **Framework:** NestJS (^11.0.1) / Node.js
- **Database ORM:** Prisma (^7.9.1)
- **Queueing:** BullMQ (^6.0.9)
- **Auth:** Passport-JWT, Argon2
- **Logging:** pino-http, nestjs-pino

### Database
- **Engine:** PostgreSQL 16 (with PostGIS 3.4 for geospatial data)
- **Session/Cache:** Redis 7 (Alpine)

### Infrastructure
- **Containerization:** Docker & Docker Compose

## 6. Application Purpose
FreshSave connects customers with nearby stores offering products and deals. It enables users to browse, search, and reserve items, while offering store owners tools to manage inventory, staff, and offers. The system is augmented with an AI module providing inventory risk assessments and discount recommendations to owners.

## 7. User Roles
- **CUSTOMER:** End-users browsing and reserving items.
- **SHOP_OWNER:** Business owners who create stores, manage staff, and add inventory.
- **SHOP_STAFF:** Employees at a store who can manage day-to-day operations (confirming reservations).
- **ADMIN / SUPER_ADMIN:** Platform administrators with God-mode access to suspend users, verify businesses, and view audit logs.

## 8. User Journeys
- **Registration/Login:** User -> \`AuthScreen\` -> \`POST /auth/register\` -> Database -> Token returned -> \`flutter_secure_storage\` -> Authenticated state.
- **Discovery:** Customer -> \`DiscoveryScreen\` -> \`GET /discovery/stores/nearby\` (uses PostGIS) -> Stores rendered.
- **Reservation:** Customer -> \`ProductCard\` -> \`POST /reservations/:id/reserve\` -> \`ReservationStatus.PENDING\` -> Notification to Shop -> Shop confirms (\`POST /stores/reservations/:id/confirm\`) -> Customer picks up -> Complete.

## 9. Frontend Architecture
The frontend is modularized by \`features/\` (e.g., \`auth\`, \`home\`, \`owner\`).
- **Routing:** Centralized in \`app_router.dart\` using \`go_router\`.
- **State:** \`flutter_riverpod\` manages state globally and locally.
- **API:** \`dio\` handles networking, passing JWTs from \`flutter_secure_storage\`.

## 10. Backend Architecture
\`Request -> main.ts (Helmet, Cors, ValidationPipe) -> JwtAuthGuard -> RolesGuard -> Controller -> Service -> Prisma Client -> DB -> Response\`
The backend is highly modular. Core entities have dedicated directories in \`src/\`.

## 11. API Inventory
*(Total endpoints: ${apiInventory.length}. See full list in codebase or api_inventory.json)*
Notable endpoints include:
`;

apiInventory.slice(0, 15).forEach(api => {
  md += `- \`${api.method} ${api.endpoint}\` (Roles: ${api.roles}) -> \`${api.handler}\`\n`;
});
md += `- ...and ${apiInventory.length - 15} more.\n\n`;

md += `## 12. Authentication Architecture
- Users register via \`/auth/register\`.
- Passwords hashed using \`argon2\`.
- JWT generation (Access + Refresh tokens). Refresh tokens stored in DB (\`Session\` model).
- Client stores JWTs in Secure Storage.
- \`JwtStrategy\` validates access tokens on every protected request.

## 13. Authorization Architecture
- Controlled via \`@Roles()\` decorator on controllers.
- Validated by \`RolesGuard\`.
- **RBAC Matrix (Example):**
  - Verify Business: ADMIN, SUPER_ADMIN
  - Confirm Reservation: SHOP_OWNER, SHOP_STAFF
  - Browse Stores: CUSTOMER

## 14. Database Architecture
PostgreSQL with PostGIS. Heavy use of foreign keys, cascades, and enums.

## 15. Database Schema Dictionary (Key Tables)
- \`User\`: id, name, email, role, password, status
- \`Store\`: id, businessId, name, location (PostGIS Point), status
- \`Inventory\`: id, storeId, productId, stockQuantity, sellingPrice
- \`Reservation\`: id, customerId, storeId, status, totalAmount
- \`AuditLog\`: Tracks admin actions for security.

## 16. Data Flow Analysis
- **Sensitive Data:** Passwords (hashed), JWTs, user emails, locations.
- **Flow:** User Input -> Flutter Form -> Dio POST -> NestJS ValidationPipe -> Service -> Prisma -> Postgres.

## 17. Business Logic
- **Reservations:** Cannot reserve more than \`stockQuantity\`. Stock is held upon reservation and deducted permanently upon completion.
- **Stores:** Cannot operate without an approved \`Business\`.
- **AI Insights:** AI service queries Prisma for expiring inventory and generates discounts.

## 18. External Integrations
- **Email:** Nodemailer / Resend API (\`MAIL_HOST=smtp.resend.com\`)
- **Geolocation:** PostGIS calculations (\`location Unsupported("geography(Point, 4326)")\`).

## 19. Configuration & Environment
- Environment loaded via \`@nestjs/config\`.
- Sensitive vars: \`DATABASE_URL\`, \`JWT_ACCESS_SECRET\`, \`MAIL_PASSWORD\`.
- Default port: 3000.

## 20. Dependency Inventory
- Backend: NestJS 11, Prisma 7, BullMQ, Passport.
- Frontend: Flutter 3.12, Riverpod, Dio.

## 21. Error Handling
- Backend uses NestJS built-in Exceptions (\`NotFoundException\`, \`UnauthorizedException\`).
- Frontend intercepts Dio errors to display Snackbars or error dialogues.

## 22. Logging
- \`nestjs-pino\` with \`pino-pretty\`. Tracks requests, errors, and debug traces.

## 23. Testing
- Standard Jest configuration in \`package.json\`. Missing substantial e2e evidence.

## 24. Build & Deployment
- \`Dockerfile\` builds the NestJS app (compiles to \`dist/\`).
- \`docker-compose.yml\` provides local Postgres and Redis.
- Production requires a Node 24+ environment running \`dist/src/main.js\`.

## 25. Code Quality
- Standard NestJS modularity. 
- Some tight coupling between business modules (e.g., Offers and Inventory).

## 26. Performance Hotspots
- PostGIS distance queries (\`ST_DWithin\`) in \`discovery.controller.ts\`. Needs monitoring under scale.
- Complex nested Prisma includes.

## 27. Security-Relevant Code Inventory
- \`src/auth/*\`: Token issuing and hashing.
- \`src/admin/admin.controller.ts\`: High-privilege actions.
- \`src/discovery/discovery.service.ts\`: Contains raw SQL (\`$queryRaw\`).

## 28. Security Hotspots
- **File Uploads**: Logo and images functionality (requires S3/Bucket storage review).
- **Session Revocation**: Handled in \`suspendUser\` but needs review for edge cases.

## 29. Technical Debt
- **One-off scripts:** Over 15 loose \`.js\` and \`.ts\` files in root (\`fix.js\`, \`check-db.js\`, \`migrate_categories.js\`). These should be moved to a \`scripts/\` directory or removed.
- **Hardcoded defaults:** Occasional magic numbers in configuration fallbacks.

## 30. Incomplete / Unknown Areas
- Frontend deployment methodology (App Store/Play Store CI/CD not visible).
- Payment Gateway integration is NOT PRESENT in the schema (likely MVP stage).

## 31. Important File Map
- \`src/main.ts\`: App entry, middlewares, global pipes.
- \`prisma/schema.prisma\`: Source of truth for database.
- \`customer_app/lib/app/router/app_router.dart\`: Frontend navigation source of truth.

## 32. Function/Class Map
- \`AuthService.login()\`: Verifies hash, issues JWT.
- \`ReservationsService.create()\`: Atomic stock deduction and reservation.

## 33. Module Dependency Map
\`\`\`text
AppModule
 ├── AuthModule
 ├── PrismaModule (Global)
 ├── ReservationsModule -> InventoryModule
 └── DiscoveryModule -> PrismaModule
\`\`\`

## 34. Application State Machines
**Reservation Status:**
\`PENDING -> CONFIRMED -> READY -> COMPLETED\`
(Can also branch to \`REJECTED\`, \`CANCELLED\`, or \`EXPIRED\`)

## 35. Data Dictionary
(See schema definition)

## 36. System Architecture Diagram
\`Flutter App (Customer/Owner) <-> REST API (NestJS) <-> Postgres (Data) + Redis (Sessions & BullMQ)\`

## 37. Complete Technical Findings
System is structurally sound, leveraging modern TS/Dart paradigms. Security hardening applied recently (RBAC, Rate Limits).

## 38. Recommended Areas for Security Audit
- Thorough review of \`discovery.service.ts\` PostGIS raw queries.
- Cloud bucket configurations for image uploads (not currently visible).

## 39. Recommended Areas for Testing
- Integration tests for atomic inventory decrementing.
- Role boundary E2E tests.

## 40. Final System Knowledge Summary

# "If Another Engineer Had To Take Over FreshSave Tomorrow"
1. **What FreshSave is:** A dual-sided marketplace app (Customer & Shop Owner) for local deals and inventory reservation to combat food waste.
2. **How it works:** Mobile app talks to a NestJS REST API, querying a PostGIS-enabled Postgres database.
3. **Tech Stack:** Flutter, NestJS, Prisma, PostgreSQL, Redis.
4. **Main Users:** \`CUSTOMER\`, \`SHOP_OWNER\`, \`ADMIN\`.
5. **Main Modules:** Auth, Discovery (Geo-search), Inventory, Reservations.
6. **Main APIs:** \`/auth/*\`, \`/discovery/*\`, \`/reservations/*\`.
7. **Auth:** JWTs (Access + Refresh).
8. **Authz:** Role-based via \`@Roles()\` guards.
9. **Database:** Standard normalized SQL with geospatial extensions.
10. **External:** Nodemailer/Resend.
11. **Deployment:** Dockerized backend.
12. **Important Files:** \`main.ts\`, \`schema.prisma\`, \`app_router.dart\`.
13. **Debt:** Lots of root-level \`.js\` cleanup scripts.
14. **Unknowns:** Payment processing, cloud infrastructure.
15. **Security:** PostGIS raw queries, rate limiting configurations.
16. **Most important:** Understand Prisma's geospatial limitations leading to raw SQL in \`DiscoveryService\`, and the Riverpod state architecture in the Flutter app.

---
# FreshSave System Knowledge Index
\`\`\`yaml
application: FreshSave
technology_stack:
  frontend: [Flutter, Riverpod, GoRouter, Dio]
  backend: [NestJS, Prisma, BullMQ]
  database: [PostgreSQL, PostGIS, Redis]
authentication: JWT with Refresh Tokens (Argon2 hashing)
authorization: RBAC Guards
roles: [CUSTOMER, SHOP_OWNER, SHOP_STAFF, ADMIN, SUPER_ADMIN]
major_modules: [Auth, Discovery, Inventory, Reservations, AI]
api_groups: [auth, admin, businesses, discovery, inventory, offers, reservations]
deployment: [Docker, Docker Compose]
important_files: [src/main.ts, prisma/schema.prisma, customer_app/lib/app/router/app_router.dart]
known_technical_debt: [Root-level JS maintenance scripts]
unknown_areas: [Payment gateway, Frontend CI/CD]
\`\`\`
`;

fs.writeFileSync(reportPath, md);
console.log('Report generated at ' + reportPath);
