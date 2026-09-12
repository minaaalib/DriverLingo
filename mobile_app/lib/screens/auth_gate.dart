import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';
import 'root_shell.dart';

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
