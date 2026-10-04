import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { DatabaseService } from '../database/database.service';
import { MockPaymentGateway } from './services/mock-payment.gateway';
import { PaymentStatus, ReservationStatus } from '@prisma/client';

@Injectable()
export class PaymentsService {
  constructor(
    private readonly db: DatabaseService,
    private readonly paymentGateway: MockPaymentGateway,
  ) {}

  async createPayment(userId: string, reservationId: string) {
    const reservation = await this.db.reservation.findFirst({
      where: { id: reservationId, customerId: userId }
    });

    if (!reservation) {
      throw new NotFoundException('Order not found');
    }

    if (reservation.status !== ReservationStatus.PENDING) {
      throw new BadRequestException('Order is not pending');
    }

    // Check if payment already exists
    const existingPayment = await this.db.payment.findFirst({
      where: { reservationId: reservation.id, status: PaymentStatus.PROCESSING }
    });
    if (existingPayment) {
      return existingPayment;
    }

    // Call mock gateway
    const amount = Number(reservation.totalAmount);
    const result = await this.paymentGateway.createPayment(reservation.id, amount, 'USD');

    // Store in DB
    const payment = await this.db.payment.create({
      data: {
        reservationId: reservation.id,
        amount: reservation.totalAmount,
        currency: 'USD',
        provider: 'mock_gateway',
        providerPaymentId: result.paymentId,
        status: PaymentStatus.PROCESSING,
      }
    });

    return payment;
  }

  async verifyPayment(userId: string, paymentId: string, simulateStatus?: string) {
    const payment = await this.db.payment.findUnique({
      where: { id: paymentId },
      include: { reservation: true }
    });

    if (!payment) {
      throw new NotFoundException('Payment not found');
    }

    if (payment.reservation.customerId !== userId) {
      throw new NotFoundException('Payment not found');
    }

    // Call mock gateway
    const result = await this.paymentGateway.verifyPayment(payment.providerPaymentId || '');
    
    let finalStatus = PaymentStatus.SUCCESS;
    
    // Allow frontend to simulate failures for testing purposes
    if (simulateStatus === 'FAILED') finalStatus = PaymentStatus.FAILED;
    else if (simulateStatus === 'CANCELLED') finalStatus = PaymentStatus.CANCELLED;
    else if (simulateStatus === 'SUCCESS') finalStatus = PaymentStatus.SUCCESS;
    else finalStatus = result.status === 'SUCCESS' ? PaymentStatus.SUCCESS : PaymentStatus.FAILED;

    const updatedPayment = await this.db.payment.update({
      where: { id: payment.id },
      data: { status: finalStatus }
    });

    if (finalStatus === PaymentStatus.SUCCESS) {
      // Mark reservation as paid/confirmed conceptually
      // Here FreshSave uses CONFIRMED for paid orders
      await this.db.reservation.update({
        where: { id: payment.reservationId },
        data: { 
          status: ReservationStatus.CONFIRMED,
          confirmedAt: new Date()
        }
      });
    }

    return updatedPayment;
  }
}
