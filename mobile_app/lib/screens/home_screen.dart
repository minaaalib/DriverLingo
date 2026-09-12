import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/api_client.dart';
import '../core/app_strings.dart';
import '../core/constants.dart';
import '../models/exam_stats.dart';
import '../services/auth_service.dart';
import '../services/exam_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'exam_screen.dart';

/// The mock-exam setup screen: pick a category, how many questions, and
/// (optionally) a timer, then start the exam. The reviewer language was
/// already chosen once on the welcome screen (see [LanguagePreference]).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = ExamCategory.nonProfessional;
  late int _numQuestions;
  bool _useCustomCount = false;
  bool _isStarting = false;

  final _examService = ExamService();
  late Future<ExamStats> _statsFuture;

  static const _categoryIcons = {
    ExamCategory.nonProfessional: SolarIconsOutline.wheel,
    ExamCategory.professional: SolarIconsOutline.bus,
  };

  @override
  void initState() {
    super.initState();
    _numQuestions = ExamCategory.standardCounts[_category]!;
    _statsFuture = _loadStats();
  }

  Future<ExamStats> _loadStats() async {
    try {
      final history = await _examService.getHistory();
      return ExamStats.compute(history);
    } catch (_) {
      return const ExamStats(bestPercentage: null, streakDays: 0, readiness: 0, hasHistory: false);
    }
  }

  void _onCategoryChanged(String value) {
    setState(() {
      _category = value;
      if (!_useCustomCount) {
        _numQuestions = ExamCategory.standardCounts[value]!;
      }
    });
  }

  Future<void> _startExam() async {
    setState(() => _isStarting = true);
    try {
      final language = context.read<LanguagePreference>().language;
      final session = await _examService.startExam(
        category: _category,
        language: language,
        numQuestions: _numQuestions,
        timeLimitMinutes: ExamCategory.standardTimerMinutes,
      );
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ExamScreen(session: session)),
      );
      if (mounted) setState(() => _statsFuture = _loadStats());
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isStarting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final p = AppPalette.of(context);
    final firstName = (auth.currentUser?.name ?? '').split(' ').first;

    final languagePref = context.watch<LanguagePreference>();

    return GlowBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          child: PageEntrance(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    AvatarBadge(initials: initialsOf(auth.currentUser?.name ?? '?')),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kumusta, ${firstName.isEmpty ? tr(context, 'home_default_name') : firstName}!',
                            style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w800, color: p.textPrimary),
                          ),
                          Text(tr(context, 'home_ready_to_practice'), style: TextStyle(color: p.textSecondary)),
                        ],
                      ),
                    ),
                    _LanguageIconButton(
                      value: languagePref.language,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        context.read<LanguagePreference>().setLanguage(value);
                      },
                    ),
                    const SizedBox(width: 10),
                    const _ThemeToggleButton(),
                  ],
                ),
                const SizedBox(height: 20),
                FutureBuilder<ExamStats>(
                  future: _statsFuture,
                  builder: (context, snapshot) {
                    final stats = snapshot.data;
                    return _ReadinessCard(stats: stats);
                  },
                ),
                const SizedBox(height: 28),

                SectionLabel(tr(context, 'home_exam_category')),
                ...ExamCategory.labels.entries.toList().asMap().entries.map(
                      (indexed) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: StaggeredListItem(
                          index: indexed.key,
                          child: SelectableCard(
                            icon: _categoryIcons[indexed.value.key] ?? SolarIconsOutline.suitcase,
                            title: ExamCategory.labelFor(indexed.value.key, languagePref.language),
                            subtitle: '${ExamCategory.standardCounts[indexed.value.key]} ${tr(context, 'home_items_standard')}',
                            selected: _category == indexed.value.key,
                            onTap: () => _onCategoryChanged(indexed.value.key),
                          ),
                        ),
                      ),
                    ),

                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _StatBox(
                        label: tr(context, 'home_questions_label'),
                        value: '$_numQuestions',
                        onTap: () => _showQuestionCountSheet(context),
                        trailing: Icon(SolarIconsOutline.tuning, size: 18, color: p.textTertiary),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatBox(
                        label: tr(context, 'home_timer_label'),
                        value: '${ExamCategory.standardTimerMinutes} min',
                        accent: true,
                        trailing: Icon(SolarIconsOutline.clockCircle, size: 18, color: p.success),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),
                GradientButton(
                  label: _isStarting ? tr(context, 'home_starting') : tr(context, 'home_start_exam'),
                  icon: _isStarting ? null : SolarIconsBold.arrowRight,
                  isLoading: _isStarting,
                  onPressed: _isStarting ? null : _startExam,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showQuestionCountSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            final p = AppPalette.of(sheetContext);
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              decoration: BoxDecoration(
                color: p.surfaceElevated,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr(sheetContext, 'home_sheet_title'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: p.textPrimary)),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(tr(sheetContext, 'home_custom_switch'), style: TextStyle(color: p.textPrimary)),
                    subtitle: Text(
                      '${_useCustomCount ? tr(sheetContext, 'home_custom_value') : tr(sheetContext, 'home_standard_value')}: $_numQuestions',
                      style: TextStyle(color: p.textTertiary),
                    ),
                    value: _useCustomCount,
                    onChanged: (value) => setSheetState(() {
                      setState(() {
                        _useCustomCount = value;
                        if (!value) _numQuestions = ExamCategory.standardCounts[_category]!;
                      });
                    }),
                  ),
                  if (_useCustomCount)
                    Slider(
                      value: _numQuestions.toDouble(),
                      min: 5,
                      max: 100,
                      divisions: 19,
                      label: '$_numQuestions',
                      onChanged: (value) => setSheetState(() => setState(() => _numQuestions = value.round())),
                    ),
                  const SizedBox(height: 8),
                  GradientButton(label: tr(sheetContext, 'home_done'), onPressed: () => Navigator.pop(sheetContext)),
                ],
              ),
            );
          },
        );
      },
    );
  }

}

/// Quick light/dark switch, matching the language button's footprint.
class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<ThemePreference>().toggle(context);
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: p.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.border),
        ),
        child: Icon(
          isDark ? SolarIconsOutline.sun : SolarIconsOutline.moon,
          color: p.textSecondary,
          size: 20,
        ),
      ),
    );
  }
}

/// Matches [_ThemeToggleButton]'s footprint but opens a language picker menu
/// instead of firing a single action.
class _LanguageIconButton extends StatelessWidget {
  const _LanguageIconButton({required this.value, required this.onChanged});
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return PopupMenuButton<String>(
      initialValue: value,
      onSelected: onChanged,
      color: p.surfaceElevated,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      itemBuilder: (context) => AppLanguage.labels.entries
          .map(
            (entry) => PopupMenuItem<String>(
              value: entry.key,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    entry.key == value ? SolarIconsBold.checkCircle : SolarIconsOutline.globus,
                    size: 16,
                    color: entry.key == value ? p.primary : p.textSecondary,
                  ),
                  const SizedBox(width: 10),
                  Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: p.surfaceElevated,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: p.border),
        ),
        alignment: Alignment.center,
        child: Icon(SolarIconsOutline.globus, color: p.textSecondary, size: 20),
      ),
    );
  }
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.stats});
  final ExamStats? stats;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final hasHistory = stats?.hasHistory ?? false;
    final readiness = (stats?.readiness ?? 0).clamp(0, 100).toDouble();
    final best = stats?.bestPercentage;
    final streak = stats?.streakDays ?? 0;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  tr(context, hasHistory ? 'home_momentum_title' : 'home_first_exam_title'),
                  style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, height: 1.15, color: p.textPrimary),
                ),
              ),
              const ReadinessBadge(),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StatPill(
                icon: SolarIconsOutline.chart_2,
                label: best != null ? '${tr(context, 'home_best')} ${best.round()}%' : tr(context, 'home_no_attempts'),
                color: p.success,
              ),
              if (streak > 0) StatPill(icon: SolarIconsBold.fire, label: trf(context, 'home_day_streak', {'n': '$streak'}), color: p.textPrimary),
            ],
          ),
          const SizedBox(height: 16),
          Text(tr(context, 'home_overall_readiness'), style: TextStyle(color: p.textTertiary, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.6)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: hasHistory ? readiness / 100 : 0),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOutCubic,
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 8,
                backgroundColor: p.chipBg,
                valueColor: AlwaysStoppedAnimation(p.success),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value, this.trailing, this.onTap, this.accent = false});
  final String label;
  final String value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: accent ? p.success.withValues(alpha: 0.12) : p.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: accent ? p.success.withValues(alpha: 0.4) : p.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(label, style: TextStyle(color: accent ? p.success : p.textTertiary, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5)),
                ),
                if (trailing != null) trailing!,
              ],
            ),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w800, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
