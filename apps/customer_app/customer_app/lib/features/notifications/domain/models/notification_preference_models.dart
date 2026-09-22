class NotificationPreference {
  final String id;
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool inAppEnabled;
  final bool reservationUpdates;
  final bool offerAlerts;
  final bool inventoryAlerts;
  final bool marketingAlerts;

  NotificationPreference({
    required this.id,
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.inAppEnabled,
    required this.reservationUpdates,
    required this.offerAlerts,
    required this.inventoryAlerts,
    required this.marketingAlerts,
  });

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id'] as String,
      userId: json['userId'] as String,
      pushEnabled: json['pushEnabled'] as bool? ?? true,
      emailEnabled: json['emailEnabled'] as bool? ?? true,
      inAppEnabled: json['inAppEnabled'] as bool? ?? true,
      reservationUpdates: json['reservationUpdates'] as bool? ?? true,
      offerAlerts: json['offerAlerts'] as bool? ?? true,
      inventoryAlerts: json['inventoryAlerts'] as bool? ?? true,
      marketingAlerts: json['marketingAlerts'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pushEnabled': pushEnabled,
      'emailEnabled': emailEnabled,
      'inAppEnabled': inAppEnabled,
      'reservationUpdates': reservationUpdates,
      'offerAlerts': offerAlerts,
      'inventoryAlerts': inventoryAlerts,
      'marketingAlerts': marketingAlerts,
    };
  }
}
