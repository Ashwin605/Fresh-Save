# FreshSave

FreshSave connects businesses with surplus inventory to nearby customers, helping reduce waste while creating value from unsold products.

## Overview
FreshSave is a comprehensive SaaS platform consisting of a Customer App, an Owner App, an Admin Console, and a robust Backend API. It leverages modern mobile technologies and scalable cloud architecture to facilitate real-time inventory management, offer creation, and customer discovery.

## Problem & Solution
- **Problem**: Every day, restaurants, bakeries, and grocery stores discard perfectly good unsold food, while consumers seek affordable high-quality meals.
- **Solution**: FreshSave provides a real-time marketplace. Store owners can publish "Deals" (offers) for surplus inventory at a discount. Customers discover these deals, reserve them, and pick them up in-store.

## Core Features
- **Customer Experience**: Location-based deal discovery, search & filtering, real-time reservations, tracking, and push notifications.
- **Owner Experience**: Dashboard analytics, product/inventory management, automated deal generation via AI, and QR-code based fulfillment tracking.
- **Admin Operations**: Multi-tenant store onboarding, user management, system health monitoring, and platform-wide analytics.
- **AI Integration**: Smart pricing recommendations, auto-generated offer descriptions, and inventory insights.

## Tech Stack
- **Frontend (Mobile/Web)**: Flutter, Riverpod, GoRouter, Dio.
- **Backend API**: NestJS, TypeScript, Prisma ORM.
- **Database**: PostgreSQL (with PostGIS for geospatial querying).
- **Security**: JWT-based Authentication, Role-Based Access Control (RBAC).

## Architecture
See `docs/ARCHITECTURE.md` for a complete breakdown of the data flows and system architecture.

## Installation & Setup

### Environment Setup
Create a `.env` file in the root directory and configure the following variables (DO NOT use real secrets in development):
```env
DATABASE_URL="postgresql://user:password@localhost:5432/freshsave?schema=public"
JWT_SECRET="your-jwt-secret"
AI_API_KEY="your-ai-api-key"
PORT=3000
```

### Backend Setup
```bash
# Install dependencies
npm install

# Run database migrations
npx prisma migrate dev

# Seed database with initial data
npx prisma db seed

# Run the development server
npm run start:dev
```

### Frontend (Flutter) Setup
```bash
cd customer_app

# Get dependencies
flutter pub get

# Run the application
flutter run
```

## Testing
See `docs/TESTING.md` for complete testing instructions, including backend unit tests and Flutter widget tests.

## Deployment
See `docs/DEPLOYMENT.md` for staging and production deployment strategies.

## Security
See `docs/SECURITY.md` for details on multi-tenant isolation, role separation, and API security.

## Future Improvements
- Advanced Demand Forecasting using ML models.
- Expanded Payment Gateway Integrations (Stripe, PayPal).
- Enterprise Multi-Store Management Dashboards.
- Delivery Integrations.

---
*Built for production scale. FreshSave.*
