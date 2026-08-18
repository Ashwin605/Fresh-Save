# FreshSave Deployment Guide

## Production Environment Requirements
- Node.js (v18+)
- PostgreSQL (v14+) with the **PostGIS extension installed**.
- PM2 (for Node process management) or Docker.
- Nginx or similar reverse proxy.

## Backend Deployment (Standard Node Environment)

1. **Clone the repository and install dependencies:**
   ```bash
   git clone <repo-url>
   cd freshsave
   npm install --production
   ```

2. **Configure Environment:**
   Create a `.env` in the root folder with real production secrets.
   ```env
   DATABASE_URL="postgresql://user:pass@host:5432/db?schema=public"
   JWT_SECRET="generate-a-secure-random-string"
   PORT=3000
   ```

3. **Database Migration:**
   Deploy the schema changes to the production database.
   ```bash
   npx prisma migrate deploy
   ```

4. **Build and Run:**
   ```bash
   npm run build
   # Use PM2 to daemonize the application
   pm2 start dist/main.js --name freshsave-api
   ```

## Mobile Application Deployment (Flutter)

1. **Configure API Base URL:**
   Ensure the `API_URL` environment variable within Flutter targets the production backend.

2. **Android Release Build:**
   ```bash
   cd customer_app
   flutter build appbundle --release
   ```
   Upload the generated `.aab` file to the Google Play Console.

3. **iOS Release Build:**
   ```bash
   cd customer_app
   flutter build ipa --release
   ```
   Upload the generated `.ipa` file using Transporter or Xcode to App Store Connect.

## Rollback Plan
- **Backend**: If a deployment fails, revert to the previous Git commit and run `npm run build` followed by `pm2 reload freshsave-api`.
- **Database**: Database downgrades are not natively supported by `prisma migrate deploy`. Ensure you take a database snapshot *before* executing schema migrations on production.
