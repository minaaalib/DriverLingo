import 'exam.dart';

/// Practice stats derived client-side from exam history — the backend
/// doesn't track a "best score" / "streak" / "readiness" concept, so these
/// are computed here from the plain history list.
class ExamStats {
  const ExamStats({
    required this.bestPercentage,
    required this.streakDays,
    required this.readiness,
    required this.hasHistory,
  });

  final double? bestPercentage;
  final int streakDays;
  final double readiness;
  final bool hasHistory;

  static ExamStats compute(List<ExamSummary> history) {
    final completed = history.where((e) => e.status == 'completed').toList();
    if (completed.isEmpty) {
      return const ExamStats(bestPercentage: null, streakDays: 0, readiness: 0, hasHistory: false);
    }

    final best = completed.map((e) => e.percentage).reduce((a, b) => a > b ? a : b);

    final days = completed
        .map((e) => (e.submittedAt ?? e.startedAt).toLocal())
        .map((d) => DateTime(d.year, d.month, d.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    if (days.isNotEmpty) {
      final today = DateTime.now();
      final todayDate = DateTime(today.year, today.month, today.day);
      final mostRecent = days.first;
      if (todayDate.difference(mostRecent).inDays <= 1) {
        streak = 1;
        var cursor = mostRecent;
        for (var i = 1; i < days.length; i++) {
          final expected = cursor.subtract(const Duration(days: 1));
          if (days[i] == expected) {
            streak++;
            cursor = expected;
          } else {
            break;
          }
        }
      }
    }

    final recent = List<ExamSummary>.from(completed)
      ..sort((a, b) => (b.submittedAt ?? b.startedAt).compareTo(a.submittedAt ?? a.startedAt));
    final sample = recent.take(5).map((e) => e.percentage).toList();
    final readiness = sample.reduce((a, b) => a + b) / sample.length;

    return ExamStats(bestPercentage: best, streakDays: streak, readiness: readiness, hasHistory: true);
  }
}
