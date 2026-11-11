import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import '../core/constants.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'contact_screen.dart';
import 'faq_screen.dart';
import 'info_screen.dart';

/// App-wide preferences: appearance (theme) and reviewer language.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final themePref = context.watch<ThemePreference>();
    final languagePref = context.watch<LanguagePreference>();

    return GlowBackground(
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 32 + MediaQuery.paddingOf(context).bottom),
          child: PageEntrance(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tr(context, 'settings_title'), style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: p.textPrimary)),
                const SizedBox(height: 20),
                SectionLabel(tr(context, 'settings_appearance')),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: ThemeMode.values.map((mode) {
                      final isLast = mode == ThemeMode.values.last;
                      return Column(
                        children: [
                          _ThemeModeRow(
                            mode: mode,
                            selected: themePref.mode == mode,
                            onTap: () => themePref.setMode(mode),
                          ),
                          if (!isLast) const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                SectionLabel(tr(context, 'settings_reviewer_language')),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: AppLanguage.labels.entries.toList().asMap().entries.map((indexed) {
                      final entry = indexed.value;
                      final isLast = indexed.key == AppLanguage.labels.length - 1;
                      return Column(
                        children: [
                          _LanguageRow(
                            label: entry.value,
                            selected: languagePref.language == entry.key,
                            onTap: () => languagePref.setLanguage(entry.key),
                          ),
                          if (!isLast) const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                SectionLabel(tr(context, 'settings_support_legal')),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      _NavRow(
                        icon: SolarIconsOutline.checklist,
                        label: tr(context, 'settings_how_it_works'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _HowItWorksScreen())),
                      ),
                      const _NavDivider(),
                      _NavRow(
                        icon: SolarIconsOutline.questionCircle,
                        label: tr(context, 'settings_faqs'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const FaqScreen())),
                      ),
                      const _NavDivider(),
                      _NavRow(
                        icon: SolarIconsOutline.shieldCheck,
                        label: tr(context, 'settings_privacy'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
                      ),
                      const _NavDivider(),
                      _NavRow(
                        icon: SolarIconsOutline.documentText,
                        label: tr(context, 'settings_terms'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TermsScreen())),
                      ),
                      const _NavDivider(),
                      _NavRow(
                        icon: SolarIconsOutline.letter,
                        label: tr(context, 'settings_contact'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ContactScreen())),
                      ),
                    ],
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

class _NavRow extends StatelessWidget {
  const _NavRow({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ClayTile(
      onTap: onTap,
      child: Row(
        children: [
          ClayIconBadge(icon: icon, color: p.primary),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600))),
          Icon(SolarIconsOutline.altArrowRight, size: 16, color: p.textTertiary),
        ],
      ),
    );
  }
}

class _NavDivider extends StatelessWidget {
  const _NavDivider();

  @override
  Widget build(BuildContext context) => const SizedBox(height: 10);
}

class _HowItWorksScreen extends StatelessWidget {
  const _HowItWorksScreen();

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: 'How the system works',
      intro: howItWorksIntro(context),
      sections: howItWorksSections(context),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: tr(context, 'settings_privacy'),
      intro: tr(context, 'privacy_intro'),
      sections: privacyPolicySections(context),
    );
  }
}

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoScreen(
      title: tr(context, 'settings_terms'),
      intro: tr(context, 'terms_intro'),
      sections: termsSections(context),
    );
  }
}

class _ThemeModeRow extends StatelessWidget {
  const _ThemeModeRow({required this.mode, required this.selected, required this.onTap});
  final ThemeMode mode;
  final bool selected;
  final VoidCallback onTap;

  static const _icons = {
    ThemeMode.system: SolarIconsOutline.settings,
    ThemeMode.light: SolarIconsOutline.sun,
    ThemeMode.dark: SolarIconsOutline.moon,
  };

  static const _labelKeys = {
    ThemeMode.system: 'settings_system_default',
    ThemeMode.light: 'settings_light',
    ThemeMode.dark: 'settings_dark',
  };

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ClayTile(
      onTap: onTap,
      selected: selected,
      child: Row(
        children: [
          ClayIconBadge(icon: _icons[mode]!, color: selected ? p.primary : null, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              tr(context, _labelKeys[mode]!),
              style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: selected
                ? Clay.accent(p.primary, shape: BoxShape.circle, depth: 0.35)
                : Clay.inset(p, radius: 11),
            child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return ClayTile(
      onTap: onTap,
      selected: selected,
      child: Row(
        children: [
          ClayIconBadge(icon: SolarIconsOutline.globus, color: selected ? p.primary : null, size: 34),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600)),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: selected
                ? Clay.accent(p.primary, shape: BoxShape.circle, depth: 0.35)
                : Clay.inset(p, radius: 11),
            child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ],
      ),
    );
  }
}
