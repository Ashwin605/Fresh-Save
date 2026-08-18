export interface EmailNotificationPayload {
  to: string;
  subject: string;
  text: string;
  html?: string;
}

export abstract class EmailNotificationProvider {
  /**
   * Sends an email to a specific address.
   * @param payload The email content and recipient.
   * @returns true if successfully sent to provider, false otherwise.
   */
  abstract send(payload: EmailNotificationPayload): Promise<boolean>;
}
