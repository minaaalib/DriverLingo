import 'package:supabase_flutter/supabase_flutter.dart';

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.emailVerifiedAt,
    this.givenName,
  });

  /// The Supabase auth user's id (a UUID, not the old Django integer id).
  final String id;
  final String name;
  final String email;
  final String role;
  final String? emailVerifiedAt;

  /// Google "given name" when available (e.g. "Juan" for "Juan Dela Cruz").
  final String? givenName;

  /// The driver's first name, for greetings. Empty if no name is known.
  String get firstName {
    final given = givenName?.trim() ?? '';
    if (given.isNotEmpty) return given;
    final trimmed = name.trim();
    return trimmed.isEmpty ? '' : trimmed.split(RegExp(r'\s+')).first;
  }

  bool get isAdmin => role == 'admin';
  bool get isEmailVerified => emailVerifiedAt != null;

  /// Combines the Supabase auth user (email, verification status - set
  /// automatically for Google sign-in) with its `profiles` row
  /// (name, role) to build the same shape the rest of the app expects.
  ///
  /// The name falls back to the Google account name stored in the auth
  /// user's metadata when the profile row has none.
  factory AppUser.fromSupabase(User authUser, Map<String, dynamic>? profile) {
    final meta = authUser.userMetadata ?? const <String, dynamic>{};
    String? metaString(String key) {
      final value = meta[key];
      return value is String && value.trim().isNotEmpty ? value.trim() : null;
    }

    final profileName = (profile?['name'] as String?)?.trim();
    final name = (profileName != null && profileName.isNotEmpty)
        ? profileName
        : metaString('full_name') ?? metaString('name') ?? '';

    return AppUser(
      id: authUser.id,
      name: name,
      email: authUser.email ?? '',
      role: (profile?['role'] as String?) ?? 'user',
      emailVerifiedAt: authUser.emailConfirmedAt,
      givenName: metaString('given_name'),
    );
  }
}
