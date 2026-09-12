import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/question.dart';
import '../services/question_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';

/// Untimed study mode: browse the full question bank (with answers and
/// explanations shown up front) instead of taking a graded mock exam.
class ReviewerScreen extends StatefulWidget {
  const ReviewerScreen({super.key});

  @override
  State<ReviewerScreen> createState() => _ReviewerScreenState();
}

class _ReviewerScreenState extends State<ReviewerScreen> {
  final _service = QuestionService();
  String _language = AppLanguage.english;
  late Future<List<ReviewerQuestion>> _future;
  int? _expandedId;

  @override
  void initState() {
    super.initState();
    _future = _service.getReviewerQuestions(lang: _language);
  }

  void _changeLanguage(String lang) {
    setState(() {
      _language = lang;
      _future = _service.getReviewerQuestions(lang: _language);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return GlowBackground(
      child: SafeArea(
        child: Column(
          children: [
            PageEntrance(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Reviewer', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w800, color: p.textPrimary)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: AppLanguage.labels.entries
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: PillChip(label: e.value, selected: _language == e.key, onTap: () => _changeLanguage(e.key)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<ReviewerQuestion>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: p.primary));
                  }
                  if (snapshot.hasError) {
                    final message = snapshot.error is ApiException
                        ? (snapshot.error as ApiException).message
                        : 'Failed to load the reviewer.';
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: p.textSecondary)),
                      ),
                    );
                  }
                  final questions = snapshot.data ?? [];
                  if (questions.isEmpty) {
                    return Center(child: Text('No questions available yet.', style: TextStyle(color: p.textSecondary)));
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final q = questions[index];
                      final expanded = _expandedId == q.id;
                      return StaggeredListItem(
                        index: index,
                        child: _ReviewerCard(
                          index: index + 1,
                          question: q,
                          expanded: expanded,
                          onTap: () => setState(() => _expandedId = expanded ? null : q.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewerCard extends StatelessWidget {
  const _ReviewerCard({required this.index, required this.question, required this.expanded, required this.onTap});

  final int index;
  final ReviewerQuestion question;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    '$index. ${question.question}',
                    style: TextStyle(fontWeight: FontWeight.w700, color: p.textPrimary, fontSize: 15),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  child: Icon(SolarIconsOutline.altArrowDown, color: p.textTertiary),
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              alignment: Alignment.topLeft,
              child: !expanded
                  ? const SizedBox(width: double.infinity)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        for (final letter in const ['a', 'b', 'c'])
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _OptionLine(
                              letter: letter,
                              text: question.optionText(letter),
                              isCorrect: question.correctAnswer == letter,
                            ),
                          ),
                        if (question.explanation.isNotEmpty) ...[
                          Divider(height: 20, color: p.border),
                          Text(question.explanation, style: TextStyle(color: p.textSecondary, fontSize: 13, height: 1.4)),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on ReviewerQuestion {
  String optionText(String letter) {
    switch (letter) {
      case 'a':
        return optionA;
      case 'b':
        return optionB;
      case 'c':
        return optionC;
      default:
        return '';
    }
  }
}

class _OptionLine extends StatelessWidget {
  const _OptionLine({required this.letter, required this.text, required this.isCorrect});
  final String letter;
  final String text;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final color = isCorrect ? p.success : p.textSecondary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${letter.toUpperCase()}.', style: TextStyle(color: color, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: TextStyle(color: color, fontWeight: isCorrect ? FontWeight.w700 : FontWeight.w400))),
        if (isCorrect) Icon(SolarIconsBold.checkCircle, size: 16, color: p.success),
      ],
    );
  }
}
