class UserModel {
  final String email;
  final String role;

  UserModel({required this.email, required this.role});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(email: map['email'] ?? '', role: map['role'] ?? 'Unknown');
  }

  bool get isDriver {
    final normalizedRole = role.trim().toLowerCase();
    return normalizedRole == 'driver' || normalizedRole == 'rider';
  }

  bool get isPassenger => role.toLowerCase() == 'passenger';
}
