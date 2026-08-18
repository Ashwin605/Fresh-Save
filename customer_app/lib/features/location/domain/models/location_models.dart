enum LocationStatus {
  unknown,
  detecting,
  available,
  denied,
  deniedForever,
  servicesDisabled,
  error,
}

enum LocationSource { gps, manual, cache }

class UserLocation {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;
  final LocationSource source;
  final String? addressName;

  const UserLocation({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
    required this.source,
    this.addressName,
  });

  UserLocation copyWith({
    double? latitude,
    double? longitude,
    double? accuracy,
    DateTime? timestamp,
    LocationSource? source,
    String? addressName,
  }) {
    return UserLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      addressName: addressName ?? this.addressName,
    );
  }

  bool get isStale {
    // 15 minutes freshness policy
    final difference = DateTime.now().difference(timestamp);
    return difference.inMinutes > 15;
  }
}
