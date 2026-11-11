import 'package:supabase_flutter/supabase_flutter.dart';

/// Raised by the service layer with a message ready to show to the user.
///
/// Kept at this path (rather than renamed) so the six screens that already
/// `import '../core/api_client.dart'` for this type didn't need touching
/// when the backend moved from Django/Dio to Supabase - there's no more
/// "client" here now that `supabase_flutter`'s own client (initialized in
/// main.dart) handles auth/requests directly.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final String? statusCode;

  /// Builds a user-facing message from whatever Supabase threw -
  /// [PostgrestException] (table/RPC calls), [AuthException] (sign-in), or
  /// a generic network failure.
  factory ApiException.from(Object error) {
    if (error is PostgrestException) {
      return ApiException(error.message, statusCode: error.code);
    }
    if (error is AuthException) {
      return ApiException(error.message, statusCode: error.statusCode);
    }
    return ApiException('Could not reach the server. Check your internet connection.');
  }

  @override
  String toString() => message;
}
