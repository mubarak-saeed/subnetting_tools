import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryIndigo = Color(0xFF4F46E5);
  static const Color secondaryCyan = Color(0xFF06B6D4);
  static const Color accentViolet = Color(0xFF8B5CF6);

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);

  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primaryIndigo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryIndigo,
      brightness: Brightness.light,
      primary: primaryIndigo,
      secondary: secondaryCyan,
      tertiary: accentViolet,
      surface: lightSurface,
      surfaceContainerHighest: lightSurfaceVariant,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.light().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: lightBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF0F172A),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF0F172A)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      color: lightSurface,
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryIndigo, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: Color(0xFF475569), fontSize: 14),
      hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: primaryIndigo.withValues(alpha: 0.4),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryIndigo,
      inactiveTrackColor: primaryIndigo.withValues(alpha: 0.15),
      thumbColor: primaryIndigo,
      overlayColor: primaryIndigo.withValues(alpha: 0.15),
      valueIndicatorColor: primaryIndigo,
      valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryIndigo,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryIndigo,
      brightness: Brightness.dark,
      primary: const Color(0xFF6366F1),
      secondary: secondaryCyan,
      tertiary: accentViolet,
      surface: darkSurface,
      surfaceContainerHighest: darkSurfaceVariant,
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: darkBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
      color: darkSurface,
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceVariant.withValues(alpha: 0.6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
      hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: const Color(0xFF6366F1).withValues(alpha: 0.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.cairo(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF6366F1),
      inactiveTrackColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
      thumbColor: const Color(0xFF6366F1),
      overlayColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
      valueIndicatorColor: const Color(0xFF6366F1),
      valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}
