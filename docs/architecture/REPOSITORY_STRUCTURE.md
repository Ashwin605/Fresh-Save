# FreshSave Repository Structure

This repository follows a structured monorepo-style layout designed for clarity, scalability, and ease of maintenance.

## Directory Layout

```text
Fresh-Save/
├── apps/
│   ├── backend/               # NestJS backend application source
│   │   ├── src/               # Application source code
│   │   └── test/              # Integration and E2E tests
│   └── customer_app/          # Flutter mobile application
├── database/
│   └── prisma/                # Prisma schema, migrations, and seed scripts
├── scripts/
│   ├── diagnostics/           # Scripts for database and state inspection
│   ├── maintenance/           # Scripts for operational repair and reporting
│   ├── migration/             # One-time migration scripts
│   └── archive/               # Deprecated or one-off repair scripts
├── docs/
│   ├── architecture/          # Architecture and structural documentation
│   └── audits/                # Security, feature, and route audit reports
├── infrastructure/
│   ├── bin/                   # Binary tools (e.g., cloudflared)
│   └── jdk/                   # Java Development Kit (if applicable)
├── package.json               # Root NPM workspace / backend dependencies
├── nest-cli.json              # NestJS configuration (targets apps/backend/src)
├── tsconfig.json              # TypeScript configuration
├── docker-compose.yml         # Local development environment
├── Dockerfile                 # Production Docker build
└── README.md                  # Project documentation
```

## Key Principles

- **Separation of Concerns:** Frontend (`customer_app`), Backend (`backend`), and Database (`database/prisma`) are strictly separated into their respective domains.
- **Root Cleanliness:** The repository root is reserved exclusively for high-level configuration and tooling (`package.json`, `.gitignore`, `Dockerfile`, etc.).
- **Script Categorization:** Utility scripts are categorized within `scripts/` to prevent clutter and clarify their intended use (diagnostics, maintenance, or archived).
- **Tooling Compatibility:** Tooling files (like `package.json` and `nest-cli.json`) remain at the root to ensure compatibility with standard Docker build contexts and CI/CD pipelines, while pointing their source paths to the `apps/backend/` directory.
