const { Client } = require('pg');

async function migrate() {
  const client = new Client({
    connectionString: "postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true"
  });

  try {
    await client.connect();
    
    // Start transaction
    await client.query('BEGIN');

    console.log("Promoting Dairy & Bakery...");
    await client.query(`UPDATE "Category" SET "parentId" = null, name = 'Dairy & Eggs', slug = 'dairy-eggs' WHERE name = 'Dairy'`);
    await client.query(`UPDATE "Category" SET "parentId" = null WHERE name = 'Bakery'`);

    console.log("Renaming existing top-level categories...");
    await client.query(`UPDATE "Category" SET name = 'Groceries', slug = 'groceries' WHERE name = 'Food'`);
    await client.query(`UPDATE "Category" SET name = 'Food & Snacks', slug = 'food-snacks' WHERE name = 'Snacks'`);
    await client.query(`UPDATE "Category" SET name = 'Fruits & Vegetables', slug = 'fruits-vegetables' WHERE name = 'Produce'`);
    await client.query(`UPDATE "Category" SET name = 'Frozen & Ready-to-Eat', slug = 'frozen-ready-to-eat' WHERE name = 'Frozen'`);
    await client.query(`UPDATE "Category" SET name = 'Baby & Pet Care', slug = 'baby-pet-care' WHERE name = 'Pet Supplies'`);

    console.log("Flattening Meat & Seafood...");
    // Make Meat & Seafood a subcategory of Groceries
    await client.query(`UPDATE "Category" SET "parentId" = (SELECT id FROM "Category" WHERE name = 'Groceries' LIMIT 1) WHERE name = 'Meat & Seafood'`);
    
    // Make Meat & Seafood's old children also direct children of Groceries to avoid 3-level depth
    await client.query(`UPDATE "Category" SET "parentId" = (SELECT id FROM "Category" WHERE name = 'Groceries' LIMIT 1) WHERE "parentId" = (SELECT id FROM "Category" WHERE name = 'Meat & Seafood' LIMIT 1)`);

    await client.query('COMMIT');
    console.log("Migration committed successfully!");

  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error executing migration, rolled back:', err.stack);
  } finally {
    await client.end();
  }
}

migrate();
