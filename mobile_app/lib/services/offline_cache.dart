import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/question.dart';

/// Local SQLite cache so a downloaded question bank (and completed exam
/// history) can be reviewed with no network connection - "Offline Mode"
/// from the spec. This does not replace the server as the source of
/// truth for grading; it's a read/study cache plus a queue of exam
/// attempts taken offline, synced back up next time the app is online.
class OfflineCache {
  OfflineCache._internal();
  static final OfflineCache instance = OfflineCache._internal();

  Database? _db;

  Future<Database> get _database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lto_reviewer_offline.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE questions (
            id INTEGER PRIMARY KEY,
            lang TEXT NOT NULL,
            category TEXT NOT NULL,
            payload TEXT NOT NULL,
            cached_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE pending_results (
            local_id INTEGER PRIMARY KEY AUTOINCREMENT,
            category TEXT NOT NULL,
            language TEXT NOT NULL,
            score INTEGER NOT NULL,
            total_questions INTEGER NOT NULL,
            taken_at TEXT NOT NULL,
            synced INTEGER NOT NULL DEFAULT 0
          )
        ''');
      },
    );
    return _db!;
  }

  /// Replaces the cached question bank for a given language/category with
  /// a freshly downloaded set.
  Future<void> saveQuestionBank(List<ReviewerQuestion> questions, {required String lang, required String category}) async {
    final db = await _database;
    final now = DateTime.now().toIso8601String();
    final batch = db.batch();
    batch.delete('questions', where: 'lang = ? AND category = ?', whereArgs: [lang, category]);
    for (final q in questions) {
      batch.insert('questions', {
        'id': q.id,
        'lang': lang,
        'category': category,
        'payload': jsonEncode({
          'id': q.id,
          'question': q.question,
          'option_a': q.optionA,
          'option_b': q.optionB,
          'option_c': q.optionC,
          'correct_answer': q.correctAnswer,
          'explanation': q.explanation,
          'category': q.category,
        }),
        'cached_at': now,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<ReviewerQuestion>> loadQuestionBank({required String lang, required String category}) async {
    final db = await _database;
    final rows = await db.query('questions', where: 'lang = ? AND category = ?', whereArgs: [lang, category]);
    return rows.map((row) {
      final data = jsonDecode(row['payload'] as String) as Map<String, dynamic>;
      return ReviewerQuestion(
        id: data['id'] as int,
        question: data['question'] as String,
        optionA: data['option_a'] as String,
        optionB: data['option_b'] as String,
        optionC: data['option_c'] as String,
        correctAnswer: data['correct_answer'] as String? ?? '',
        explanation: data['explanation'] as String? ?? '',
        category: data['category'] as String? ?? 'all',
        needsReview: false,
      );
    }).toList();
  }

  Future<bool> hasCachedBank({required String lang, required String category}) async {
    final db = await _database;
    final rows = await db.query('questions', where: 'lang = ? AND category = ?', whereArgs: [lang, category], limit: 1);
    return rows.isNotEmpty;
  }

  /// Called when a mock exam is completed while offline; queued here and
  /// pushed to the server (or simply left as a local-only record, shown
  /// in a "downloaded / offline results" section) next time we're online.
  Future<void> queueOfflineResult({
    required String category,
    required String language,
    required int score,
    required int totalQuestions,
  }) async {
    final db = await _database;
    await db.insert('pending_results', {
      'category': category,
      'language': language,
      'score': score,
      'total_questions': totalQuestions,
      'taken_at': DateTime.now().toIso8601String(),
      'synced': 0,
    });
  }

  Future<List<Map<String, Object?>>> pendingResults() async {
    final db = await _database;
    return db.query('pending_results', where: 'synced = 0', orderBy: 'taken_at DESC');
  }
}
