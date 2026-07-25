import 'package:flutter/material.dart';

/// Animated Page Transition Utilities.
///
/// Provides consistent, premium-feeling page transitions across the app.
/// Use [AppPageRoutes.fadeSlide] for most tool pages.
abstract class AppPageRoutes {
  /// Smooth fade + upward slide transition (default for all feature pages).
  static PageRouteBuilder<T> fadeSlide<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder   : (context, animation, secondaryAnimation) => page,
      transitionDuration   : const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeTween = CurveTween(curve: Curves.easeOut);
        final slideTween = Tween<Offset>(
          begin: const Offset(0, 0.04),
          end  : Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        return FadeTransition(
          opacity : animation.drive(fadeTween),
          child   : SlideTransition(
            position: animation.drive(slideTween),
            child   : child,
          ),
        );
      },
    );
  }

  /// Horizontal slide-in from right (for detail / drill-down pages).
  static PageRouteBuilder<T> slideRight<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder   : (context, animation, secondaryAnimation) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideTween = Tween<Offset>(
          begin: const Offset(1.0, 0),
          end  : Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));

        final fadeTween = CurveTween(curve: Curves.easeOut);

        return SlideTransition(
          position: animation.drive(slideTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child  : child,
          ),
        );
      },
    );
  }
}
