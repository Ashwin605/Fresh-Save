const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function fix() {
  // 1. Verify all businesses
  await prisma.business.updateMany({
    where: { verificationStatus: 'PENDING' },
    data: { verificationStatus: 'VERIFIED' }
  });

  // 2. Verify all stores
  await prisma.store.updateMany({
    where: { verificationStatus: 'PENDING' },
    data: { verificationStatus: 'VERIFIED' }
  });

  // 3. Give dummy location to any store without it so it shows up in discovery
  // Assuming latitude and longitude are currently null
  const lat = 40.7128;
  const lng = -74.0060;

  await prisma.$executeRawUnsafe(`
    UPDATE "Store"
    SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
        latitude = $2,
        longitude = $1
    WHERE location IS NULL
  `, lng, lat);

  console.log('Fixed existing stores!');
}

fix()
  .catch(e => console.error(e))
  .finally(() => prisma.$disconnect());
