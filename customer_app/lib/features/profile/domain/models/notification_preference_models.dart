class NotificationPreferences {
  final bool pushEnabled;
  final bool emailEnabled;
  final bool inAppEnabled;
  final bool reservationUpdates;
  final bool offerAlerts;
  final bool inventoryAlerts;
  final bool marketingAlerts;

  const NotificationPreferences({
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.inAppEnabled = true,
    this.reservationUpdates = true,
    this.offerAlerts = true,
    this.inventoryAlerts = false,
    this.marketingAlerts = false,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      pushEnabled: json['pushEnabled'] ?? true,
      emailEnabled: json['emailEnabled'] ?? true,
      inAppEnabled: json['inAppEnabled'] ?? true,
      reservationUpdates: json['reservationUpdates'] ?? true,
      offerAlerts: json['offerAlerts'] ?? true,
      inventoryAlerts: json['inventoryAlerts'] ?? false,
      marketingAlerts: json['marketingAlerts'] ?? false,
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

  NotificationPreferences copyWith({
    bool? pushEnabled,
    bool? emailEnabled,
    bool? inAppEnabled,
    bool? reservationUpdates,
    bool? offerAlerts,
    bool? inventoryAlerts,
    bool? marketingAlerts,
  }) {
    return NotificationPreferences(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      inAppEnabled: inAppEnabled ?? this.inAppEnabled,
      reservationUpdates: reservationUpdates ?? this.reservationUpdates,
      offerAlerts: offerAlerts ?? this.offerAlerts,
      inventoryAlerts: inventoryAlerts ?? this.inventoryAlerts,
      marketingAlerts: marketingAlerts ?? this.marketingAlerts,
    );
  }
}
