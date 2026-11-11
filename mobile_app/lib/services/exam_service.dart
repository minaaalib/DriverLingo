import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/api_client.dart';
import '../models/exam.dart';
import '../models/question.dart';

class ExamService {
  SupabaseClient get _client => Supabase.instance.client;

  /// Bumped every time an exam is submitted, from any screen (home,
  /// onboarding practice, a resumed exam from History), so listeners like
  /// the home screen's stats/streak card can reload.
  static final ValueNotifier<int> historyChanged = ValueNotifier<int>(0);

  /// Calls the start_exam() RPC (supabase/migrations/0001_init.sql) -
  /// mirrors what POST /api/exams/start used to do, including leaving
  /// correct_answer/explanation out of the response.
  Future<ExamSession> startExam({
    required String category,
    required String language,
    required int numQuestions,
    int? timeLimitMinutes,
  }) async {
    try {
      final data = await _client.rpc('start_exam', params: {
        'p_category': category,
        'p_language': language,
        'p_num_questions': numQuestions,
        'p_time_limit_minutes': timeLimitMinutes,
      });
      return ExamSession.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Calls the resume_exam() RPC (supabase/migrations/0002_resume_exam.sql)
  /// to pick an in_progress exam (from History) back up: same shape as
  /// [startExam]'s response, but with each question's previously-selected
  /// answer included so the exam screen can prefill them.
  Future<ExamSession> resumeExam(int examId) async {
    try {
      final data =
          await _client.rpc('resume_exam', params: {'p_exam_id': examId});
      return ExamSession.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Calls the submit_exam() RPC - grades atomically and returns the full
  /// result (now including correct_answer/explanation), mirroring
  /// POST /api/exams/submit.
  Future<ExamResult> submitExam({
    required int examId,
    required Map<int, String?> answers,
    int? timeTakenSeconds,
  }) async {
    try {
      final data = await _client.rpc('submit_exam', params: {
        'p_exam_id': examId,
        'p_answers': answers.entries
            .map((e) => {'question_id': e.key, 'selected_answer': e.value})
            .toList(),
        'p_time_taken_seconds': timeTakenSeconds,
      });
      historyChanged.value++;
      return ExamResult.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      throw ApiException.from(e);
    }
  }

  /// Reads the exam_results_view (one row per question; only ever
  /// populated once an exam is completed), mirroring
  /// GET /api/exams/results/{exam_id}.
  Future<ExamResult> getResult(int examId) async {
    try {
      final rows = await _client
          .from('exam_results_view')
          .select()
          .eq('id', examId)
          .order('order');
      if (rows.isEmpty) {
        throw ApiException('Exam result not found.');
      }
      final summary = ExamSummary.fromJson(rows.first);
      final responses = rows.map((r) => ExamQuestion.fromJson(r)).toList();
      return ExamResult(summary: summary, responses: responses);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException.from(e);
    }
  }

  /// Reads the exams table directly - RLS already scopes this to the
  /// current user, and `percentage` is a stored generated column, so no
  /// RPC/view is needed here. Mirrors GET /api/exams/history.
  Future<List<ExamSummary>> getHistory() async {
    try {
      final rows = await _client
          .from('exams')
          .select()
          .order('started_at', ascending: false);
      return rows.map((e) => ExamSummary.fromJson(e)).toList();
    } catch (e) {
      throw ApiException.from(e);
    }
  }
}
