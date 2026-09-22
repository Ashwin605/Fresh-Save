import { IsString, IsEnum, IsOptional } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { DevicePlatform } from '@prisma/client';

export class CreateDeviceDto {
  @ApiProperty({
    description: 'The device notification token (e.g. FCM token)',
  })
  @IsString()
  deviceToken!: string;

  @ApiProperty({
    enum: DevicePlatform,
    description: 'The platform of the device',
  })
  @IsEnum(DevicePlatform)
  platform!: DevicePlatform;

  @ApiPropertyOptional({
    description: 'The version of the app installed on the device',
  })
  @IsString()
  @IsOptional()
  appVersion?: string;
}
