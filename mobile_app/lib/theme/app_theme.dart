import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// One consistent set of design tokens for both the dark and light look.
/// Access the palette that matches the current theme with [AppPalette.of].
///
/// The look is "claymorphism": soft pastel surfaces that read as puffy,
/// rounded clay - a tinted drop shadow below, a light highlight above,
/// and a faint bright rim. Build those surfaces with [Clay].
class AppPalette {
  const AppPalette({
    required this.isDark,
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
    required this.clayShadow,
    required this.clayHighlight,
    required this.clayRim,
  });

  final bool isDark;
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

  /// Soft drop shadow under clay surfaces (bottom-right).
  final Color clayShadow;

  /// Light glow above clay surfaces (top-left).
  final Color clayHighlight;

  /// Thin bright edge that makes clay surfaces look rounded.
  final Color clayRim;

  static const dark = AppPalette(
    isDark: true,
    bg: Color(0xFF161A27),
    glowTop: Color(0x335B7BF7),
    glowBottom: Color(0x2634D399),
    surface: Color(0xFF21273B),
    surfaceElevated: Color(0xFF283048),
    border: Color(0xFF2F3852),
    borderStrong: Color(0xFF434E6E),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFFA3AEC4),
    textTertiary: Color(0xFF76819B),
    primary: Color(0xFF5B7BF7),
    primaryDeep: Color(0xFF3A55D9),
    success: Color(0xFF34D399),
    successDeep: Color(0xFF16A34A),
    danger: Color(0xFFF47A7A),
    chipBg: Color(0xFF1C2234),
    chipBorder: Color(0xFF2F3852),
    navBg: Color(0xFF21273B),
    navBorder: Color(0xFF2F3852),
    clayShadow: Color(0x99000000),
    clayHighlight: Color(0x10FFFFFF),
    clayRim: Color(0x0FFFFFFF),
  );

  static const light = AppPalette(
    isDark: false,
    bg: Color(0xFFECEFF8),
    glowTop: Color(0x265B7BF7),
    glowBottom: Color(0x1F34D399),
    surface: Color(0xFFF7F8FD),
    surfaceElevated: Color(0xFFFBFCFF),
    border: Color(0xFFE0E5F2),
    borderStrong: Color(0xFFC9D1E6),
    textPrimary: Color(0xFF1A2138),
    textSecondary: Color(0xFF5A6480),
    textTertiary: Color(0xFF8C95AD),
    primary: Color(0xFF4F6EF0),
    primaryDeep: Color(0xFF3A55D9),
    success: Color(0xFF16A34A),
    successDeep: Color(0xFF0F8A3C),
    danger: Color(0xFFE04848),
    chipBg: Color(0xFFE6EAF6),
    chipBorder: Color(0xFFD9DFEF),
    navBg: Color(0xFFF7F8FD),
    navBorder: Color(0xFFE0E5F2),
    clayShadow: Color(0x80A3AED3),
    clayHighlight: Color(0xE6FFFFFF),
    clayRim: Color(0xB3FFFFFF),
  );

  static AppPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? dark : light;
}

/// Ready-made claymorphism decorations, so every screen gets the same
/// puffy, rounded look.
class Clay {
  Clay._();

  /// A neutral clay surface (cards, tiles, icon buttons, dialogs).
  /// [color] may be a translucent tint - it is blended over the surface
  /// first. [depth] scales how raised it looks (0.5 = subtle, 1.4 = big).
  static BoxDecoration box(
    AppPalette p, {
    Color? color,
    double radius = 24,
    double depth = 1,
    Color? borderColor,
    BoxShape shape = BoxShape.rectangle,
  }) {
    var base = color ?? p.surface;
    if (base.a < 1) base = Color.alphaBlend(base, p.surface);
    return BoxDecoration(
      shape: shape,
      borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.lerp(base, Colors.white, p.isDark ? 0.035 : 0.55)!, base],
      ),
      border: Border.all(color: borderColor ?? p.clayRim, width: borderColor != null ? 1.6 : 1.2),
      boxShadow: shadows(p, depth: depth),
    );
  }

  /// A colored clay surface (primary buttons, selected chips, badges).
  static BoxDecoration accent(
    Color c, {
    double radius = 20,
    double depth = 1,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return BoxDecoration(
      shape: shape,
      borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.lerp(c, Colors.white, 0.22)!, c, Color.lerp(c, Colors.black, 0.08)!],
        stops: const [0, 0.55, 1],
      ),
      border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 1.2),
      boxShadow: [
        BoxShadow(color: c.withValues(alpha: 0.38), blurRadius: 20 * depth, offset: Offset(0, 9 * depth)),
        BoxShadow(color: Colors.white.withValues(alpha: 0.10), blurRadius: 10 * depth, offset: Offset(-3 * depth, -3 * depth)),
      ],
    );
  }

  /// White clay for controls sitting on the dark hero photo (welcome and
  /// login). Uses a dark drop shadow since the pastel one would vanish on
  /// the photo. Pair it with dark text such as `AppPalette.light.textPrimary`.
  static BoxDecoration white({double radius = 24, double depth = 1, BoxShape shape = BoxShape.rectangle}) {
    return BoxDecoration(
      shape: shape,
      borderRadius: shape == BoxShape.circle ? null : BorderRadius.circular(radius),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Color(0xFFF2F4FA), Color(0xFFE3E8F4)],
        stops: [0, 0.55, 1],
      ),
      border: Border.all(color: Colors.white, width: 1.4),
      boxShadow: [
        BoxShadow(color: Colors.black.withValues(alpha: 0.38), blurRadius: 24 * depth, offset: Offset(0, 12 * depth)),
        BoxShadow(color: Colors.white.withValues(alpha: 0.25), blurRadius: 12 * depth, offset: Offset(-4 * depth, -4 * depth)),
      ],
    );
  }

  /// A pressed-in clay well: progress-bar tracks, explanation boxes,
  /// anything that should look sunk into the surface instead of raised.
  static BoxDecoration inset(AppPalette p, {double radius = 16, Color? color}) {
    final base = color ?? p.chipBg;
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color.lerp(base, Colors.black, p.isDark ? 0.28 : 0.07)!, base, Color.lerp(base, Colors.white, p.isDark ? 0.03 : 0.5)!],
        stops: const [0, 0.35, 1],
      ),
      border: Border.all(color: p.clayRim),
    );
  }

  /// The paired shadow/highlight used by [box], for custom shapes.
  static List<BoxShadow> shadows(AppPalette p, {double depth = 1}) => [
        BoxShadow(color: p.clayShadow, blurRadius: 24 * depth, offset: Offset(6 * depth, 10 * depth)),
        BoxShadow(color: p.clayHighlight, blurRadius: 16 * depth, offset: Offset(-6 * depth, -6 * depth)),
      ];
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
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: p.textPrimary,
        displayColor: p.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: p.textPrimary,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: p.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.chipBg,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: p.clayRim),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: p.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
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
      // Clay back/close buttons in every app bar.
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) => _clayAppBarIcon(context, Icons.arrow_back_rounded),
        closeButtonIconBuilder: (context) => _clayAppBarIcon(context, Icons.close_rounded),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.surfaceElevated,
        contentTextStyle: GoogleFonts.poppins(color: p.textPrimary, fontWeight: FontWeight.w500, fontSize: 14),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: p.clayRim)),
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 10,
        activeTrackColor: p.primary,
        inactiveTrackColor: p.chipBg,
        thumbColor: Colors.white,
        overlayColor: p.primary.withValues(alpha: 0.12),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 13, elevation: 5, pressedElevation: 8),
        valueIndicatorColor: p.primary,
        showValueIndicator: ShowValueIndicator.onDrag,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.surfaceElevated,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        titleTextStyle: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        contentTextStyle: TextStyle(color: p.textSecondary, fontSize: 14),
      ),
    );
  }
}

/// Small raised clay square used as the app-bar back/close icon.
Widget _clayAppBarIcon(BuildContext context, IconData icon) {
  final p = AppPalette.of(context);
  return Container(
    width: 38,
    height: 38,
    decoration: Clay.box(p, color: p.surfaceElevated, radius: 14, depth: 0.45),
    alignment: Alignment.center,
    child: Icon(icon, size: 20, color: p.textPrimary),
  );
}
