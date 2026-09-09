import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';
import * as dotenv from 'dotenv';
dotenv.config();

const connectionString = process.env.DATABASE_URL;
if (!connectionString) {
  throw new Error("DATABASE_URL is not set");
}
const adapter = new PrismaPg({ connectionString });
const prisma = new PrismaClient({ adapter });

const baseUrl = 'https://fresh-save-api.onrender.com/public/categories';

async function main() {
  console.log('Seeding Clothing category...');
  
  // 1. Check if Clothing already exists
  let clothingCategory = await prisma.category.findFirst({
    where: { slug: 'clothing' }
  });

  if (!clothingCategory) {
    // Check by name as fallback
    clothingCategory = await prisma.category.findFirst({
      where: { name: { equals: 'Clothing', mode: 'insensitive' } }
    });
  }

  // 2. Upsert Clothing category
  if (clothingCategory) {
    console.log('Clothing category already exists, updating image...');
    clothingCategory = await prisma.category.update({
      where: { id: clothingCategory.id },
      data: { 
        image: `${baseUrl}/clothing.jpg`,
        description: 'Clothing and fashion essentials for men, women and children.'
      }
    });
  } else {
    console.log('Creating Clothing category...');
    clothingCategory = await prisma.category.create({
      data: { 
        name: 'Clothing', 
        slug: 'clothing',
        description: 'Clothing and fashion essentials for men, women and children.',
        image: `${baseUrl}/clothing.jpg`,
        sortOrder: 10
      }
    });
  }

  // 3. Upsert Subcategories
  const subcategories = [
    { name: "Men's Clothing", slug: 'mens-clothing' },
    { name: "Women's Clothing", slug: 'womens-clothing' },
    { name: "Kids' Clothing", slug: 'kids-clothing' },
    { name: "Accessories", slug: 'clothing-accessories' }
  ];

  for (const sub of subcategories) {
    let subCat = await prisma.category.findFirst({
      where: { slug: sub.slug }
    });

    if (!subCat) {
      console.log(`Creating subcategory: ${sub.name}...`);
      await prisma.category.create({
        data: {
          name: sub.name,
          slug: sub.slug,
          parentId: clothingCategory.id
        }
      });
    } else {
      console.log(`Subcategory ${sub.name} already exists.`);
    }
  }

  console.log('Seeding completed successfully!');
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
