const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {
  const categories = await prisma.category.findMany({
    take: 5,
    include: {
      _count: {
        select: { products: true }
      }
    }
  });

  console.log('--- CATEGORIES ---');
  for (const cat of categories) {
    console.log(`ID: ${cat.id} | Name: ${cat.name} | Products Count: ${cat._count.products}`);
  }

  // Find a category that actually has products
  const categoryWithProducts = categories.find(c => c._count.products > 0);
  
  if (categoryWithProducts) {
    console.log('\n--- PRODUCTS FOR CATEGORY:', categoryWithProducts.name, '---');
    const products = await prisma.product.findMany({
      where: { categoryId: categoryWithProducts.id },
      take: 2,
    });
    console.log(JSON.stringify(products, null, 2));
  } else {
    console.log('\nNo products found in the first 5 categories.');
  }
}

main()
  .catch(e => console.error(e))
  .finally(() => prisma.$disconnect());
