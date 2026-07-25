import 'package:flutter/material.dart';

/// Primitive Color Tokens — Derived directly from official app logo (`logo.png`).
///
/// Brand identity palette:
/// - Cyber Ocean Cyan (`#0284C7` / `#00B4D8`) — Primary brand color.
/// - Amber Gold (`#F59E0B` / `#FBBF24`) — Node links & calculator icon accent.
/// - Deep Slate Dark (`#0B0F19` / `#111827`) — Dark mode container.
abstract class AppColors {
  AppColors._(); // Not instantiable

  // ─── Brand Seeds (From Logo) ───────────────────────────────────
  static const Color primary   = Color(0xFF0284C7); // Cyber Ocean Cyan Blue
  static const Color secondary = Color(0xFFF59E0B); // Amber Gold Node Accent
  static const Color tertiary  = Color(0xFF00B4D8); // Bright Electric Cyan

  // ─── Light Surfaces ────────────────────────────────────────────
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface    = Color(0xFFFFFFFF);
  static const Color lightBorder     = Color(0xFFE2E8F0);

  // ─── Dark Surfaces (Matching Logo Dark Container) ──────────────
  static const Color darkBackground  = Color(0xFF0B0F19);
  static const Color darkSurface     = Color(0xFF111827);
  static const Color darkBorder      = Color(0xFF1F2937);

  // ─── Semantic Status ───────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);
  static const Color info    = Color(0xFF0284C7);
}
