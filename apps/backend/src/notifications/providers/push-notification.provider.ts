export interface PushNotificationPayload {
  token: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

export abstract class PushNotificationProvider {
  /**
   * Sends a push notification to a specific device token.
   * @param payload The push notification content and target token.
   * @returns true if successfully queued/sent to provider, false otherwise.
   */
  abstract send(payload: PushNotificationPayload): Promise<boolean>;
}
