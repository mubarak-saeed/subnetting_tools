import 'package:flutter/material.dart';

/// AppThemeExtension — Custom Design Tokens via Material 3 ThemeExtension.
///
/// Access in widgets via: `Theme.of(context).extension<AppThemeExtension>()!`
///
/// Contains feature gradient colors and semantic status badge colors
/// that aren't part of the standard M3 ColorScheme.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  // ─── Feature Card Gradients ──────────────────────────────────────
  final List<Color> gradientVlsm;
  final List<Color> gradientCli;
  final List<Color> gradientIpCalc;
  final List<Color> gradientSubnet;
  final List<Color> gradientConverter;
  final List<Color> gradientClassifier;
  final List<Color> gradientRange;
  final List<Color> gradientHistory;

  // ─── Status / Badge Colors ───────────────────────────────────────
  final Color statusSuccess;
  final Color statusWarning;
  final Color statusError;
  final Color statusInfo;

  // ─── Bit Visualization ───────────────────────────────────────────
  final Color networkBitColor;
  final Color hostBitColor;

  const AppThemeExtension({
    required this.gradientVlsm,
    required this.gradientCli,
    required this.gradientIpCalc,
    required this.gradientSubnet,
    required this.gradientConverter,
    required this.gradientClassifier,
    required this.gradientRange,
    required this.gradientHistory,
    required this.statusSuccess,
    required this.statusWarning,
    required this.statusError,
    required this.statusInfo,
    required this.networkBitColor,
    required this.hostBitColor,
  });

  // ─── Light Theme Tokens ──────────────────────────────────────────
  static const AppThemeExtension light = AppThemeExtension(
    gradientVlsm       : [Color(0xFF38BDF8), Color(0xFF0284C7)],
    gradientCli        : [Color(0xFF818CF8), Color(0xFF4F46E5)],
    gradientIpCalc     : [Color(0xFF34D399), Color(0xFF10B981)],
    gradientSubnet     : [Color(0xFFFBBF24), Color(0xFFF59E0B)],
    gradientConverter  : [Color(0xFFC084FC), Color(0xFF9333EA)],
    gradientClassifier : [Color(0xFFF472B6), Color(0xFFEC4899)],
    gradientRange      : [Color(0xFF67E8F9), Color(0xFF06B6D4)],
    gradientHistory    : [Color(0xFF94A3B8), Color(0xFF64748B)],
    statusSuccess      : Color(0xFF10B981),
    statusWarning      : Color(0xFFF59E0B),
    statusError        : Color(0xFFEF4444),
    statusInfo         : Color(0xFF3B82F6),
    networkBitColor    : Color(0xFF4F46E5),
    hostBitColor       : Color(0xFFF59E0B),
  );

  // ─── Dark Theme Tokens ───────────────────────────────────────────
  static const AppThemeExtension dark = AppThemeExtension(
    gradientVlsm       : [Color(0xFF38BDF8), Color(0xFF0369A1)],
    gradientCli        : [Color(0xFF818CF8), Color(0xFF3730A3)],
    gradientIpCalc     : [Color(0xFF34D399), Color(0xFF059669)],
    gradientSubnet     : [Color(0xFFFBBF24), Color(0xFFD97706)],
    gradientConverter  : [Color(0xFFC084FC), Color(0xFF7E22CE)],
    gradientClassifier : [Color(0xFFF472B6), Color(0xFFBE185D)],
    gradientRange      : [Color(0xFF67E8F9), Color(0xFF0891B2)],
    gradientHistory    : [Color(0xFF94A3B8), Color(0xFF475569)],
    statusSuccess      : Color(0xFF34D399),
    statusWarning      : Color(0xFFFBBF24),
    statusError        : Color(0xFFF87171),
    statusInfo         : Color(0xFF60A5FA),
    networkBitColor    : Color(0xFF818CF8),
    hostBitColor       : Color(0xFFFBBF24),
  );

  @override
  AppThemeExtension copyWith({
    List<Color>? gradientVlsm,
    List<Color>? gradientCli,
    List<Color>? gradientIpCalc,
    List<Color>? gradientSubnet,
    List<Color>? gradientConverter,
    List<Color>? gradientClassifier,
    List<Color>? gradientRange,
    List<Color>? gradientHistory,
    Color? statusSuccess,
    Color? statusWarning,
    Color? statusError,
    Color? statusInfo,
    Color? networkBitColor,
    Color? hostBitColor,
  }) {
    return AppThemeExtension(
      gradientVlsm       : gradientVlsm       ?? this.gradientVlsm,
      gradientCli        : gradientCli        ?? this.gradientCli,
      gradientIpCalc     : gradientIpCalc     ?? this.gradientIpCalc,
      gradientSubnet     : gradientSubnet     ?? this.gradientSubnet,
      gradientConverter  : gradientConverter  ?? this.gradientConverter,
      gradientClassifier : gradientClassifier ?? this.gradientClassifier,
      gradientRange      : gradientRange      ?? this.gradientRange,
      gradientHistory    : gradientHistory    ?? this.gradientHistory,
      statusSuccess      : statusSuccess      ?? this.statusSuccess,
      statusWarning      : statusWarning      ?? this.statusWarning,
      statusError        : statusError        ?? this.statusError,
      statusInfo         : statusInfo         ?? this.statusInfo,
      networkBitColor    : networkBitColor    ?? this.networkBitColor,
      hostBitColor       : hostBitColor       ?? this.hostBitColor,
    );
  }

  @override
  AppThemeExtension lerp(AppThemeExtension? other, double t) {
    if (other == null) return this;
    return AppThemeExtension(
      gradientVlsm       : [Color.lerp(gradientVlsm[0], other.gradientVlsm[0], t)!, Color.lerp(gradientVlsm[1], other.gradientVlsm[1], t)!],
      gradientCli        : [Color.lerp(gradientCli[0], other.gradientCli[0], t)!, Color.lerp(gradientCli[1], other.gradientCli[1], t)!],
      gradientIpCalc     : [Color.lerp(gradientIpCalc[0], other.gradientIpCalc[0], t)!, Color.lerp(gradientIpCalc[1], other.gradientIpCalc[1], t)!],
      gradientSubnet     : [Color.lerp(gradientSubnet[0], other.gradientSubnet[0], t)!, Color.lerp(gradientSubnet[1], other.gradientSubnet[1], t)!],
      gradientConverter  : [Color.lerp(gradientConverter[0], other.gradientConverter[0], t)!, Color.lerp(gradientConverter[1], other.gradientConverter[1], t)!],
      gradientClassifier : [Color.lerp(gradientClassifier[0], other.gradientClassifier[0], t)!, Color.lerp(gradientClassifier[1], other.gradientClassifier[1], t)!],
      gradientRange      : [Color.lerp(gradientRange[0], other.gradientRange[0], t)!, Color.lerp(gradientRange[1], other.gradientRange[1], t)!],
      gradientHistory    : [Color.lerp(gradientHistory[0], other.gradientHistory[0], t)!, Color.lerp(gradientHistory[1], other.gradientHistory[1], t)!],
      statusSuccess      : Color.lerp(statusSuccess, other.statusSuccess, t)!,
      statusWarning      : Color.lerp(statusWarning, other.statusWarning, t)!,
      statusError        : Color.lerp(statusError, other.statusError, t)!,
      statusInfo         : Color.lerp(statusInfo, other.statusInfo, t)!,
      networkBitColor    : Color.lerp(networkBitColor, other.networkBitColor, t)!,
      hostBitColor       : Color.lerp(hostBitColor, other.hostBitColor, t)!,
    );
  }
}
