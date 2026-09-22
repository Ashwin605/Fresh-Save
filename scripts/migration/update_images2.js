const { Client } = require('pg'); 
const client = new Client({ connectionString: 'postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true' }); 
const mappings = [
  { name: 'Bakery', url: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80' },
  { name: 'Dairy', url: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=400&q=80' },
  { name: 'Produce', url: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80' },
  { name: 'Meat & Seafood', url: 'https://images.unsplash.com/photo-1607623814075-e51df1bd632f?w=400&q=80' },
  { name: 'Beverages', url: 'https://images.unsplash.com/photo-1527661591475-527312dd65f5?w=400&q=80' },
  { name: 'Snacks', url: 'https://images.unsplash.com/photo-1599490659213-e2b9527bd087?w=400&q=80' },
  { name: 'Fruits', url: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80' },
  { name: 'Vegetables', url: 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&q=80' },
  { name: 'Food', url: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&q=80' },
  { name: 'Frozen', url: 'https://images.unsplash.com/photo-1579291196160-58c07e0c4b69?w=400&q=80' },
  { name: 'Household', url: 'https://images.unsplash.com/photo-1585421514284-efb74c2b69ba?w=400&q=80' },
  { name: 'Personal Care', url: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=400&q=80' },
  { name: 'Pet Supplies', url: 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=400&q=80' }
];

async function run() { 
  await client.connect(); 
  for (const m of mappings) {
    const res = await client.query('UPDATE "Category" SET image = $1 WHERE name ILIKE $2', [m.url, '%' + m.name + '%']);
    console.log('Updated ' + res.rowCount + ' rows for ' + m.name);
  }
  await client.end(); 
} 
run().catch(console.error);
