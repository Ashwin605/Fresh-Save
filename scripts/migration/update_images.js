const { Client } = require('pg'); 
const client = new Client({ connectionString: 'postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true' }); 
const baseUrl = 'https://fresh-save-api.onrender.com/public/categories';
const mappings = [
  { name: 'Bakery', file: 'bakery.jpg' },
  { name: 'Dairy', file: 'dairy.jpg' },
  { name: 'Produce', file: 'produce.jpg' },
  { name: 'Meat & Seafood', file: 'meat.jpg' },
  { name: 'Beverages', file: 'beverage.jpg' },
  { name: 'Snacks', file: 'snack.jpg' },
  { name: 'Fruits', file: 'produce.jpg' },
  { name: 'Vegetables', file: 'produce.jpg' }
];

async function run() { 
  await client.connect(); 
  for (const m of mappings) {
    const res = await client.query('UPDATE "Category" SET image = $1 WHERE name ILIKE $2', [`${baseUrl}/${m.file}`, `%${m.name}%`]);
    console.log(`Updated ${res.rowCount} rows for ${m.name}`);
  }
  await client.end(); 
} 
run().catch(console.error);
