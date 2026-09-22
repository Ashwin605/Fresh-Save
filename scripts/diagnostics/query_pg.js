const { Client } = require('pg');

async function main() {
  const client = new Client({
    connectionString: "postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true"
  });

  try {
    await client.connect();
    const res = await client.query('SELECT c.id, c.name, c.slug, c."parentId", (SELECT name FROM "Category" p WHERE p.id = c."parentId") as parent_name, (SELECT count(*) FROM "Product" p WHERE p."categoryId" = c.id) as product_count FROM "Category" c');
    console.log("Categories in DB:");
    for (let row of res.rows) {
      console.log(`- ${row.name} (ID: ${row.id}, Parent: ${row.parent_name || 'None'}, Products: ${row.product_count})`);
    }
  } catch (err) {
    console.error('Error executing query', err.stack);
  } finally {
    await client.end();
  }
}

main();
