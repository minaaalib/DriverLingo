import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/exam.dart';

class ExamService {
  final Dio _dio = ApiClient.instance.dio;

  /// POST /api/exams/start
  Future<ExamSession> startExam({
    required String category,
    required String language,
    required int numQuestions,
    int? timeLimitMinutes,
  }) async {
    try {
      final response = await _dio.post('/exams/start', data: {
        'category': category,
        'language': language,
        'num_questions': numQuestions,
        if (timeLimitMinutes != null) 'time_limit_minutes': timeLimitMinutes,
      });
      return ExamSession.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// POST /api/exams/submit
  Future<ExamResult> submitExam({
    required int examId,
    required Map<int, String?> answers,
    int? timeTakenSeconds,
  }) async {
    try {
      final response = await _dio.post('/exams/submit', data: {
        'exam_id': examId,
        'answers': answers.entries
            .map((e) => {'question_id': e.key, 'selected_answer': e.value})
            .toList(),
        if (timeTakenSeconds != null) 'time_taken_seconds': timeTakenSeconds,
      });
      return ExamResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// GET /api/exams/results/{exam_id}
  Future<ExamResult> getResult(int examId) async {
    try {
      final response = await _dio.get('/exams/results/$examId');
      return ExamResult.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }

  /// GET /api/exams/history
  Future<List<ExamSummary>> getHistory() async {
    try {
      final summaries = <ExamSummary>[];
      String? nextUrl = '/exams/history';
      while (nextUrl != null) {
        final response = await _dio.get(nextUrl);
        final data = response.data as Map<String, dynamic>;
        summaries.addAll((data['results'] as List).map((e) => ExamSummary.fromJson(e as Map<String, dynamic>)));
        nextUrl = data['next'] as String?;
      }
      return summaries;
    } on DioException catch (e) {
      throw ApiException.fromDioError(e);
    }
  }
}
