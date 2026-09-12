/// A localized question as delivered by the API (either the reviewer
/// listing at `/questions?lang=..`, or an in-progress exam question at
/// `/exams/start`). Both endpoints return the same shape, minus
/// `correctAnswer`/`explanation` while an exam is still in progress.
class ExamQuestion {
  ExamQuestion({
    required this.questionId,
    required this.order,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    this.questionPhoto,
    this.optionAPhoto,
    this.optionBPhoto,
    this.optionCPhoto,
    this.correctAnswer,
    this.explanation,
    this.selectedAnswer,
    this.translations = const {},
  });

  final int questionId;
  final int order;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String? questionPhoto;
  final String? optionAPhoto;
  final String? optionBPhoto;
  final String? optionCPhoto;

  /// Only present once the exam has been submitted and results fetched.
  final String? correctAnswer;
  final String? explanation;

  /// Mutable: the option ('a' | 'b' | 'c') the user has picked so far,
  /// tracked locally while the exam is in progress.
  String? selectedAnswer;

  /// Question/option text in every language ('en' | 'ph' | 'hl'), each a
  /// map with keys 'question', 'option_a', 'option_b', 'option_c'. Lets
  /// the exam screen offer an in-place translate toggle without extra
  /// network calls. Empty for payloads that don't include it (e.g. the
  /// post-submission results, which already know their one language).
  final Map<String, Map<String, String>> translations;

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

  /// The question/option text for [lang] ('en' | 'ph' | 'hl'), falling
  /// back to the exam's original language if no translation was shipped.
  String questionTextFor(String lang) => translations[lang]?['question'] ?? question;

  String optionTextFor(String lang, String letter) =>
      translations[lang]?['option_$letter'] ?? optionText(letter);

  /// The explanation for [lang], falling back to whatever language the
  /// exam was actually submitted in. Only meaningful post-submission
  /// (results), since explanations aren't shipped while an exam is live.
  String explanationFor(String lang) => translations[lang]?['explanation'] ?? explanation ?? '';

  factory ExamQuestion.fromJson(Map<String, dynamic> json) {
    return ExamQuestion(
      questionId: json['question_id'] as int,
      order: json['order'] as int,
      question: json['question'] as String? ?? '',
      optionA: json['option_a'] as String? ?? '',
      optionB: json['option_b'] as String? ?? '',
      optionC: json['option_c'] as String? ?? '',
      questionPhoto: json['question_photo'] as String?,
      optionAPhoto: json['option_a_photo'] as String?,
      optionBPhoto: json['option_b_photo'] as String?,
      optionCPhoto: json['option_c_photo'] as String?,
      correctAnswer: json['correct_answer'] as String?,
      explanation: json['explanation'] as String?,
      selectedAnswer: json['selected_answer'] as String?,
      translations: (json['translations'] as Map<String, dynamic>?)?.map(
            (lang, fields) => MapEntry(lang, (fields as Map<String, dynamic>).map((k, v) => MapEntry(k, v as String))),
          ) ??
          const {},
    );
  }

  Map<String, dynamic> toCacheJson() => {
        'question_id': questionId,
        'order': order,
        'question': question,
        'option_a': optionA,
        'option_b': optionB,
        'option_c': optionC,
        'question_photo': questionPhoto,
        'option_a_photo': optionAPhoto,
        'option_b_photo': optionBPhoto,
        'option_c_photo': optionCPhoto,
        'correct_answer': correctAnswer,
        'explanation': explanation,
        'translations': translations,
      };
}

/// A question as listed by the general reviewer endpoint
/// (`GET /api/questions?lang=..`), which always includes the answer key -
/// this is study material, not a live exam.
class ReviewerQuestion {
  ReviewerQuestion({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.correctAnswer,
    required this.explanation,
    required this.category,
    required this.needsReview,
  });

  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String correctAnswer;
  final String explanation;
  final String category;
  final bool needsReview;

  factory ReviewerQuestion.fromJson(Map<String, dynamic> json) {
    return ReviewerQuestion(
      id: json['id'] as int,
      question: json['question'] as String? ?? '',
      optionA: json['option_a'] as String? ?? '',
      optionB: json['option_b'] as String? ?? '',
      optionC: json['option_c'] as String? ?? '',
      correctAnswer: json['correct_answer'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
      category: json['category'] as String? ?? 'all',
      needsReview: json['needs_review'] as bool? ?? false,
    );
  }
}
