import 'package:flutter/material.dart';
import 'app_text_theme.dart';
import 'app_theme_extension.dart';

/// Unified App Theme — Light & Dark Modes with Material 3 Design System.
///
/// Uses semantic color roles from [ColorScheme.fromSeed] derived directly
/// from the application's logo palette (`logo.png`).
class AppTheme {
  AppTheme._(); // Prevents instantiation — all members are static.

  // ─── Brand Seed Colors (Derived from logo.png) ─────────────────────
  static const Color _seedPrimary   = Color(0xFF0284C7); // Cyber Ocean Cyan
  static const Color _seedSecondary = Color(0xFFF59E0B); // Amber Gold Node Accent
  static const Color _seedTertiary  = Color(0xFF06B6D4); // Bright Cyan Glow

  // ─── Surface Overrides ───────────────────────────────────────────
  static const Color _lightBackground = Color(0xFFF8FAFC);
  static const Color _lightSurface    = Color(0xFFFFFFFF);
  static const Color _lightBorder     = Color(0xFFE2E8F0);

  static const Color _darkBackground  = Color(0xFF0B0F19);
  static const Color _darkSurface     = Color(0xFF111827);
  static const Color _darkBorder      = Color(0xFF1F2937);

  // ─── Light Theme ─────────────────────────────────────────────────
  static final ThemeData lightTheme = ThemeData(
    useMaterial3           : true,
    fontFamily             : 'Cairo',
    brightness             : Brightness.light,
    scaffoldBackgroundColor: _lightBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor  : _seedPrimary,
      brightness : Brightness.light,
      primary    : _seedPrimary,
      secondary  : _seedSecondary,
      tertiary   : _seedTertiary,
      surface    : _lightSurface,
    ),
    textTheme              : AppTextTheme.lightTextTheme,
    extensions             : const [AppThemeExtension.light],
    appBarTheme: AppBarTheme(
      centerTitle     : false,
      elevation       : 0,
      scrolledUnderElevation: 0,
      backgroundColor : _lightBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle  : AppTextTheme.lightTextTheme.titleLarge?.copyWith(
        color: const Color(0xFF0F172A),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
    ),
    cardTheme: CardThemeData(
      elevation  : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _lightBorder),
      ),
      color  : _lightSurface,
      margin : EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color    : _lightBorder,
      thickness: 1,
      space    : 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled       : true,
      fillColor    : const Color(0xFFF1F5F9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : const BorderSide(color: _lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : const BorderSide(color: _seedPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : const BorderSide(color: Color(0xFFEF4444), width: 1.5),
      ),
      labelStyle: AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: const Color(0xFF475569)),
      hintStyle : AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: const Color(0xFF94A3B8)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor : _seedPrimary,
        foregroundColor : Colors.white,
        elevation       : 2,
        shadowColor     : _seedPrimary.withValues(alpha: 0.35),
        minimumSize     : const Size.fromHeight(50),
        padding         : const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: AppTextTheme.lightTextTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    chipTheme: ChipThemeData(
      labelStyle : AppTextTheme.lightTextTheme.labelMedium,
      shape      : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding    : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior         : SnackBarBehavior.floating,
      shape            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor  : const Color(0xFF0F172A),
      contentTextStyle : AppTextTheme.lightTextTheme.bodyMedium?.copyWith(color: Colors.white),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor          : _seedPrimary,
      inactiveTrackColor        : _seedPrimary.withValues(alpha: 0.15),
      thumbColor                : _seedPrimary,
      overlayColor              : _seedPrimary.withValues(alpha: 0.12),
      valueIndicatorColor       : _seedPrimary,
      trackHeight               : 4,
      valueIndicatorTextStyle   : AppTextTheme.lightTextTheme.labelMedium?.copyWith(color: Colors.white),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
    ),
  );

  // ─── Dark Theme ──────────────────────────────────────────────────
  static final ThemeData darkTheme = ThemeData(
    useMaterial3           : true,
    fontFamily             : 'Cairo',
    brightness             : Brightness.dark,
    scaffoldBackgroundColor: _darkBackground,
    colorScheme: ColorScheme.fromSeed(
      seedColor  : _seedPrimary,
      brightness : Brightness.dark,
      primary    : const Color(0xFF38BDF8), // Electric Cyan Dark
      secondary  : _seedSecondary,
      tertiary   : _seedTertiary,
      surface    : _darkSurface,
    ),
    textTheme              : AppTextTheme.darkTextTheme,
    extensions             : const [AppThemeExtension.dark],
    appBarTheme: AppBarTheme(
      centerTitle     : false,
      elevation       : 0,
      scrolledUnderElevation: 0,
      backgroundColor : _darkBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle  : AppTextTheme.darkTextTheme.titleLarge?.copyWith(
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation  : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: _darkBorder),
      ),
      color  : _darkSurface,
      margin : EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color    : _darkBorder,
      thickness: 1,
      space    : 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled       : true,
      fillColor    : const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : const BorderSide(color: _darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : const BorderSide(color: Color(0xFF38BDF8), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide  : const BorderSide(color: Color(0xFFF87171), width: 1.5),
      ),
      labelStyle: AppTextTheme.darkTextTheme.bodyMedium?.copyWith(color: const Color(0xFF94A3B8)),
      hintStyle : AppTextTheme.darkTextTheme.bodyMedium?.copyWith(color: const Color(0xFF475569)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor : const Color(0xFF0284C7),
        foregroundColor : Colors.white,
        elevation       : 4,
        shadowColor     : const Color(0xFF0284C7).withValues(alpha: 0.4),
        minimumSize     : const Size.fromHeight(50),
        padding         : const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: AppTextTheme.darkTextTheme.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ),
    chipTheme: ChipThemeData(
      labelStyle : AppTextTheme.darkTextTheme.labelMedium,
      shape      : RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding    : const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior         : SnackBarBehavior.floating,
      shape            : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor  : const Color(0xFF1E293B),
      contentTextStyle : AppTextTheme.darkTextTheme.bodyMedium?.copyWith(color: Colors.white),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor          : const Color(0xFF38BDF8),
      inactiveTrackColor        : const Color(0xFF38BDF8).withValues(alpha: 0.2),
      thumbColor                : const Color(0xFF38BDF8),
      overlayColor              : const Color(0xFF38BDF8).withValues(alpha: 0.15),
      valueIndicatorColor       : const Color(0xFF38BDF8),
      trackHeight               : 4,
      valueIndicatorTextStyle   : AppTextTheme.darkTextTheme.labelMedium?.copyWith(color: Colors.white),
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
    ),
  );
}
