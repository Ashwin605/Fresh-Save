const { Client } = require('pg');
const client = new Client({ connectionString: 'postgresql://postgres:ashwinsri%402008@localhost:5432/freshsave' });

async function fix() {
  await client.connect();
  
  // Update verification status for all
  await client.query('UPDATE "Business" SET "verificationStatus" = \'VERIFIED\' WHERE "verificationStatus" = \'PENDING\'');
  await client.query('UPDATE "Store" SET "verificationStatus" = \'VERIFIED\' WHERE "verificationStatus" = \'PENDING\'');

  // Guntakal, Andhra Pradesh coordinates
  const lat = 15.1674;
  const lng = 77.3833;

  await client.query(`
    UPDATE "Store"
    SET location = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography,
        latitude = $2,
        longitude = $1
    WHERE location IS NULL
  `, [lng, lat]);

  console.log('Successfully fixed database stores!');
  await client.end();
}

fix().catch(e => console.error(e));
