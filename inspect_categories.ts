import { config } from 'dotenv';
config();
import { PrismaClient } from '@prisma/client';

async function main() {
  const prisma = new PrismaClient();

  try {
    const categories = await prisma.category.findMany({
      include: {
        _count: {
          select: { products: true, children: true }
        },
        parent: {
          select: { name: true }
        }
      }
    });
    
    console.log("Existing Categories:");
    categories.forEach(c => {
      console.log(`- ${c.name} (ID: ${c.id}, Parent: ${c.parent?.name || 'None'}, Products: ${c._count.products}, Subcategories: ${c._count.children})`);
    });
  } catch(e) {
    console.error(e);
  } finally {
    await prisma.$disconnect();
  }
}

main();
