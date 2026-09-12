import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/app_strings.dart';
import '../core/constants.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key, required this.result});

  final ExamResult result;

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late String _displayLanguage = widget.result.summary.languageUsed;

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final summary = result.summary;
    final p = AppPalette.of(context);
    final passColor = summary.passed ? p.success : p.danger;

    return GlowBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 150,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: p.textPrimary,
              ),
              icon: Icon(SolarIconsOutline.altArrowLeft, size: 18, color: p.textPrimary),
              label: Text(tr(context, 'results_back_home'), style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w700, fontSize: 13)),
            ),
          ),
          title: null,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: PopupMenuButton<String>(
                tooltip: tr(context, 'results_translate_tooltip'),
                initialValue: _displayLanguage,
                onSelected: (value) => setState(() => _displayLanguage = value),
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
                              entry.key == _displayLanguage ? SolarIconsBold.checkCircle : SolarIconsOutline.globus,
                              size: 16,
                              color: entry.key == _displayLanguage ? p.primary : p.textSecondary,
                            ),
                            const SizedBox(width: 10),
                            Text(entry.value, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: p.surfaceElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: p.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(SolarIconsOutline.globus, size: 16, color: p.textSecondary),
                      const SizedBox(width: 6),
                      Text(
                        AppLanguage.labels[_displayLanguage] ?? _displayLanguage,
                        style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                      const SizedBox(width: 2),
                      Icon(SolarIconsOutline.altArrowDown, size: 16, color: p.textSecondary),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                tr(context, 'results_title'),
                style: GoogleFonts.playfairDisplay(fontSize: 30, fontWeight: FontWeight.w800, color: p.textPrimary),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  children: [
                    ExamResultBadge(passed: summary.passed),
                    Text(
                      '${summary.score} / ${summary.totalQuestions}',
                      style: GoogleFonts.playfairDisplay(fontSize: 40, fontWeight: FontWeight.w800, color: p.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${summary.percentage.toStringAsFixed(1)}%',
                      style: TextStyle(fontSize: 22, color: passColor, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    StatPill(
                      icon: summary.passed ? SolarIconsBold.checkCircle : SolarIconsOutline.dangerCircle,
                      label: tr(context, summary.passed ? 'results_passed' : 'results_needs_review'),
                      color: passColor,
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 8,
                      children: [
                        _MetaChip(
                          icon: SolarIconsOutline.widget,
                          label: ExamCategory.labelFor(summary.category, context.watch<LanguagePreference>().language),
                        ),
                        _MetaChip(icon: SolarIconsOutline.globus, label: AppLanguage.labels[summary.languageUsed] ?? summary.languageUsed),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(tr(context, 'results_review_answers'), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: p.textPrimary)),
              const SizedBox(height: 12),
              ...result.responses.map((response) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ReviewCard(response: response, language: _displayLanguage),
                  )),
              const SizedBox(height: 8),
              GradientButton(
                label: tr(context, 'results_retake'),
                icon: SolarIconsBold.restart,
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 17, color: p.textTertiary),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: p.textTertiary, fontSize: 14)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.response, required this.language});
  final ExamQuestion response; // selected/correct answers populated post-submission
  final String language;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final isCorrect = response.selectedAnswer == response.correctAnswer;
    final borderColor = isCorrect ? p.success : p.danger;
    final explanation = response.explanationFor(language);

    return AppCard(
      borderColor: borderColor.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(isCorrect ? SolarIconsBold.checkCircle : SolarIconsBold.closeCircle, color: borderColor, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${response.order}. ${response.questionTextFor(language)}',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: p.textPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final letter in const ['a', 'b', 'c'])
            _AnswerRow(
              letter: letter,
              text: response.optionTextFor(language, letter),
              isSelected: response.selectedAnswer == letter,
              isCorrectAnswer: response.correctAnswer == letter,
            ),
          if (explanation.isNotEmpty) ...[
            Divider(height: 20, color: p.border),
            Text(
              explanation,
              style: TextStyle(color: p.textSecondary, fontStyle: FontStyle.italic, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnswerRow extends StatelessWidget {
  const _AnswerRow({
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.isCorrectAnswer,
  });

  final String letter;
  final String text;
  final bool isSelected;
  final bool isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    Color color = p.textSecondary;
    IconData? icon;
    if (isCorrectAnswer) {
      color = p.success;
      icon = SolarIconsBold.checkCircle;
    } else if (isSelected && !isCorrectAnswer) {
      color = p.danger;
      icon = SolarIconsBold.closeCircle;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            '${letter.toUpperCase()}.',
            style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: p.textTertiary, fontSize: 15),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: (isSelected || isCorrectAnswer) ? FontWeight.w700 : FontWeight.normal,
              ),
            ),
          ),
          if (icon != null) Icon(icon, size: 18, color: color),
        ],
      ),
    );
  }
}
