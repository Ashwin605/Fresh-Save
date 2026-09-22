import { IsBoolean, IsOptional } from 'class-validator';
import { ApiPropertyOptional } from '@nestjs/swagger';

export class UpdatePreferenceDto {
  @ApiPropertyOptional({ description: 'Enable/disable push notifications' })
  @IsBoolean()
  @IsOptional()
  pushEnabled?: boolean;

  @ApiPropertyOptional({ description: 'Enable/disable email notifications' })
  @IsBoolean()
  @IsOptional()
  emailEnabled?: boolean;

  @ApiPropertyOptional({ description: 'Enable/disable in-app notifications' })
  @IsBoolean()
  @IsOptional()
  inAppEnabled?: boolean;

  @ApiPropertyOptional({ description: 'Receive reservation updates' })
  @IsBoolean()
  @IsOptional()
  reservationUpdates?: boolean;

  @ApiPropertyOptional({ description: 'Receive offer alerts' })
  @IsBoolean()
  @IsOptional()
  offerAlerts?: boolean;

  @ApiPropertyOptional({ description: 'Receive inventory critical alerts' })
  @IsBoolean()
  @IsOptional()
  inventoryAlerts?: boolean;

  @ApiPropertyOptional({ description: 'Receive promotional/marketing alerts' })
  @IsBoolean()
  @IsOptional()
  marketingAlerts?: boolean;
}
