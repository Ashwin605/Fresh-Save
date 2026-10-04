export interface PaymentGateway {
  createPayment(orderId: string, amount: number, currency: string): Promise<{ paymentId: string; status: string }>;
  verifyPayment(paymentId: string): Promise<{ status: string }>;
}
