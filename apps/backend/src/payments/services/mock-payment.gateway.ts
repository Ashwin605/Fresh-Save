import { Injectable } from '@nestjs/common';
import { PaymentGateway } from '../interfaces/payment-gateway.interface';
import { v4 as uuidv4 } from 'uuid';

@Injectable()
export class MockPaymentGateway implements PaymentGateway {
  async createPayment(orderId: string, amount: number, currency: string) {
    // In a real gateway, this would call Stripe/Razorpay API
    return {
      paymentId: `mock_pay_${uuidv4()}`,
      status: 'PROCESSING'
    };
  }

  async verifyPayment(paymentId: string) {
    // In a real gateway, this would verify the status with the provider
    // For mock, we'll just simulate a SUCCESS
    return {
      status: 'SUCCESS'
    };
  }
}
