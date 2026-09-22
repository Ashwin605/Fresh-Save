const { Client } = require('pg'); 
const client = new Client({ connectionString: 'postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true' }); 
async function run() { 
  await client.connect(); 
  const res = await client.query('SELECT id, name, image FROM "Category"'); 
  console.log(JSON.stringify(res.rows, null, 2)); 
  await client.end(); 
} 
run().catch(console.error);
