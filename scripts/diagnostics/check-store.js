const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
async function run() {
  const store = await prisma.store.findFirst({
    where: { name: 'pavan store main branch' }
  });
  console.log(store);
}
run().finally(() => prisma.$disconnect());
