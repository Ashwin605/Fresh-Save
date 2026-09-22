import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  MinLength,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class RegisterBusinessDto {
  @ApiProperty({ example: 'John Doe' })
  @IsString()
  @IsNotEmpty()
  ownerName!: string;

  @ApiProperty({ example: 'john@business.com' })
  @IsEmail()
  email!: string;

  @ApiProperty({ example: '+1234567890', required: false })
  @IsString()
  @IsOptional()
  phone?: string;

  @ApiProperty({ example: 'strongPassword123' })
  @IsString()
  @MinLength(8)
  password!: string;

  @ApiProperty({ example: 'John Groceries Ltd' })
  @IsString()
  @IsNotEmpty()
  businessName!: string;

  @ApiProperty({ example: 'Main St Store' })
  @IsString()
  @IsNotEmpty()
  storeName!: string;

  @ApiProperty({ example: '123 Main St, City' })
  @IsString()
  @IsNotEmpty()
  storeAddress!: string;

  @ApiProperty({ example: 40.7128, required: false })
  @IsOptional()
  latitude?: number;

  @ApiProperty({ example: -74.0060, required: false })
  @IsOptional()
  longitude?: number;
}
