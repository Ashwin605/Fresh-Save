class OwnerBusiness {
  final String id;
  final String name;
  final String? legalName;
  final String? businessType;
  final String? contactEmail;
  final String? contactPhone;

  OwnerBusiness({
    required this.id,
    required this.name,
    this.legalName,
    this.businessType,
    this.contactEmail,
    this.contactPhone,
  });

  factory OwnerBusiness.fromJson(Map<String, dynamic> json) {
    return OwnerBusiness(
      id: json['id'] as String,
      name: json['businessName'] as String,
      legalName: json['legalName'] as String?,
      businessType: json['businessType'] as String?,
      contactEmail: json['contactEmail'] as String?,
      contactPhone: json['contactPhone'] as String?,
    );
  }
}

class OwnerStore {
  final String id;
  final String businessId;
  final String name;
  final String status;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? phone;
  final String? email;
  final String? address;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? openingHours;

  OwnerStore({
    required this.id,
    required this.businessId,
    required this.name,
    required this.status,
    this.description,
    this.logo,
    this.coverImage,
    this.phone,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
  });

  factory OwnerStore.fromJson(Map<String, dynamic> json) {
    return OwnerStore(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      coverImage: json['coverImage'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      openingHours: json['openingHours'] as Map<String, dynamic>?,
    );
  }
}

class DashboardMetrics {
  final int activeOffers;
  final int pendingReservations;
  final int todayPickups;

  DashboardMetrics({
    required this.activeOffers,
    required this.pendingReservations,
    required this.todayPickups,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      activeOffers: json['activeOffers'] ?? 0,
      pendingReservations: json['pendingReservations'] ?? 0,
      todayPickups: json['todayPickups'] ?? 0,
    );
  }
}

class CreateBusinessRequest {
  final String businessName;
  final String? legalName;
  final String? businessType;
  final String? contactEmail;
  final String? contactPhone;

  CreateBusinessRequest({
    required this.businessName,
    this.legalName,
    this.businessType,
    this.contactEmail,
    this.contactPhone,
  });

  Map<String, dynamic> toJson() => {
    'businessName': businessName,
    if (legalName != null) 'legalName': legalName,
    if (businessType != null) 'businessType': businessType,
    if (contactEmail != null) 'contactEmail': contactEmail,
    if (contactPhone != null) 'contactPhone': contactPhone,
  };
}

class CreateStoreRequest {
  final String name;
  final String? description;
  final String? phone;
  final String? email;
  final String? address;
  final double? latitude;
  final double? longitude;

  CreateStoreRequest({
    required this.name,
    this.description,
    this.phone,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    if (description != null) 'description': description,
    if (phone != null) 'phone': phone,
    if (email != null) 'email': email,
    if (address != null) 'address': address,
    if (latitude != null) 'latitude': latitude,
    if (longitude != null) 'longitude': longitude,
  };
}

class UpdateBusinessRequest {
  final String? businessName;
  final String? legalName;
  final String? businessType;
  final String? contactEmail;
  final String? contactPhone;

  UpdateBusinessRequest({
    this.businessName,
    this.legalName,
    this.businessType,
    this.contactEmail,
    this.contactPhone,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (businessName != null) map['businessName'] = businessName;
    if (legalName != null) map['legalName'] = legalName;
    if (businessType != null) map['businessType'] = businessType;
    if (contactEmail != null) map['contactEmail'] = contactEmail;
    if (contactPhone != null) map['contactPhone'] = contactPhone;
    return map;
  }
}

class UpdateStoreRequest {
  final String? name;
  final String? description;
  final String? logo;
  final String? coverImage;
  final String? phone;
  final String? email;
  final String? address;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? openingHours;

  UpdateStoreRequest({
    this.name,
    this.description,
    this.logo,
    this.coverImage,
    this.phone,
    this.email,
    this.address,
    this.latitude,
    this.longitude,
    this.openingHours,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name;
    if (description != null) map['description'] = description;
    if (logo != null) map['logo'] = logo;
    if (coverImage != null) map['coverImage'] = coverImage;
    if (phone != null) map['phone'] = phone;
    if (email != null) map['email'] = email;
    if (address != null) map['address'] = address;
    if (latitude != null) map['latitude'] = latitude;
    if (longitude != null) map['longitude'] = longitude;
    if (openingHours != null) map['openingHours'] = openingHours;
    return map;
  }
}
