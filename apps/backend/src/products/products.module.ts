import { Module } from '@nestjs/common';
import { CategoriesService } from './categories/categories.service';
import { CategoriesController } from './categories/categories.controller';
import { ProductsService } from './products/products.service';
import { ProductsController } from './products/products.controller';
import { StoreProductsService } from './store-products/store-products.service';
import { StoreProductsController } from './store-products/store-products.controller';
import { InventoryModule } from '../inventory/inventory.module';

@Module({
  imports: [InventoryModule],
  controllers: [CategoriesController, ProductsController, StoreProductsController],
  providers: [CategoriesService, ProductsService, StoreProductsService],
  exports: [CategoriesService, ProductsService, StoreProductsService],
})
export class ProductsModule {}
