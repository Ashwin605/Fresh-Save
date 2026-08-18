# FreshSave Database Documentation

## Overview

The FreshSave database schema is designed to be highly scalable, supporting multiple user roles, a complex business/store hierarchy, geographically aware location searches (using PostGIS), and an extensive catalog for grocery products and their discounted inventory.

The database is built on **PostgreSQL** and managed using **Prisma ORM**.

---

## Key Entities & Relationships

### 1. Identity & RBAC
- **User:** The central entity. Accounts are mapped to multiple roles (`CUSTOMER`, `SHOP_OWNER`, `SHOP_STAFF`, `ADMIN`, `SUPER_ADMIN`).
- **Business:** Represents a corporate entity or franchise owner. Owned by a `User` (shop owner).
- **Store:** A physical location of a Business. A Business can have multiple Stores.
- **StoreStaff:** Associates a `User` (staff) with a specific `Store`.

### 2. Catalog & Discovery
- **Category:** Self-referencing hierarchical product categories (e.g., Food -> Dairy -> Milk).
- **Product:** A generic item description (e.g., "Amul Milk 500ml"). Shared across all stores to maintain a clean catalog.

### 3. Inventory & Offers
- **Inventory:** A specific batch of a `Product` at a specific `Store`. This separates the product definition from its actual stock quantity and expiry date.
- **Offer:** A discount applied to an `Inventory` item for a specific duration.

### 4. Transactions
- **Reservation:** Created when a Customer reserves an item from a Store. Tracks status from `PENDING` to `COMPLETED` or `CANCELLED`.
- **ReservationItem:** A snapshot of an `Inventory` item at the time of reservation. It copies prices and discounts to ensure historical accuracy even if the offer or inventory changes later.

### 5. Customer Features
- **Wishlist & WishlistItem:** Customers can save a `Product` (not a specific store's inventory). This allows the application to notify the customer whenever any nearby store has an active offer for that product.
- **Address:** User's saved addresses.
- **Review:** Ratings and feedback for a Store or Product.

### 6. System
- **Notification:** System alerts or updates.
- **Coupon:** Centralized discount code configurations.
- **AuditLog:** Tracking sensitive actions and state changes across the system.

---

## Design Decisions

### Wishlist Relationship
`WishlistItem` links to `Product` rather than `Inventory`.
*Reasoning:* Inventory represents a specific, short-lived batch of an item at a specific store. Customers generally want to track a "Product" (like a favorite brand of bread) and be notified when it goes on sale at *any* nearby store.

### Reservation Snapshotting
`ReservationItem` copies the `unitPrice` and `discount` at the time of creation.
*Reasoning:* If a store owner changes the `Offer` or deletes the `Inventory` after a reservation is fulfilled, the historical receipt and revenue numbers must remain intact.

### Soft Deletion Strategy
Critical entities (`User`, `Business`, `Store`, `Product`, etc.) use a `deletedAt` field instead of being physically removed.
*Reasoning:* This prevents cascading deletes from wiping out related historical records, audit logs, or reservation history.

---

## PostGIS Geography Implementation

To support efficient geographic queries like *"Find active stores within 5 km"*, we are using PostGIS.

### Prisma Schema Setup
Prisma does not have full native support for PostGIS geography types in its standard operations, so we use the `Unsupported` type:
```prisma
location Unsupported("geography(Point, 4326)")?
```

### Creating the Index
We leverage Prisma's `Gist` index type directly in the schema:
```prisma
@@index([location], type: Gist)
```

### Querying
When querying for nearby stores, you must use Prisma's `$queryRaw` capability:
```typescript
const nearbyStores = await prisma.$queryRaw`
  SELECT id, name, ST_Distance(location, ST_MakePoint(${longitude}, ${latitude})::geography) AS distance
  FROM "Store"
  WHERE status = 'ACTIVE'
    AND ST_DWithin(location, ST_MakePoint(${longitude}, ${latitude})::geography, ${radiusInMeters})
  ORDER BY distance ASC;
`;
```

---

## Data Validation & Types
- **UUIDs:** Used for all primary keys to ensure global uniqueness and make ID guessing difficult.
- **Decimals:** Used for all monetary values (`sellingPrice`, `discountValue`, `subtotal`, etc.) via `@db.Decimal(10, 2)` to avoid floating-point math errors.
- **Enums:** Enforced natively at the PostgreSQL level for statuses and types to guarantee data integrity.
