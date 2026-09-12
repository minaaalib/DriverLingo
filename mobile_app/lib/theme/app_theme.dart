import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One consistent set of design tokens for both the dark and light look.
/// Access the palette that matches the current theme with [AppPalette.of].
class AppPalette {
  const AppPalette({
    required this.bg,
    required this.glowTop,
    required this.glowBottom,
    required this.surface,
    required this.surfaceElevated,
    required this.border,
    required this.borderStrong,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.primary,
    required this.primaryDeep,
    required this.success,
    required this.successDeep,
    required this.danger,
    required this.chipBg,
    required this.chipBorder,
    required this.navBg,
    required this.navBorder,
  });

  final Color bg;
  final Color glowTop;
  final Color glowBottom;
  final Color surface;
  final Color surfaceElevated;
  final Color border;
  final Color borderStrong;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color primary;
  final Color primaryDeep;
  final Color success;
  final Color successDeep;
  final Color danger;
  final Color chipBg;
  final Color chipBorder;
  final Color navBg;
  final Color navBorder;

  static const dark = AppPalette(
    bg: Color(0xFF0A0E17),
    glowTop: Color(0x333B82F6),
    glowBottom: Color(0x2622C55E),
    surface: Color(0xFF141B2E),
    surfaceElevated: Color(0xFF1A2338),
    border: Color(0xFF232B40),
    borderStrong: Color(0xFF3A4460),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF9AA7BD),
    textTertiary: Color(0xFF6B7690),
    primary: Color(0xFF3057D6),
    primaryDeep: Color(0xFF101F4D),
    success: Color(0xFF34D399),
    successDeep: Color(0xFF16A34A),
    danger: Color(0xFFF16C6C),
    chipBg: Color(0xFF161E33),
    chipBorder: Color(0xFF262F48),
    navBg: Color(0xFF10152355),
    navBorder: Color(0xFF232B40),
  );

  static const light = AppPalette(
    bg: Color(0xFFF3F5F9),
    glowTop: Color(0x1A3B82F6),
    glowBottom: Color(0x1422C55E),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    border: Color(0xFFE4E8F0),
    borderStrong: Color(0xFFD3DAE6),
    textPrimary: Color(0xFF10182B),
    textSecondary: Color(0xFF5A6478),
    textTertiary: Color(0xFF8A94A6),
    primary: Color(0xFF2C4FC7),
    primaryDeep: Color(0xFF15265E),
    success: Color(0xFF16A34A),
    successDeep: Color(0xFF0F8A3C),
    danger: Color(0xFFDC2626),
    chipBg: Color(0xFFF1F4F9),
    chipBorder: Color(0xFFE4E8F0),
    navBg: Color(0xFFFFFFFF),
    navBorder: Color(0xFFE4E8F0),
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _base(Brightness.light, AppPalette.light);
  static ThemeData dark() => _base(Brightness.dark, AppPalette.dark);

  static ThemeData _base(Brightness brightness, AppPalette p) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: p.bg,
      colorScheme: base.colorScheme.copyWith(
        primary: p.primary,
        onPrimary: Colors.white,
        surface: p.surface,
        onSurface: p.textPrimary,
        error: p.danger,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme)
          .copyWith(
            displayLarge: GoogleFonts.playfairDisplay(textStyle: base.textTheme.displayLarge),
            displayMedium: GoogleFonts.playfairDisplay(textStyle: base.textTheme.displayMedium),
            displaySmall: GoogleFonts.playfairDisplay(textStyle: base.textTheme.displaySmall),
            headlineLarge: GoogleFonts.playfairDisplay(textStyle: base.textTheme.headlineLarge),
            headlineMedium: GoogleFonts.playfairDisplay(textStyle: base.textTheme.headlineMedium),
            headlineSmall: GoogleFonts.playfairDisplay(textStyle: base.textTheme.headlineSmall),
            titleLarge: GoogleFonts.playfairDisplay(textStyle: base.textTheme.titleLarge),
            titleMedium: GoogleFonts.playfairDisplay(textStyle: base.textTheme.titleMedium),
            titleSmall: GoogleFonts.playfairDisplay(textStyle: base.textTheme.titleSmall),
          )
          .apply(
            bodyColor: p.textPrimary,
            displayColor: p.textPrimary,
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.textPrimary,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          color: p.textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: p.danger),
        ),
        labelStyle: TextStyle(color: p.textSecondary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Colors.white : p.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? p.success : p.chipBg,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      dividerColor: p.border,
      splashFactory: InkSparkle.splashFactory,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.primary),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(backgroundColor: p.primary, foregroundColor: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: p.primary, foregroundColor: Colors.white),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surfaceElevated,
        titleTextStyle: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        contentTextStyle: TextStyle(color: p.textSecondary, fontSize: 14),
      ),
    );
  }
}
