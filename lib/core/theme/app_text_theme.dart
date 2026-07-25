import 'package:flutter/material.dart';

/// App Typography System — Material 3 TypeScale
///
/// Defines explicit high-contrast text themes for Light and Dark modes.
abstract class AppTextTheme {
  static const String _fontFamily = 'Cairo';

  static const Color _lightPrimary   = Color(0xFF0F172A); // Slate 900
  static const Color _lightSecondary = Color(0xFF334155); // Slate 700
  static const Color _darkPrimary    = Color(0xFFF8FAFC); // Slate 50
  static const Color _darkSecondary  = Color(0xFFCBD5E1); // Slate 300

  static TextTheme _buildTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      // ─── Display ─────────────────────────────────────────────────
      displayLarge  : TextStyle(fontFamily: _fontFamily, fontSize: 57, fontWeight: FontWeight.w400, color: primaryColor, letterSpacing: -0.25, height: 1.12),
      displayMedium : TextStyle(fontFamily: _fontFamily, fontSize: 45, fontWeight: FontWeight.w400, color: primaryColor, height: 1.16),
      displaySmall  : TextStyle(fontFamily: _fontFamily, fontSize: 36, fontWeight: FontWeight.w400, color: primaryColor, height: 1.22),

      // ─── Headline ────────────────────────────────────────────────
      headlineLarge  : TextStyle(fontFamily: _fontFamily, fontSize: 32, fontWeight: FontWeight.w700, color: primaryColor, height: 1.25),
      headlineMedium : TextStyle(fontFamily: _fontFamily, fontSize: 28, fontWeight: FontWeight.w700, color: primaryColor, height: 1.29),
      headlineSmall  : TextStyle(fontFamily: _fontFamily, fontSize: 24, fontWeight: FontWeight.w700, color: primaryColor, height: 1.33),

      // ─── Title ───────────────────────────────────────────────────
      titleLarge  : TextStyle(fontFamily: _fontFamily, fontSize: 22, fontWeight: FontWeight.w700, color: primaryColor, height: 1.27),
      titleMedium : TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: 0.15, height: 1.50),
      titleSmall  : TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: 0.10, height: 1.43),

      // ─── Body ────────────────────────────────────────────────────
      bodyLarge  : TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w400, color: primaryColor, letterSpacing: 0.5, height: 1.50),
      bodyMedium : TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w400, color: primaryColor, letterSpacing: 0.25, height: 1.43),
      bodySmall  : TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w400, color: secondaryColor, letterSpacing: 0.4, height: 1.33),

      // ─── Label ───────────────────────────────────────────────────
      labelLarge  : TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w700, color: primaryColor, letterSpacing: 0.1, height: 1.43),
      labelMedium : TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: 0.5, height: 1.33),
      labelSmall  : TextStyle(fontFamily: _fontFamily, fontSize: 11, fontWeight: FontWeight.w500, color: secondaryColor, letterSpacing: 0.5, height: 1.45),
    );
  }

  static TextTheme get lightTextTheme => _buildTextTheme(_lightPrimary, _lightSecondary);
  static TextTheme get darkTextTheme  => _buildTextTheme(_darkPrimary, _darkSecondary);
}
