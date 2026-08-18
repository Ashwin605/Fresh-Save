const { Client } = require('pg');
const client = new Client({ connectionString: 'postgresql://postgres:ashwinsri%402008@localhost:5432/freshsave' });
async function run() {
  await client.connect();
  const res = await client.query('SELECT name, latitude, longitude, ST_AsText(location) as loc, "verificationStatus" FROM "Store" ORDER BY "createdAt" DESC LIMIT 5;');
  console.log(JSON.stringify(res.rows, null, 2));
  await client.end();
}
run().catch(e => console.error(e));
