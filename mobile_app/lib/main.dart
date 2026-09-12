import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants.dart';
import 'screens/welcome_screen.dart';
import 'services/auth_service.dart';
import 'services/language_service.dart';
import 'services/theme_service.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  runApp(const LtoReviewerApp());
}

class LtoReviewerApp extends StatelessWidget {
  const LtoReviewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()..restoreSession()),
        ChangeNotifierProvider(create: (_) => LanguagePreference()..restore()),
        ChangeNotifierProvider(create: (_) => ThemePreference()..restore()),
      ],
      child: Consumer<ThemePreference>(
        builder: (context, themePref, _) => MaterialApp(
          title: 'DriverLingo',
          debugShowCheckedModeBanner: false,
          themeMode: themePref.mode,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          home: const WelcomeScreen(),
        ),
      ),
    );
  }
}
