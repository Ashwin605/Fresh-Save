class TeamMemberUser {
  final String id;
  final String name;
  final String email;
  final String? phone;

  TeamMemberUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
  });

  factory TeamMemberUser.fromJson(Map<String, dynamic> json) {
    return TeamMemberUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
    );
  }
}

class StoreStaff {
  final String id;
  final String storeId;
  final String userId;
  final String role;
  final String status;
  final TeamMemberUser user;

  StoreStaff({
    required this.id,
    required this.storeId,
    required this.userId,
    required this.role,
    required this.status,
    required this.user,
  });

  factory StoreStaff.fromJson(Map<String, dynamic> json) {
    return StoreStaff(
      id: json['id'] as String,
      storeId: json['storeId'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      status: json['status'] as String,
      user: TeamMemberUser.fromJson(json['user']),
    );
  }
}
