const { Client } = require('pg'); 
const client = new Client({ connectionString: 'postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true' }); 
async function main() { 
  await client.connect(); 
  const res = await client.query('SELECT email, password FROM "User" WHERE email = \'admin@freshsave.local\''); 
  console.log(res.rows); 
  await client.end(); 
} 
main();
