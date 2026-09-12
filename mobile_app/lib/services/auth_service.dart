import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/api_client.dart';
import '../core/constants.dart';
import '../core/token_storage.dart';
import '../models/user.dart';

/// Holds the current auth session and exposes Google sign-in/logout.
/// Registered as a [ChangeNotifier] with `provider` in main.dart so the
/// whole widget tree can react to sign-in/sign-out.
///
/// Sign-in flow: Google Sign-In produces an ID token -> that token
/// establishes a Supabase session (identity backend) -> the same token is
/// exchanged with the Django backend's `/auth/google` endpoint, which
/// verifies it and returns the app's normal JWT access/refresh pair used by
/// every other API call.
class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = true;

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  final Dio _dio = ApiClient.instance.dio;
  final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: SupabaseConfig.googleWebClientId);

  /// Called once at app startup: if a token is already stored, fetch the
  /// profile it belongs to so the user doesn't have to log in again.
  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();
    if (await TokenStorage.instance.hasSession) {
      try {
        final response = await _dio.get('/auth/me');
        _currentUser = AppUser.fromJson(response.data as Map<String, dynamic>);
      } catch (_) {
        await TokenStorage.instance.clear();
        _currentUser = null;
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // User cancelled the picker.

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw ApiException('Could not sign in with Google. Please try again.');
    }

    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );

    try {
      final response = await _dio.post('/auth/google', data: {'id_token': idToken});
      final data = response.data as Map<String, dynamic>;
      await TokenStorage.instance.saveTokens(access: data['access'] as String, refresh: data['refresh'] as String);
      _currentUser = AppUser.fromJson(data['user'] as Map<String, dynamic>);
      notifyListeners();
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  Future<void> logout() async {
    final refresh = await TokenStorage.instance.refreshToken;
    try {
      if (refresh != null) {
        await _dio.post('/auth/logout', data: {'refresh': refresh});
      }
    } catch (_) {
      // Even if the server call fails (e.g. offline), clear local state.
    }
    await TokenStorage.instance.clear();
    await Supabase.instance.client.auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
