const fs = require('fs');

function replaceInFile(path, replacements) {
  if (fs.existsSync(path)) {
    let content = fs.readFileSync(path, 'utf8');
    for (const [find, replace] of replacements) {
      content = content.replace(find, replace);
    }
    fs.writeFileSync(path, content);
    console.log(`Updated ${path}`);
  }
}

// 1. Inventory Module
replaceInFile('src/inventory/inventory.module.ts', [
  [/import { StockMovementService } from '.\/services\/stock-movement.service';\n/g, ''],
  [/StockMovementService, /g, ''],
  [/, StockMovementService/g, '']
]);

// 2. Notifications Module
replaceInFile('src/notifications/notifications.module.ts', [
  [/\.\.\/\.\.\/database\/database.module/g, '../database/database.module']
]);

// 3. Outbox Processor Error
replaceInFile('src/common/outbox/outbox-processor.service.ts', [
  [/} catch \(error\) {/g, '} catch (error: any) {']
]);

// 4. Providers Error
replaceInFile('src/notifications/providers/fcm-push.provider.ts', [
  [/} catch \(error\) {/g, '} catch (error: any) {']
]);
replaceInFile('src/notifications/providers/smtp-email.provider.ts', [
  [/} catch \(error\) {/g, '} catch (error: any) {']
]);
replaceInFile('src/notifications/services/notification-consumer.ts', [
  [/} catch \(error\) {/g, '} catch (error: any) {']
]);

// 5. DTOs definite assignment
replaceInFile('src/notifications/dto/create-device.dto.ts', [
  [/deviceToken: string;/g, 'deviceToken!: string;'],
  [/platform: DevicePlatform;/g, 'platform!: DevicePlatform;']
]);

replaceInFile('src/offers/dto/create-offer.dto.ts', [
  [/discountType: string;/g, 'discountType!: string;'],
  [/discountValue: number;/g, 'discountValue!: number;'],
  [/startsAt: Date;/g, 'startsAt!: Date;'],
  [/endsAt: Date;/g, 'endsAt!: Date;']
]);

