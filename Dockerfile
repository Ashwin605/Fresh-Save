# ============================================
# FreshSave — Dockerfile (Multi-stage Build)
# ============================================

# ── Stage 1: Build ────────────────────────────────────
FROM node:24-alpine AS builder

WORKDIR /app

# Copy package files first for layer caching
COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci

COPY . .

RUN npx prisma generate
RUN npm run build

# ── Stage 2: Production ──────────────────────────────
FROM node:24-alpine AS production

# Create non-root user
RUN addgroup --system --gid 1001 freshsave && \
    adduser --system --uid 1001 freshsave

WORKDIR /app

# Copy package files and install production deps only
COPY package*.json ./
COPY prisma ./prisma/

RUN npm ci --only=production && \
    npx prisma generate && \
    npm cache clean --force

# Copy built application
COPY --from=builder /app/dist ./dist

# Set ownership
RUN chown -R freshsave:freshsave /app

USER freshsave

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/api/v1/health || exit 1

CMD ["node", "dist/main.js"]
