const { Client } = require('pg');
const client = new Client({ connectionString: 'postgresql://postgres:ashwinsri%402008@localhost:5432/freshsave' });

async function deleteFakes() {
  await client.connect();
  
  // Delete mock data
  const res = await client.query(`
    DELETE FROM "Store" 
    WHERE name ILIKE '%test%' 
       OR name ILIKE '%jane%'
       OR name ILIKE '%mock%'
       OR name ILIKE '%sample%'
    RETURNING name;
  `);

  console.log('Deleted stores:', res.rows.map(r => r.name));
  await client.end();
}

deleteFakes().catch(e => console.error(e));
