import 'dart:async';

import 'package:flutter/material.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/api_client.dart';
import '../core/app_strings.dart';
import '../core/constants.dart';
import '../models/exam.dart';
import '../models/question.dart';
import '../services/exam_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'results_screen.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key, required this.session});

  final ExamSession session;

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  final _examService = ExamService();
  late final PageController _pageController;
  late int _currentIndex;
  late final Map<int, String?> _answers;
  bool _isSubmitting = false;

  Timer? _ticker;
  late final DateTime _startedAt;
  Duration? _remaining;
  late String _displayLanguage;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _currentIndex = 0;
    _startedAt = DateTime.now();
    _displayLanguage = widget.session.summary.languageUsed;
    _answers = {for (final q in widget.session.questions) q.questionId: null};

    final limit = widget.session.summary.timeLimitMinutes;
    if (limit != null) {
      _remaining = Duration(minutes: limit);
      _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onTick() {
    final limit = widget.session.summary.timeLimitMinutes!;
    final elapsed = DateTime.now().difference(_startedAt);
    final remaining = Duration(minutes: limit) - elapsed;
    if (remaining.isNegative) {
      _ticker?.cancel();
      setState(() => _remaining = Duration.zero);
      _submit(autoSubmitted: true);
      return;
    }
    setState(() => _remaining = remaining);
  }

  int get _answeredCount => _answers.values.where((v) => v != null).length;

  Future<void> _submit({bool autoSubmitted = false}) async {
    if (_isSubmitting) return;

    if (!autoSubmitted && _answeredCount < widget.session.questions.length) {
      final proceed = await showAppConfirmDialog(
        context,
        icon: SolarIconsBold.checkCircle,
        title: trRead(context, 'exam_submit_dialog_title'),
        message: '${trfRead(context, 'exam_answered_count', {'a': '$_answeredCount', 'b': '${widget.session.questions.length}'})} '
            '${trRead(context, 'exam_unanswered_note')}',
        confirmLabel: trRead(context, 'exam_submit_button'),
        cancelLabel: trRead(context, 'exam_keep_answering'),
      );
      if (proceed != true) return;
    }

    setState(() => _isSubmitting = true);
    try {
      final elapsedSeconds = DateTime.now().difference(_startedAt).inSeconds;
      final result = await _examService.submitExam(
        examId: widget.session.summary.id,
        answers: _answers,
        timeTakenSeconds: elapsedSeconds,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ResultsScreen(result: result)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<bool> _confirmExit() async {
    final leave = await showAppConfirmDialog(
      context,
      icon: SolarIconsOutline.dangerCircle,
      destructive: true,
      title: trRead(context, 'exam_leave_dialog_title'),
      message: trRead(context, 'exam_leave_dialog_body'),
      confirmLabel: trRead(context, 'exam_leave'),
      cancelLabel: trRead(context, 'exam_stay'),
    );
    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final questions = widget.session.questions;
    final p = AppPalette.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmExit() && mounted) Navigator.of(context).pop();
      },
      child: GlowBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(trf(context, 'exam_question_of', {'a': '${_currentIndex + 1}', 'b': '${questions.length}'})),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(SolarIconsOutline.globus, color: p.textSecondary),
                tooltip: tr(context, 'action_translate'),
                initialValue: _displayLanguage,
                onSelected: (value) => setState(() => _displayLanguage = value),
                itemBuilder: (context) => AppLanguage.labels.entries
                    .map((entry) => PopupMenuItem(value: entry.key, child: Text(entry.value)))
                    .toList(),
              ),
              if (_remaining != null)
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: StatPill(
                      icon: SolarIconsOutline.stopwatch,
                      label: _formatDuration(_remaining!),
                      color: _remaining!.inMinutes < 5 ? p.danger : p.textPrimary,
                    ),
                  ),
                ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4),
              child: ClipRRect(
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / questions.length,
                  backgroundColor: p.chipBg,
                  valueColor: AlwaysStoppedAnimation(p.primary),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) => _QuestionPage(
                question: questions[index],
                language: _displayLanguage,
                selected: _answers[questions[index].questionId],
                onSelect: (letter) => setState(() => _answers[questions[index].questionId] = letter),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentIndex > 0)
                    Expanded(
                      child: OutlinePillButton(
                        label: tr(context, 'exam_previous'),
                        onPressed: () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                        ),
                      ),
                    ),
                  if (_currentIndex > 0) const SizedBox(width: 12),
                  Expanded(
                    child: _currentIndex == questions.length - 1
                        ? GradientButton(
                            label: _isSubmitting
                                ? tr(context, 'exam_submitting')
                                : '${tr(context, 'exam_submit_progress')} ($_answeredCount/${questions.length})',
                            isLoading: _isSubmitting,
                            onPressed: _isSubmitting ? null : () => _submit(),
                          )
                        : GradientButton(
                            label: tr(context, 'exam_next'),
                            icon: SolarIconsBold.arrowRight,
                            onPressed: () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _QuestionPage extends StatelessWidget {
  const _QuestionPage({required this.question, required this.language, required this.selected, required this.onSelect});

  final ExamQuestion question;
  final String language;
  final String? selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question.questionTextFor(language),
            style: TextStyle(fontSize: 23, height: 1.3, fontWeight: FontWeight.w800, color: p.textPrimary),
          ),
          if (question.questionPhoto != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(question.questionPhoto!, fit: BoxFit.cover),
            ),
          ],
          const SizedBox(height: 20),
          for (final letter in const ['a', 'b', 'c']) ...[
            _OptionCard(
              letter: letter,
              text: question.optionTextFor(language, letter),
              isSelected: selected == letter,
              onTap: () => onSelect(letter),
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({required this.letter, required this.text, required this.isSelected, required this.onTap});

  final String letter;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? p.primary : p.border, width: isSelected ? 1.6 : 1),
          borderRadius: BorderRadius.circular(16),
          color: isSelected ? p.primary.withValues(alpha: 0.12) : p.surface,
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? p.primary : p.chipBg,
              ),
              alignment: Alignment.center,
              child: Text(
                letter.toUpperCase(),
                style: TextStyle(color: isSelected ? Colors.white : p.textSecondary, fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: p.textPrimary, fontSize: 17, fontWeight: FontWeight.w600, height: 1.25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
