import { IsOptional, IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyPaymentDto {
  @ApiProperty({ description: 'Mock payment success status simulator', required: false })
  @IsOptional()
  @IsString()
  simulateStatus?: 'SUCCESS' | 'FAILED' | 'CANCELLED';
}
