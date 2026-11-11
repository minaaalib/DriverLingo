import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'auth_gate.dart';
import 'info_screen.dart';

const _kQuoteKeys = ['welcome_quote_1', 'welcome_quote_2', 'welcome_quote_3', 'welcome_quote_4'];

/// The very first screen: a full-bleed hero photo behind a glassmorphic
/// panel holding the brand and a language pick (English / Filipino /
/// Hiligaynon) that's reused for the rest of the app (exam setup, exam
/// questions, results) so the user is never asked twice.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..forward();
  late final Animation<double> _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  late final Animation<Offset> _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  late final Timer _quoteTimer = Timer.periodic(
    const Duration(seconds: 4),
    (_) => setState(() => _quoteIndex = (_quoteIndex + 1) % _kQuoteKeys.length),
  );
  int _quoteIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    _quoteTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final languagePref = context.watch<LanguagePreference>();

    return Scaffold(
      backgroundColor: p.bg,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/landing/splash.jpg', fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.32),
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.55),
                ],
                stops: const [0, 0.32, 0.55, 1],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: FadeTransition(
                    opacity: _fade,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: Clay.white(radius: 17, depth: 0.55),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              'assets/logo.png',
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'DriverLingo',
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 21,
                            shadows: [
                              Shadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 10, offset: const Offset(0, 2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: _fade,
                  child: SlideTransition(
                    position: _slide,
                    child: _GlassPanel(
                      topContent: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _GlassBadge(),
                          const SizedBox(height: 14),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) => FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(animation),
                                child: child,
                              ),
                            ),
                            child: Text(
                              tr(context, _kQuoteKeys[_quoteIndex]),
                              key: ValueKey(_quoteIndex),
                              style: GoogleFonts.playfairDisplay(
                                color: Colors.white,
                                fontSize: 32,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(color: Colors.black.withValues(alpha: 0.45), blurRadius: 18, offset: const Offset(0, 4)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              tr(context, 'welcome_choose_language'),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                          LanguageDropdown(
                            value: languagePref.language,
                            onChanged: (value) {
                              HapticFeedback.selectionClick();
                              context.read<LanguagePreference>().setLanguage(value);
                            },
                          ),
                          const SizedBox(height: 20),
                          GradientButton(
                            label: tr(context, 'welcome_continue'),
                            onPressed: () async {
                              HapticFeedback.lightImpact();
                              final agreed = await showDialog<bool>(
                                context: context,
                                builder: (_) => const _ConsentDialog(),
                              );
                              if (agreed == true && context.mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const AuthGate()),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Small white clay pill above the headline ("Official LTO Reviewer").
class _GlassBadge extends StatelessWidget {
  const _GlassBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
      decoration: Clay.white(radius: 999, depth: 0.45),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(SolarIconsBold.verifiedCheck, size: 15, color: AppPalette.light.primary),
          const SizedBox(width: 6),
          Text(
            tr(context, 'welcome_badge'),
            style: GoogleFonts.playfairDisplay(color: AppPalette.light.textPrimary, fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// Bottom section of the hero photo: brand mark, language pick, and the
/// entry point into the rest of the app, sitting directly on a dark
/// gradient (no card, no blur) so the photo stays visible behind the text.
class _GlassPanel extends StatelessWidget {
  const _GlassPanel({required this.topContent, required this.child});
  final Widget topContent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0),
            Colors.black.withValues(alpha: 0.60),
            Colors.black.withValues(alpha: 0.90),
          ],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            topContent,
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

/// The "Before you continue" consent step, shown after the language pick
/// and before entering the login flow. A branded alternative to the plain
/// [showAppConfirmDialog] used elsewhere: a gradient icon badge, a serif
/// headline matching the rest of the brand, and two tappable chips that
/// let the user open the full Terms & Conditions or Privacy Policy without
/// losing their place, before deciding whether to agree.
class _ConsentDialog extends StatelessWidget {
  const _ConsentDialog();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Container(
          padding: const EdgeInsets.fromLTRB(26, 32, 26, 22),
          decoration: Clay.box(p, color: p.surfaceElevated, radius: 32, depth: 1.3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: Clay.accent(p.primary, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(SolarIconsBold.verifiedCheck, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 18),
              Text(
                tr(context, 'consent_dialog_title'),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 21, color: p.textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                tr(context, 'consent_dialog_message'),
                textAlign: TextAlign.center,
                style: TextStyle(color: p.textSecondary, fontSize: 14.5, height: 1.5),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _ConsentLinkChip(
                      icon: SolarIconsOutline.shieldCheck,
                      label: tr(context, 'settings_privacy'),
                      onTap: () => showInfoSheet(
                        context,
                        title: trRead(context, 'settings_privacy'),
                        intro: trRead(context, 'privacy_intro'),
                        sections: privacyPolicySections(context, listen: false),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ConsentLinkChip(
                      icon: SolarIconsOutline.documentText,
                      label: tr(context, 'settings_terms'),
                      onTap: () => showInfoSheet(
                        context,
                        title: trRead(context, 'settings_terms'),
                        intro: trRead(context, 'terms_intro'),
                        sections: termsSections(context, listen: false),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: tr(context, 'consent_agree'),
                onPressed: () => Navigator.pop(context, true),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(foregroundColor: p.textSecondary),
                  child: Text(tr(context, 'consent_decline'), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One tappable "Privacy Policy" / "Terms & Conditions" chip within
/// [_ConsentDialog].
class _ConsentLinkChip extends StatelessWidget {
  const _ConsentLinkChip({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: Clay.box(p, color: p.chipBg, radius: 18, depth: 0.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: p.primary),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w700, fontSize: 12, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }
}
