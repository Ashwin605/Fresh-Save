import { NestFactory } from '@nestjs/core';
import { AppModule } from './src/app.module';
import { PrismaService } from './src/database/prisma/prisma.service';

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);
  const prisma = app.get(PrismaService);
  
  try {
    const categories = await prisma.category.findMany({
      include: {
        _count: {
          select: { products: true, children: true }
        },
        parent: {
          select: { name: true }
        }
      }
    });
    
    console.log("Existing Categories:");
    categories.forEach(c => {
      console.log(`- ${c.name} (ID: ${c.id}, Parent: ${c.parent?.name || 'None'}, Products: ${c._count.products}, Subcategories: ${c._count.children})`);
    });
  } catch(e) {
    console.error(e);
  } finally {
    await app.close();
  }
}

bootstrap();
