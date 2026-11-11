import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                                  fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            if (_errorMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: Clay.box(
                                  p,
                                  color: p.danger.withValues(alpha: 0.12),
                                  radius: 18,
                                  depth: 0.5,
                                  borderColor: p.danger.withValues(alpha: 0.35),
                                ),
                                child: Text(_errorMessage!, style: TextStyle(color: p.danger)),
                              ),
                              const SizedBox(height: 16),
                            ],
                            _GoogleClayButton(
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

/// White clay "Continue with Google" button. It stays white in both
/// themes so it stands out on the dark hero photo, uses a dark drop shadow
/// (the pastel clay shadow would vanish on the photo), and squishes down
/// slightly while pressed.
class _GoogleClayButton extends StatefulWidget {
  const _GoogleClayButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback? onPressed;

  @override
  State<_GoogleClayButton> createState() => _GoogleClayButtonState();
}

class _GoogleClayButtonState extends State<_GoogleClayButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onPressed != null && _pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    return Opacity(
      opacity: enabled ? 1 : 0.7,
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Container(
            height: 58,
            decoration: Clay.white(depth: _pressed ? 0.45 : 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/google_logo.svg', width: 22, height: 22),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    widget.label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF1A2138), fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
