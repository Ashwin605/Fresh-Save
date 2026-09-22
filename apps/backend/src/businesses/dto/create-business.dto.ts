import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateBusinessDto {
  @ApiProperty({ example: 'FreshMart' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(100)
  businessName!: string;

  @ApiPropertyOptional({ example: 'FreshMart LLC' })
  @IsString()
  @IsOptional()
  @MaxLength(100)
  legalName?: string;

  @ApiPropertyOptional({ example: 'Grocery Store' })
  @IsString()
  @IsOptional()
  @MaxLength(50)
  businessType?: string;

  @ApiPropertyOptional({ example: 'hello@freshmart.com' })
  @IsEmail()
  @IsOptional()
  contactEmail?: string;

  @ApiPropertyOptional({ example: '+1234567890' })
  @IsString()
  @IsOptional()
  @MaxLength(20)
  contactPhone?: string;
}
