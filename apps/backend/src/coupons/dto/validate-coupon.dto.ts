import { IsString, IsNotEmpty, IsNumber, Min, IsOptional } from 'class-validator';

export class ValidateCouponDto {
  @IsString()
  @IsNotEmpty()
  code!: string;

  @IsString()
  @IsOptional()
  storeId?: string; 

  @IsNumber()
  @Min(0)
  subtotal!: number;
}
