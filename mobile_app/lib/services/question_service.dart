import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

import '../core/api_client.dart';
import '../models/question.dart';
import 'offline_cache.dart';

class QuestionService {
  final Dio _dio = ApiClient.instance.dio;

  Future<bool> get _isOnline async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  /// Fetches the reviewer question bank (with answers/explanations) for
  /// study purposes, transparently falling back to the offline cache
  /// when there's no connection.
  Future<List<ReviewerQuestion>> getReviewerQuestions({
    required String lang,
    String category = 'all',
  }) async {
    if (await _isOnline) {
      try {
        final questions = <ReviewerQuestion>[];
        String? nextUrl = '/questions/';
        Map<String, dynamic>? query = {'lang': lang, if (category != 'all') 'category': category, 'page_size': 100};

        while (nextUrl != null) {
          final response = await _dio.get(nextUrl, queryParameters: query);
          final data = response.data as Map<String, dynamic>;
          questions.addAll((data['results'] as List).map((e) => ReviewerQuestion.fromJson(e as Map<String, dynamic>)));
          nextUrl = data['next'] as String?;
          query = null; // 'next' already contains the full querystring
        }

        await OfflineCache.instance.saveQuestionBank(questions, lang: lang, category: category);
        return questions;
      } on DioException {
        return _fallbackToCache(lang, category);
      }
    }
    return _fallbackToCache(lang, category);
  }

  Future<List<ReviewerQuestion>> _fallbackToCache(String lang, String category) async {
    final cached = await OfflineCache.instance.loadQuestionBank(lang: lang, category: category);
    if (cached.isEmpty) {
      throw ApiException('No internet connection and no downloaded reviewer available for this language yet.');
    }
    return cached;
  }

  /// Explicitly triggers a download of the full question bank for
  /// offline use (the "Download question banks for offline access"
  /// feature) - call this from a settings/download screen for each
  /// language the user wants available offline.
  Future<int> downloadForOffline({required String lang}) async {
    final questions = await getReviewerQuestions(lang: lang, category: 'all');
    return questions.length;
  }

  Future<bool> hasOfflineCopy({required String lang}) {
    return OfflineCache.instance.hasCachedBank(lang: lang, category: 'all');
  }
}
