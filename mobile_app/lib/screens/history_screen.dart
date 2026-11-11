import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';

import '../core/api_client.dart';
import '../core/app_strings.dart';
import '../core/constants.dart';
import '../services/language_service.dart';
import '../models/exam.dart';
import '../services/exam_service.dart';
import '../theme/app_theme.dart';
import '../theme/widgets.dart';
import 'exam_screen.dart';
import 'results_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _examService = ExamService();
  late Future<List<ExamSummary>> _future;

  @override
  void initState() {
    super.initState();
    _future = _examService.getHistory();
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    return GlowBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: PageEntrance(
                child: Text(tr(context, 'history_title'),
                    style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: p.textPrimary)),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ExamSummary>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(color: p.primary));
                  }
                  if (snapshot.hasError) {
                    final message = snapshot.error is ApiException
                        ? (snapshot.error as ApiException).message
                        : tr(context, 'history_failed_load');
                    return Center(
                        child: Text(message,
                            style: TextStyle(color: p.textSecondary)));
                  }
                  final exams = snapshot.data ?? [];
                  if (exams.isEmpty) {
                    return Center(
                      child: Text(tr(context, 'history_empty'),
                          style: TextStyle(color: p.textSecondary)),
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + MediaQuery.paddingOf(context).bottom),
                    itemCount: exams.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => StaggeredListItem(
                      index: index,
                      child: _HistoryCard(exam: exams[index]),
                    ),
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

class _HistoryCard extends StatefulWidget {
  const _HistoryCard({required this.exam});
  final ExamSummary exam;

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  final _examService = ExamService();
  bool _isLoading = false;

  Future<void> _onTap() async {
    if (_isLoading) return;
    switch (widget.exam.status) {
      case 'completed':
        await _openResult();
      case 'in_progress':
        await _resume();
    }
  }

  Future<void> _openResult() async {
    setState(() => _isLoading = true);
    try {
      final result = await _examService.getResult(widget.exam.id);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ResultsScreen(result: result)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resume() async {
    final proceed = await showAppConfirmDialog(
      context,
      icon: SolarIconsBold.arrowRight,
      title: trRead(context, 'history_resume_dialog_title'),
      message: trRead(context, 'history_resume_dialog_message'),
      confirmLabel: trRead(context, 'history_resume_confirm'),
      cancelLabel: trRead(context, 'history_resume_cancel'),
    );
    if (proceed != true || !mounted) return;

    setState(() => _isLoading = true);
    try {
      final session = await _examService.resumeExam(widget.exam.id);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ExamScreen(session: session)),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = AppPalette.of(context);
    final exam = widget.exam;
    final passed = exam.passed;
    final scoreColor = passed ? p.success : p.danger;

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: _onTap,
      child: AppCard(
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: Clay.accent(scoreColor, shape: BoxShape.circle, depth: 0.7),
              alignment: Alignment.center,
              child: Text('${exam.percentage.round()}%',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${ExamCategory.labelFor(exam.category, context.watch<LanguagePreference>().language)} · ${AppLanguage.labels[exam.languageUsed] ?? exam.languageUsed}',
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: p.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${exam.score}/${exam.totalQuestions} ${tr(context, 'history_correct')} · ${DateFormat.yMMMd().add_jm().format((exam.submittedAt ?? exam.startedAt).toLocal())}',
                    style: TextStyle(color: p.textTertiary, fontSize: 14),
                  ),
                ],
              ),
            ),
            if (_isLoading)
              SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: p.textTertiary))
            else
              Icon(
                exam.status == 'completed'
                    ? SolarIconsBold.checkCircle
                    : SolarIconsOutline.hourglass,
                color: exam.status == 'completed' ? p.success : p.textTertiary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
