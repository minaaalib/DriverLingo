import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/api_client.dart';
import '../core/app_strings.dart';
import '../services/auth_service.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  bool _isSubmitting = false;
  String? _errorMessage;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _continueWithGoogle() async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      await context.read<AuthService>().signInWithGoogle();
      // Navigation happens automatically via AuthGate once AuthService
      // notifies its listeners.
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final languagePref = context.watch<LanguagePreference>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: HeroPhotoBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: FadeTransition(
                      opacity: _fade,
                      child: SlideTransition(
                        position: _slide,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset('assets/logo.png', height: 120),
                            const SizedBox(height: 16),
                            Text(
                              'DriverLingo',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: p.danger.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: p.danger.withValues(alpha: 0.3)),
                                ),
                                child: Text(_errorMessage!, style: TextStyle(color: p.danger)),
                              ),
                              const SizedBox(height: 16),
                            ],
                            OutlinePillButton(
                              label: _isSubmitting
                                  ? tr(context, 'login_continue_google_loading')
                                  : tr(context, 'login_continue_google'),
                              onPressed: _isSubmitting ? null : _continueWithGoogle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 16,
                child: FadeTransition(
                  opacity: _fade,
                  child: CompactLanguagePicker(
                    value: languagePref.language,
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      context.read<LanguagePreference>().setLanguage(value);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
