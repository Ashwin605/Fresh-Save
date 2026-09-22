const { Client } = require('pg');
const argon2 = require('argon2');

const client = new Client({ connectionString: 'postgresql://postgres.jgtuohzsvbkvjgnmuldv:ashwinsri%402008@aws-0-ap-northeast-2.pooler.supabase.com:6543/postgres?pgbouncer=true' });

async function main() {
  try {
    await client.connect();
    const hash = await argon2.hash('admin123');
    await client.query('UPDATE "User" SET password = $1 WHERE email = \'admin@freshsave.local\'', [hash]);
    console.log('Password updated successfully for admin@freshsave.local to: admin123');
  } catch (err) {
    console.error('Error:', err);
  } finally {
    await client.end();
  }
}

main();
