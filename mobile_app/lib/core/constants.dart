/// Supabase project + Google Sign-In configuration - Supabase is now the
/// whole backend (Postgres + Auth), not just an identity bridge, so this
/// replaces the old Django/Render ApiConfig entirely.
///
/// Fill these in from your Supabase project (Settings > API) and Google
/// Cloud OAuth client (APIs & Services > Credentials), then run with:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_PUBLISHABLE_KEY=... --dart-define=GOOGLE_WEB_CLIENT_ID=...
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://qthaaqfzbvjgtawzysyo.supabase.co',
  );

  /// Supabase publishable key (Settings > API Keys). Safe to ship in the
  /// app; it replaces the legacy JWT "anon" key.
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: 'sb_publishable_0OZSPi2Qp9ZbAjDQ3qp5LA_mp5sdiXF',
  );

  /// The "Web application" OAuth client ID from Google Cloud Console.
  /// Passed as `serverClientId` so google_sign_in returns an ID token whose
  /// audience matches what Supabase (and the Django backend) expect.
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: '711468730862-0vik098qe0rofh4fk4b06440er7u7q1f.apps.googleusercontent.com',
  );
}

/// Exam categories the LTO recognizes, and the standard LTO item counts
/// used as sensible defaults (the user can still pick a custom count).
class ExamCategory {
  static const String nonProfessional = 'non_professional';
  static const String professional = 'professional';

  static const Map<String, String> labels = {
    nonProfessional: 'Non-Professional',
    professional: 'Professional',
  };

  static const Map<String, Map<String, String>> _translatedLabels = {
    nonProfessional: {
      AppLanguage.english: 'Non-Professional',
      AppLanguage.filipino: 'Di-Propesyonal',
      AppLanguage.hiligaynon: 'Indi-Propesyonal',
    },
    professional: {
      AppLanguage.english: 'Professional',
      AppLanguage.filipino: 'Propesyonal',
      AppLanguage.hiligaynon: 'Propesyonal',
    },
  };

  /// [labels] translated for [language], falling back to the English label
  /// for an unrecognized category.
  static String labelFor(String category, String language) {
    final entry = _translatedLabels[category];
    if (entry == null) return labels[category] ?? category;
    return entry[language] ?? entry[AppLanguage.english]!;
  }

  static const Map<String, int> standardCounts = {
    nonProfessional: 40,
    professional: 60,
  };

  /// Every mock exam is timed at a flat 60 minutes, matching the LTO's
  /// standard non-professional exam duration. Not user-adjustable.
  static const int standardTimerMinutes = 60;

  /// Item count and time limit for the short, mandatory practice exam a
  /// new user takes during onboarding (see OnboardingScreen) - deliberately
  /// much shorter than [standardCounts] so it reads as a quick first taste
  /// of the exam format rather than a full attempt.
  static const int onboardingPracticeCount = 5;
  static const int onboardingPracticeTimerMinutes = 5;
}

class AppLanguage {
  static const String english = 'en';
  static const String filipino = 'ph';
  static const String hiligaynon = 'hl';

  static const Map<String, String> labels = {
    english: 'English',
    filipino: 'Filipino',
    hiligaynon: 'Hiligaynon',
  };
}
