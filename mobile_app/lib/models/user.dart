class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String? emailVerifiedAt;

  bool get isAdmin => role == 'admin';
  bool get isEmailVerified => emailVerifiedAt != null;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      emailVerifiedAt: json['email_verified_at'] as String?,
    );
  }
}
