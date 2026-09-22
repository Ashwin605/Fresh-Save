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

const mappings = [
  { name: 'Bakery', file: 'bakery.jpg' },
  { name: 'Dairy & Eggs', file: 'dairy.jpg' },
  { name: 'Produce', file: 'produce.jpg' },
  { name: 'Meat & Seafood', file: 'meat.jpg' },
  { name: 'Beverages', file: 'beverage.jpg' },
  { name: 'Snacks', file: 'snack.jpg' }
];

async function main() {
  console.log('Seeding category images...');
  for (const mapping of mappings) {
    const category = await prisma.category.findFirst({
      where: { name: { contains: mapping.name.split(' ')[0], mode: 'insensitive' } }
    });

    if (category) {
      await prisma.category.update({
        where: { id: category.id },
        data: { image: `${baseUrl}/${mapping.file}` }
      });
      console.log(`Updated ${category.name} with image ${mapping.file}`);
    } else {
      console.log(`Category matching ${mapping.name} not found!`);
    }
  }
}

main()
  .catch(e => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
