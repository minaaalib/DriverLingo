import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/user.dart';

/// Holds the current auth session and exposes Google sign-in/logout.
/// Registered as a [ChangeNotifier] with `provider` in main.dart so the
/// whole widget tree can react to sign-in/sign-out.
///
/// Sign-in flow: Google Sign-In produces an ID token -> that token
/// establishes a Supabase Auth session directly (Supabase verifies it with
/// Google itself). There's no separate backend exchange anymore - Supabase
/// *is* the backend for auth, and `supabase_flutter` persists/refreshes the
/// session on its own.
class AuthService extends ChangeNotifier {
  AppUser? _currentUser;
  bool _isLoading = true;

  AppUser? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  SupabaseClient get _client => Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(serverClientId: SupabaseConfig.googleWebClientId);

  /// Called once at app startup: `Supabase.initialize()` in main.dart has
  /// already restored any persisted session, so this just loads the
  /// matching profile row if one is present.
  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();
    await _loadCurrentUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) {
      _currentUser = null;
      return;
    }
    try {
      final profile = await _client.from('profiles').select().eq('id', authUser.id).maybeSingle();
      _currentUser = AppUser.fromSupabase(authUser, profile);
    } catch (_) {
      _currentUser = AppUser.fromSupabase(authUser, null);
    }
  }

  Future<void> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return; // User cancelled the picker.

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw ApiException('Could not sign in with Google. Please try again.');
    }

    try {
      await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: googleAuth.accessToken,
      );
      await _loadCurrentUser();
      notifyListeners();
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
