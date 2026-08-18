import { PrismaClient, Prisma } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as dotenv from 'dotenv';
dotenv.config();

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error("DATABASE_URL is not set");
}
const adapter = new PrismaPg({ connectionString });
const prisma = new PrismaClient({ adapter });

async function main() {
  console.log('Starting seed...');

  // --- Cleanup ---
  await prisma.offer.deleteMany();
  await prisma.inventory.deleteMany();
  await prisma.product.deleteMany();
  await prisma.category.deleteMany();
  await prisma.storeStaff.deleteMany();
  await prisma.store.deleteMany();
  await prisma.business.deleteMany();
  await prisma.user.deleteMany();

  // --- Users ---
  const admin = await prisma.user.create({
    data: { name: 'System Admin', email: 'admin@freshsave.local', role: 'SUPER_ADMIN' },
  });

  const shopOwner = await prisma.user.create({
    data: { name: 'Jane Owner', email: 'jane.owner@freshsave.local', role: 'SHOP_OWNER' },
  });

  const shopStaff = await prisma.user.create({
    data: { name: 'Bob Staff', email: 'bob.staff@freshsave.local', role: 'SHOP_STAFF' },
  });

  const customer1 = await prisma.user.create({
    data: { name: 'Alice Customer', email: 'alice@example.com', role: 'CUSTOMER' },
  });

  const customer2 = await prisma.user.create({
    data: { name: 'Charlie Customer', email: 'charlie@example.com', role: 'CUSTOMER' },
  });

  // --- Businesses & Stores ---
  const business = await prisma.business.create({
    data: { businessName: 'Jane Groceries Ltd', ownerId: shopOwner.id, verificationStatus: 'VERIFIED' },
  });

  const store1 = await prisma.store.create({
    data: { businessId: business.id, name: 'Jane Groceries - Downtown', address: '123 Main St, Downtown', verificationStatus: 'VERIFIED' },
  });
  
  const store2 = await prisma.store.create({
    data: { businessId: business.id, name: 'Jane Groceries - Uptown', address: '456 High St, Uptown', verificationStatus: 'VERIFIED' },
  });

  await prisma.storeStaff.create({
    data: { storeId: store1.id, userId: shopStaff.id, role: 'MANAGER' },
  });

  // --- Categories ---
  const foodCategory = await prisma.category.create({ data: { name: 'Food', slug: 'food' } });
  const dairyCategory = await prisma.category.create({ data: { name: 'Dairy', slug: 'dairy', parentId: foodCategory.id } });
  const bakeryCategory = await prisma.category.create({ data: { name: 'Bakery', slug: 'bakery', parentId: foodCategory.id } });
  
  // Add many more categories!
  const produceCategory = await prisma.category.create({ data: { name: 'Produce', slug: 'produce' } });
  await prisma.category.create({ data: { name: 'Fruits', slug: 'fruits', parentId: produceCategory.id } });
  await prisma.category.create({ data: { name: 'Vegetables', slug: 'vegetables', parentId: produceCategory.id } });

  const meatCategory = await prisma.category.create({ data: { name: 'Meat & Seafood', slug: 'meat-seafood' } });
  await prisma.category.create({ data: { name: 'Poultry', slug: 'poultry', parentId: meatCategory.id } });
  await prisma.category.create({ data: { name: 'Beef & Pork', slug: 'beef-pork', parentId: meatCategory.id } });
  await prisma.category.create({ data: { name: 'Seafood', slug: 'seafood', parentId: meatCategory.id } });

  const beverageCategory = await prisma.category.create({ data: { name: 'Beverages', slug: 'beverages' } });
  await prisma.category.create({ data: { name: 'Water', slug: 'water', parentId: beverageCategory.id } });
  await prisma.category.create({ data: { name: 'Juice', slug: 'juice', parentId: beverageCategory.id } });
  await prisma.category.create({ data: { name: 'Coffee & Tea', slug: 'coffee-tea', parentId: beverageCategory.id } });

  const snacksCategory = await prisma.category.create({ data: { name: 'Snacks', slug: 'snacks' } });
  await prisma.category.create({ data: { name: 'Chips', slug: 'chips', parentId: snacksCategory.id } });
  await prisma.category.create({ data: { name: 'Cookies', slug: 'cookies', parentId: snacksCategory.id } });
  await prisma.category.create({ data: { name: 'Candy', slug: 'candy', parentId: snacksCategory.id } });

  const frozenCategory = await prisma.category.create({ data: { name: 'Frozen', slug: 'frozen' } });
  await prisma.category.create({ data: { name: 'Ice Cream', slug: 'ice-cream', parentId: frozenCategory.id } });
  await prisma.category.create({ data: { name: 'Frozen Meals', slug: 'frozen-meals', parentId: frozenCategory.id } });

  const householdCategory = await prisma.category.create({ data: { name: 'Household', slug: 'household' } });
  await prisma.category.create({ data: { name: 'Cleaning', slug: 'cleaning', parentId: householdCategory.id } });
  await prisma.category.create({ data: { name: 'Paper Products', slug: 'paper-products', parentId: householdCategory.id } });

  const personalCareCategory = await prisma.category.create({ data: { name: 'Personal Care', slug: 'personal-care' } });
  await prisma.category.create({ data: { name: 'Hair Care', slug: 'hair-care', parentId: personalCareCategory.id } });
  await prisma.category.create({ data: { name: 'Oral Care', slug: 'oral-care', parentId: personalCareCategory.id } });
  await prisma.category.create({ data: { name: 'Soap & Body Wash', slug: 'soap-body-wash', parentId: personalCareCategory.id } });

  const petCategory = await prisma.category.create({ data: { name: 'Pet Supplies', slug: 'pet-supplies' } });
  await prisma.category.create({ data: { name: 'Dog Food', slug: 'dog-food', parentId: petCategory.id } });
  await prisma.category.create({ data: { name: 'Cat Food', slug: 'cat-food', parentId: petCategory.id } });

  // --- Products ---
  const milkProduct = await prisma.product.create({
    data: { categoryId: dairyCategory.id, name: 'Amul Taaza Milk 500ml', slug: 'amul-taaza-milk-500ml', sku: 'AMUL-MILK-500' },
  });

  const breadProduct = await prisma.product.create({
    data: { categoryId: bakeryCategory.id, name: 'Britannia Whole Wheat Bread', slug: 'britannia-whole-wheat-bread', sku: 'BRIT-BREAD-WW' },
  });

  // --- Inventory ---
  const today = new Date();
  const nextWeek = new Date(today);
  nextWeek.setDate(today.getDate() + 7);
  const tomorrow = new Date(today);
  tomorrow.setDate(today.getDate() + 1);

  const milkInventory = await prisma.inventory.create({
    data: { storeId: store1.id, productId: milkProduct.id, stockQuantity: 50, originalPrice: 30.0, sellingPrice: 30.0, expiryDate: tomorrow, batchNumber: 'BATCH-MILK-1' },
  });

  const breadInventory = await prisma.inventory.create({
    data: { storeId: store1.id, productId: breadProduct.id, stockQuantity: 20, originalPrice: 40.0, sellingPrice: 40.0, expiryDate: nextWeek, batchNumber: 'BATCH-BREAD-1' },
  });

  // --- Offers ---
  const milkOffer = await prisma.offer.create({
    data: {
      inventoryId: milkInventory.id,
      discountType: 'PERCENTAGE',
      discountValue: 50.0,
      originalPriceSnapshot: 30.0,
      discountAmount: 15.0,
      discountedPrice: 15.0,
      startsAt: today,
      endsAt: tomorrow,
      createdById: shopOwner.id,
    },
  });

  console.log('Seed completed successfully.');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
