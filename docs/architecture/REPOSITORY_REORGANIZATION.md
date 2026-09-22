# Repository Reorganization Migration Report

## Before
The repository contained a NestJS backend (`src/`, `test/`), a Prisma setup (`prisma/`), and a Flutter mobile application (`customer_app/`), alongside nearly 20 development, maintenance, and diagnostics scripts (e.g., `check-db.js`, `fix_ts.js`, `update_images.js`) scattered directly at the project root. This created an unstructured Monorepo configuration that was difficult to navigate and maintain.

## After
The repository has been restructured to separate applications, infrastructure, database, and scripts securely, retaining standard compatibility with `Dockerfile` and NestJS building steps while isolating concerns:
- **`apps/backend/`**: Contains the complete NestJS application source.
- **`apps/customer_app/`**: Contains the full Flutter source structure.
- **`database/`**: Dedicated schema definitions and migrations.
- **`scripts/`**: Groups auxiliary Node scripts.

## Files Moved

| Old Path | New Path | Reason |
| -------- | -------- | ------ |
| `customer_app/` | `apps/customer_app/` | Decoupled client application logic. |
| `src/` | `apps/backend/src/` | Separated NestJS source from root. |
| `test/` | `apps/backend/test/` | Relocated server E2E and Unit test infrastructure. |
| `prisma/` | `database/prisma/` | Separated database configuration from the root codebase. |
| `docs/FRESHSAVE_*.md` | `docs/audits/` | Consolidated security/functional audits. |
| `api_inventory.json` | `docs/audits/` | Removed raw outputs from the project root. |
| `check-db.js`, `query_pg.js` etc. | `scripts/diagnostics/` | Compartmentalized inspection scripts. |
| `migrate_categories.js` | `scripts/migration/` | Separated migration/setup code. |
| `extract_routes.js` | `scripts/maintenance/` | Clarified script boundaries. |
| `cloudflared.exe` | `infrastructure/bin/` | Maintained dev dependencies while clearing repository clutter. |
| `jdk21.zip`, `jdk21/` | `infrastructure/jdk/` | Moved out of standard application workspace. |

## Files Archived

| File | New Location | Reason |
| ---- | ------------ | ------ |
| `fix-db.js` | `scripts/archive/` | Hardcoded single-use database repair logic. |
| `fix.js` | `scripts/archive/` | Historical manual testing fixes. |
| `fix2.js` | `scripts/archive/` | Obsolete repair artifacts. |
| `fix_ts.js` | `scripts/archive/` | Unnecessary post-lint patching rules. |
| `delete-fakes.js` | `scripts/archive/` | Single-use destructive operations separated securely from runpaths. |

## Configuration Updated
- **`nest-cli.json`**: Re-routed `sourceRoot` to `apps/backend/src` and `entryFile` to `apps/backend/src/main`.
- **`tsconfig.json`**: Remapped base aliases (`@config/*`, `@common/*`, etc.) to point inside `apps/backend/src/`.
- **`package.json`**: Upgraded `start:prod`, `format`, `lint`, and `test:e2e` scripts to reflect absolute `apps/backend/*` paths. Updated Prisma postinstall target schema logic.
- **`prisma.config.ts`**: Altered migration, schema, and seed execution directories to `database/prisma/`.
- **`Dockerfile`**: Rewritten context hooks to resolve Prisma client schema builds from `database/prisma` and start outputs from `dist/apps/backend/src/main.js`.

## Validation
The following commands were run to execute validation:
- `npm run build`: Validated Nest CLI compilation with the new tree mappings.
- `npx prisma validate`: Verified ORM schema paths dynamically parsing `prisma.config.ts` adjustments successfully (`The schema at database\prisma\schema.prisma is valid 🚀`).
- `npm run test`: Assured that `Jest` dynamically detects and executes spec files from the relocated `rootDir`.

## Known Limitations
- Option A was selected (leaving `package.json` configurations rooted): `node_modules` remains globally scoped for the Nest app, while the Flutter app naturally manages its own `.dart_tool` internals. This guarantees Dockerlayer compatibility seamlessly without workspace-breaking rewrites.
