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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: PageEntrance(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tr(context, 'settings_title'), style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: p.textPrimary)),
                const SizedBox(height: 20),
                SectionLabel(tr(context, 'settings_appearance')),
                AppCard(
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
                          if (!isLast) Divider(height: 24, color: p.border),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                SectionLabel(tr(context, 'settings_reviewer_language')),
                AppCard(
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
                          if (!isLast) Divider(height: 24, color: p.border),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),
                SectionLabel(tr(context, 'settings_support_legal')),
                AppCard(
                  padding: EdgeInsets.zero,
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
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _PrivacyPolicyScreen())),
                      ),
                      const _NavDivider(),
                      _NavRow(
                        icon: SolarIconsOutline.documentText,
                        label: tr(context, 'settings_terms'),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const _TermsScreen())),
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 18, color: p.textTertiary),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600))),
            Icon(SolarIconsOutline.altArrowRight, size: 16, color: p.textTertiary),
          ],
        ),
      ),
    );
  }
}

class _NavDivider extends StatelessWidget {
  const _NavDivider();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Divider(height: 1, color: p.border, indent: 16, endIndent: 16);
  }
}

class _HowItWorksScreen extends StatelessWidget {
  const _HowItWorksScreen();

  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'How the system works',
      intro: 'DriverLingo helps aspiring '
          'drivers prepare for the LTO non-professional and professional driverâ€™s license exams '
          'in English, Filipino, or Hiligaynon.',
      sections: [
        InfoSection(
          '1. Create an account',
          'Sign up with your name, email, and a password, or log in to an existing account. '
              'Your account keeps your exam history and progress saved across sessions.',
        ),
        InfoSection(
          '2. Choose your language',
          'Pick English, Filipino, or Hiligaynon at any time. Every question, answer choice, and '
              'explanation is available in all three languages so you can review in whichever one '
              'you understand best.',
        ),
        InfoSection(
          '3. Take a mock exam',
          'Answer timed practice questions drawn from the LTO reviewer question bank, covering road '
              'signs, traffic laws and regulations, and safe driving practices for non-professional '
              'and professional license categories.',
        ),
        InfoSection(
          '4. Review your results',
          'After submitting, see your score, your pass/fail status, and a full breakdown of every '
              'question with the correct answer and an explanation - so mistakes turn into something '
              'learned.',
        ),
        InfoSection(
          '5. Track your progress',
          'Every attempt is saved to your Exam History, so you can look back at previous scores and '
              'see how youâ€™re improving over time.',
        ),
        InfoSection(
          '6. Study offline',
          'Once youâ€™ve opened the reviewer questions while online, theyâ€™re cached on your '
              'device so you can keep practicing even without an internet connection.',
        ),
        InfoSection(
          'Behind the scenes',
          'Administrators maintain and update the question bank and manage user accounts to keep the '
              'reviewer accurate and up to date.',
        ),
      ],
    );
  }
}

class _PrivacyPolicyScreen extends StatelessWidget {
  const _PrivacyPolicyScreen();

  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'Privacy policy',
      intro: 'We know studying for your license already means sharing enough paperwork with the '
          'government. Hereâ€™s exactly what DriverLingo collects and why.',
      sections: [
        InfoSection(
          'Information we collect',
          'When you register, we collect your name, email address, and a securely hashed password. '
              'As you use the app, we also store your chosen reviewer language and your mock exam '
              'attempts (answers, scores, and timestamps).',
        ),
        InfoSection(
          'How we use it',
          'Your account details let you log in and keep your progress across devices. Your exam '
              'history lets you review past attempts and track improvement. We do not use your data '
              'for advertising, and we do not sell or share it with third parties.',
        ),
        InfoSection(
          'Offline data',
          'Reviewer questions downloaded for offline use are cached locally on your device only, and '
              'are not shared with anyone else.',
        ),
        InfoSection(
          'Data storage & security',
          'Your information is stored on our servers with hashed passwords and access limited to the '
              'development team maintaining the app. This app was built as an academic capstone '
              'project, so please avoid submitting sensitive personal information beyond what '
              'registration requires.',
        ),
        InfoSection(
          'Your rights',
          'In line with the Philippine Data Privacy Act of 2012 (RA 10173), you may request access '
              'to, correction of, or deletion of your personal data at any time by reaching out '
              'through Contact Us.',
        ),
        InfoSection(
          'Changes to this policy',
          'This policy may be updated as the app evolves. Continued use of DriverLingo after changes '
              'are posted means you accept the updated policy.',
        ),
      ],
    );
  }
}

class _TermsScreen extends StatelessWidget {
  const _TermsScreen();

  @override
  Widget build(BuildContext context) {
    return const InfoScreen(
      title: 'Terms & conditions',
      intro: 'By using DriverLingo, you agree to the following terms.',
      sections: [
        InfoSection(
          'About this app',
          'DriverLingo is an independent '
              'study aid developed as a BSIT capstone project by students of West Visayas State '
              'University - Pototan Campus. It is not affiliated with, endorsed by, or connected to '
              'the Land Transportation Office (LTO).',
        ),
        InfoSection(
          'Content accuracy',
          'We strive to keep questions, answers, and explanations accurate, but some entries are '
              'still undergoing verification against official LTO references. DriverLingo is meant to '
              'complement, not replace, official LTO reviewer materials - always confirm critical '
              'information with an authoritative source before your actual exam.',
        ),
        InfoSection(
          'Your account',
          'You are responsible for the accuracy of the information you provide and for keeping your '
              'login credentials secure. Do not share your account with others.',
        ),
        InfoSection(
          'Acceptable use',
          'Use DriverLingo only for personal exam preparation. Do not attempt to copy, resell, or '
              'redistribute the reviewer content, and do not misuse the app in a way that disrupts '
              'the service for other users.',
        ),
        InfoSection(
          'Limitation of liability',
          'DriverLingo is provided as a study tool, "as is," with no guarantee of exam results. The '
              'development team is not liable for outcomes of your actual LTO exam or for decisions '
              'made based solely on this appâ€™s content.',
        ),
        InfoSection(
          'Changes to these terms',
          'These terms may be updated as the app is improved. Continued use of the app after changes '
              'are posted means you accept the updated terms.',
        ),
      ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(_icons[mode], size: 18, color: selected ? p.primary : p.textTertiary),
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
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? p.primary : Colors.transparent,
              border: Border.all(color: selected ? p.primary : p.borderStrong, width: 1.6),
            ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(SolarIconsOutline.globus, size: 18, color: selected ? p.primary : p.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600)),
          ),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? p.primary : Colors.transparent,
              border: Border.all(color: selected ? p.primary : p.borderStrong, width: 1.6),
            ),
            child: selected ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
        ],
      ),
    );
  }
}
