import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEmail,
  IsEnum,
  IsBoolean,
  MaxLength,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { StoreStatus } from '@prisma/client';

export class AdminCreateStoreDto {
  @ApiProperty({ example: 'My Store' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(200)
  name!: string;

  @ApiPropertyOptional({ example: '123 Main St' })
  @IsString()
  @IsOptional()
  @MaxLength(500)
  address?: string;

  @ApiPropertyOptional({ example: '+1234567890' })
  @IsString()
  @IsOptional()
  @MaxLength(20)
  phone?: string;

  @ApiPropertyOptional({ example: 'store@example.com' })
  @IsEmail()
  @IsOptional()
  @MaxLength(255)
  email?: string;

  @ApiPropertyOptional({ example: 'A great local store' })
  @IsString()
  @IsOptional()
  @MaxLength(2000)
  description?: string;
}

export class AdminCreateStoreRequestDto {
  @ApiProperty({ example: 'owner@example.com' })
  @IsEmail()
  @IsNotEmpty()
  @MaxLength(255)
  ownerEmail!: string;

  @ApiProperty({ type: AdminCreateStoreDto })
  @IsNotEmpty()
  storeData!: AdminCreateStoreDto;

  @ApiPropertyOptional({ example: false })
  @IsBoolean()
  @IsOptional()
  verifyInstantly?: boolean;
}

export class AdminUpdateStoreDto {
  @ApiPropertyOptional({ example: 'Updated Store Name' })
  @IsString()
  @IsOptional()
  @MaxLength(200)
  name?: string;

  @ApiPropertyOptional({ example: '456 Oak Ave' })
  @IsString()
  @IsOptional()
  @MaxLength(500)
  address?: string;

  @ApiPropertyOptional({ example: '+9876543210' })
  @IsString()
  @IsOptional()
  @MaxLength(20)
  phone?: string;

  @ApiPropertyOptional({ example: 'updated@example.com' })
  @IsEmail()
  @IsOptional()
  @MaxLength(255)
  email?: string;
}

export class AdminUpdateStoreStatusDto {
  @ApiProperty({ enum: StoreStatus })
  @IsEnum(StoreStatus, {
    message: `Status must be one of: ${Object.values(StoreStatus).join(', ')}`,
  })
  @IsNotEmpty()
  status!: StoreStatus;
}

export class SuspendUserDto {
  @ApiProperty({ example: 'Violated terms of service' })
  @IsString()
  @IsNotEmpty()
  @MaxLength(1000)
  reason!: string;
}
