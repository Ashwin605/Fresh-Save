const fs = require('fs');

const files = [
  'src/common/outbox/outbox-processor.service.ts',
  'src/notifications/providers/fcm-push.provider.ts',
  'src/notifications/providers/smtp-email.provider.ts',
  'src/notifications/services/notification-consumer.ts',
  'src/notifications/services/notifications.service.ts'
];

files.forEach(file => {
  if (fs.existsSync(file)) {
    let content = fs.readFileSync(file, 'utf8');
    // Fix backticks
    content = content.replace(/\\\`/g, '`');
    // Fix dollars
    content = content.replace(/\\\$/g, '$');
    // Fix apostrophes
    content = content.replace(/\\'/g, "'");
    fs.writeFileSync(file, content);
    console.log(`Fixed ${file}`);
  }
});
