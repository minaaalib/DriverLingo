import 'question.dart';

class ExamSummary {
  ExamSummary({
    required this.id,
    required this.category,
    required this.languageUsed,
    required this.totalQuestions,
    required this.status,
    required this.score,
    required this.percentage,
    required this.startedAt,
    this.timeLimitMinutes,
    this.submittedAt,
  });

  final int id;
  final String category;
  final String languageUsed;
  final int totalQuestions;
  final int? timeLimitMinutes;
  final String status;
  final int score;
  final double percentage;
  final DateTime startedAt;
  final DateTime? submittedAt;

  bool get passed => percentage >= 80; // LTO's usual passing mark

  factory ExamSummary.fromJson(Map<String, dynamic> json) {
    return ExamSummary(
      id: json['id'] as int,
      category: json['category'] as String,
      languageUsed: json['language_used'] as String,
      totalQuestions: json['total_questions'] as int,
      timeLimitMinutes: json['time_limit_minutes'] as int?,
      status: json['status'] as String,
      score: json['score'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      startedAt: DateTime.parse(json['started_at'] as String),
      submittedAt: json['submitted_at'] != null ? DateTime.parse(json['submitted_at'] as String) : null,
    );
  }
}

class ExamSession {
  ExamSession({required this.summary, required this.questions});

  final ExamSummary summary;
  final List<ExamQuestion> questions;

  factory ExamSession.fromJson(Map<String, dynamic> json) {
    return ExamSession(
      summary: ExamSummary.fromJson(json['exam'] as Map<String, dynamic>),
      questions: (json['questions'] as List)
          .map((q) => ExamQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ExamResult {
  ExamResult({required this.summary, required this.responses});

  final ExamSummary summary;
  final List<ExamQuestion> responses;

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      summary: ExamSummary.fromJson(json),
      responses: (json['responses'] as List)
          .map((q) => ExamQuestion.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }
}
