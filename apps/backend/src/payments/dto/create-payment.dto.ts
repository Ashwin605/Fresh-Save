import { IsNotEmpty, IsUUID } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreatePaymentDto {
  @ApiProperty({ description: 'Reservation (Order) ID' })
  @IsNotEmpty()
  @IsUUID()
  reservationId: string;
}
