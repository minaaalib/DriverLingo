import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'root_shell.dart';
import 'welcome_screen.dart';

/// The app's first route. A driver who is already signed in (session
/// restored by Supabase) goes straight to the home screen; they already
/// went through the welcome screen and agreed to the Terms & Conditions
/// when they first logged in. Everyone else starts at the welcome screen.
class StartupGate extends StatelessWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isAuthenticated ? const RootShell() : const WelcomeScreen();
  }
}

/// Routes to the home screen if a session is already restored, otherwise
/// to the login screen. Reached after the welcome screen's language pick.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return auth.isAuthenticated ? const RootShell() : const LoginScreen();
  }
}
