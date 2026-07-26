import 'package:flutter/material.dart';

/// Responsive Container Wrapper for Mobile, Tablet, and Web/Desktop compatibility.
///
/// Limits max layout width to [maxWidth] (default: 960px) on large screens (Web/Desktop)
/// while remaining 100% responsive and full-width on mobile devices.
class ResponsiveLayout extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveLayout({
    super.key,
    required this.child,
    this.maxWidth = 960.0,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
