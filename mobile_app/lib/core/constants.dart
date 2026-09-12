/// Central place for API configuration.
///
/// For the Android emulator, `10.0.2.2` reaches the host machine's
/// `localhost`, which is where `python manage.py runserver` listens by
/// default. Point this at your real deployment's URL when you're not
/// running the backend locally (see the backend README for deployment
/// instructions).
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api',
  );

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
}

/// Supabase project + Google Sign-In configuration.
///
/// Fill these in from your Supabase project (Settings > API) and Google
/// Cloud OAuth client (APIs & Services > Credentials), then run with:
///   flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=... --dart-define=GOOGLE_WEB_CLIENT_ID=...
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://qthaaqfzbvjgtawzysyo.supabase.co',
  );

  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF0aGFhcWZ6YnZqZ3Rhd3p5c3lvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODkwMzI0NzcsImV4cCI6MjEwNDYwODQ3N30.PqZKYDIP1-vE88Go5dKRM4DJKOkDSI1qiJKbNgkMtow',
  );

  /// The "Web application" OAuth client ID from Google Cloud Console.
  /// Passed as `serverClientId` so google_sign_in returns an ID token whose
  /// audience matches what Supabase (and the Django backend) expect.
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue: 'REPLACE_WITH_GOOGLE_WEB_CLIENT_ID',
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
