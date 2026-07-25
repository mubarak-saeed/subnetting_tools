/// Design Tokens — Spacing & Border Radius
///
/// Single source of truth for all spacing and corner radius values.
/// Always reference these constants instead of hardcoding values in widgets.
library app_spacing;

abstract class AppSpacing {
  // ─── Spacing Scale ────────────────────────────────────────────────
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 20.0;
  static const double xl2 = 24.0;
  static const double xl3 = 32.0;
  static const double xl4 = 40.0;
  static const double xl5 = 48.0;

  // ─── Border Radius Scale ─────────────────────────────────────────
  static const double radiusSm  = 8.0;
  static const double radiusMd  = 12.0;
  static const double radiusLg  = 16.0;
  static const double radiusXl  = 20.0;
  static const double radiusXl2 = 24.0;
  static const double radiusFull = 100.0;

  // ─── Icon Sizes ──────────────────────────────────────────────────
  static const double iconSm  = 16.0;
  static const double iconMd  = 20.0;
  static const double iconLg  = 24.0;
  static const double iconXl  = 32.0;

  // ─── Card / Section ──────────────────────────────────────────────
  static const double cardPadding     = 18.0;
  static const double pagePadding     = 16.0;
  static const double sectionGap      = 14.0;

  // ─── Button ──────────────────────────────────────────────────────
  static const double buttonHeight    = 52.0;
  static const double buttonRadiusLg  = 16.0;
}
