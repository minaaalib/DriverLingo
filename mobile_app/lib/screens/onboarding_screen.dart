import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/api_client.dart';
import '../core/app_strings.dart';
import '../core/constants.dart';
import '../services/exam_service.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'exam_screen.dart';
import 'info_screen.dart';

/// Shown once, pushed on top of [RootShell] right after a new user's first
/// login (i.e. when their exam history is still empty - see RootShell).
/// Walks them through how the app works, then asks (via [_onContinuePressed])
/// whether they want to start the practice exam now or skip it. Starting
/// pushes the exam, which is still the only way to clear this screen for
/// good (see RootShell._maybeShowOnboarding - it keeps re-showing until
/// there's at least one exam attempt); skipping just pops back to RootShell
/// and leaves that still-empty, so it resurfaces on the next login.
/// [canPop] is false so the system back button can't dismiss this silently
/// without going through that same skip confirmation. Deliberately pushed
/// as a normal route (not used in place of RootShell) so that ResultsScreen's
/// "back to home" - which pops to the first route in the stack - still lands
/// on RootShell.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _examService = ExamService();
  bool _isStarting = false;

  Future<void> _onContinuePressed() async {
    final start = await showAppConfirmDialog(
      context,
      icon: SolarIconsBold.arrowRight,
      title: trRead(context, 'onboarding_confirm_title'),
      message: trRead(context, 'onboarding_confirm_message'),
      confirmLabel: trRead(context, 'onboarding_confirm_start'),
      cancelLabel: trRead(context, 'onboarding_confirm_skip'),
    );
    if (!mounted) return;
    if (start == true) {
      await _startPracticeExam();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _startPracticeExam() async {
    setState(() => _isStarting = true);
    try {
      final language = context.read<LanguagePreference>().language;
      final session = await _examService.startExam(
        category: ExamCategory.nonProfessional,
        language: language,
        numQuestions: ExamCategory.onboardingPracticeCount,
        timeLimitMinutes: ExamCategory.onboardingPracticeTimerMinutes,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ExamScreen(session: session, isPractice: true)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return PopScope(
      canPop: false,
      child: GlowBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              children: [
                Text(
                  tr(context, 'onboarding_title'),
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, color: p.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  tr(context, 'onboarding_subtitle'),
                  style: TextStyle(color: p.textSecondary, fontSize: 14.5, height: 1.45),
                ),
                const SizedBox(height: 20),
                for (final section in howItWorksSections(context)) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.heading,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: p.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(section.body, style: TextStyle(color: p.textSecondary, fontSize: 14, height: 1.5)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 8),
                GradientButton(
                  label: _isStarting ? tr(context, 'home_starting') : tr(context, 'onboarding_cta'),
                  icon: _isStarting ? null : SolarIconsBold.arrowRight,
                  isLoading: _isStarting,
                  onPressed: _isStarting ? null : _onContinuePressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
