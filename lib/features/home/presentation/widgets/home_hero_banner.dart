import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Hero Banner widget displayed at the top of the dashboard.
///
/// Shows app title, subtitle, tool count badge, and a decorative network icon.
/// Uses Hero animation tag 'hero-banner-icon' for shared element transitions.
class HomeHeroBanner extends StatelessWidget {
  final int toolCount;

  const HomeHeroBanner({super.key, this.toolCount = 8});

  @override
  Widget build(BuildContext context) {
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin : const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.tertiary,
          ],
          begin: Alignment.topLeft,
          end  : Alignment.bottomRight,
          stops: const [0.0, 1.0],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl2),
        boxShadow: [
          BoxShadow(
            color     : theme.colorScheme.primary.withValues(alpha: isDark ? 0.45 : 0.30),
            blurRadius: 24,
            offset    : const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circle
          Positioned(
            right : -20,
            top   : -20,
            child : Opacity(
              opacity: 0.08,
              child: Container(
                width : 140,
                height: 140,
                decoration: const BoxDecoration(
                  color : Colors.white,
                  shape : BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Opacity(
              opacity: 0.06,
              child: Container(
                width : 100,
                height: 100,
                decoration: const BoxDecoration(
                  color : Colors.white,
                  shape : BoxShape.circle,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Badge(
                      label: tr.translate('badgeToolkit'),
                      icon : Icons.lan_outlined,
                    ),
                    _Badge(
                      label: '$toolCount ${tr.translate("toolsCount")}',
                      icon : Icons.widgets_outlined,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Title
                Text(
                  tr.translate('appTitle'),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color     : Colors.white,
                    fontWeight: FontWeight.w800,
                    height    : 1.2,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Subtitle
                Text(
                  tr.translate('appSubtitle'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color  : Colors.white.withValues(alpha: 0.82),
                    height : 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal badge chip for the hero banner.
class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Badge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical  : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color       : Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border      : Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: const TextStyle(
              color     : Colors.white,
              fontSize  : 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
