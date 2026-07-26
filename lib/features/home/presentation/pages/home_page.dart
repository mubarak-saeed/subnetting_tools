import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/page_routes.dart';
import '../../../../core/widgets/cidr_lookup_page.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../cisco_cli/presentation/pages/cisco_cli_page.dart';
import '../../../cisco_vlsm/presentation/pages/cisco_vlsm_page.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../ip_calculator/data/repositories/ip_calculator_repository_impl.dart';
import '../../../ip_calculator/presentation/cubit/ip_calculator_cubit.dart';
import '../../../ip_calculator/presentation/pages/ip_calculator_page.dart';
import '../../../ip_classifier/presentation/pages/ip_classifier_page.dart';
import '../../../ip_converter/presentation/pages/ip_converter_page.dart';
import '../../../range_calculator/presentation/pages/range_calculator_page.dart';
import '../../../subnet_calculator/presentation/pages/subnet_calculator_page.dart';
import '../widgets/home_feature_card.dart';
import '../widgets/home_hero_banner.dart';

/// Main Dashboard Page — displays all IPv4 network tools in a responsive grid.
///
/// Uses [AppThemeExtension] for gradient tokens and [AppPageRoutes] for
/// smooth page transitions. Supports search filtering across all tools.
class HomePage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final VoidCallback? onToggleLocale;

  const HomePage({super.key, this.onToggleTheme, this.onToggleLocale});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  /// Navigates to a page using the smooth fadeSlide transition.
  void _navigate(Widget page) =>
      Navigator.push(context, AppPageRoutes.fadeSlide(page));

  @override
  Widget build(BuildContext context) {
    final tr  = AppLocalizations.of(context);
    final ext = Theme.of(context).extension<AppThemeExtension>()!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final allFeatures = _buildFeatureList(tr, ext);

    final filtered = _searchQuery.isEmpty
        ? allFeatures
        : allFeatures.where((f) {
            final q = _searchQuery.toLowerCase();
            return f.title.toLowerCase().contains(q) ||
                f.description.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      appBar: _buildAppBar(context, tr, theme, isDark),
      body: ResponsiveLayout(
        maxWidth: 1000.0,
        child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── Hero Banner ───────────────────────────────────────
          SliverToBoxAdapter(
            child: HomeHeroBanner(toolCount: allFeatures.length),
          ),
          // ─── Search Field ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical  : AppSpacing.sm,
              ),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText   : tr.translate('chooseFeature'),
                  prefixIcon : const Icon(Icons.search_rounded),
                  suffixIcon : _searchQuery.isNotEmpty
                      ? IconButton(
                          icon   : const Icon(Icons.clear_rounded),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                ),
              ),
            ),
          ),
          // ─── Section Label ─────────────────────────────────────
          if (_searchQuery.isEmpty)
            SliverToBoxAdapter(
              child: _SectionHeader(
                label: tr.translate('chooseFeature'),
                count: allFeatures.length,
              ),
            ),
          // ─── Feature Grid ──────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                mainAxisSpacing   : AppSpacing.md,
                crossAxisSpacing  : AppSpacing.md,
                childAspectRatio  : 0.95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final f = filtered[index];
                  return HomeFeatureCard(
                    title         : f.title,
                    description   : f.description,
                    icon          : f.icon,
                    gradientColors: f.gradient,
                    heroTag       : f.heroTag,
                    onTap         : f.onTap,
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl3),
          ),
        ],
      ),
    ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────
  AppBar _buildAppBar(
    BuildContext context,
    AppLocalizations tr,
    ThemeData theme,
    bool isDark,
  ) {
    return AppBar(
      title: Row(
        children: [
          Container(
            padding   : const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color        : Colors.transparent,
              borderRadius : BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Image.asset(
                'assets/icon/icon.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              tr.translate('appTitle'),
              style   : theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // CIDR Reference Table
        IconButton(
          icon   : const Icon(Icons.table_chart_outlined),
          tooltip: tr.translate('cidrReferenceTable'),
          onPressed: () => Navigator.push(
            context,
            AppPageRoutes.fadeSlide(const CidrLookupPage()),
          ),
        ),
        // Theme toggle
        IconButton(
          icon   : Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
          tooltip: tr.translate('themeMode'),
          onPressed: widget.onToggleTheme,
        ),
        // Locale toggle
        IconButton(
          icon   : const Icon(Icons.translate_rounded),
          tooltip: tr.translate('language'),
          onPressed: widget.onToggleLocale,
        ),
      ],
    );
  }

  // ─── Feature Definitions ───────────────────────────────────────────
  List<_FeatureItem> _buildFeatureList(
    AppLocalizations tr,
    AppThemeExtension ext,
  ) {
    return [
      _FeatureItem(
        title      : tr.translate('ciscoVlsm'),
        description: tr.translate('ciscoVlsmDesc'),
        icon       : Icons.architecture_rounded,
        gradient   : ext.gradientVlsm,
        heroTag    : 'hero-vlsm',
        onTap      : () => _navigate(const CiscoVlsmPage()),
      ),
      _FeatureItem(
        title      : tr.translate('ciscoCli'),
        description: tr.translate('ciscoCliDesc'),
        icon       : Icons.terminal_rounded,
        gradient   : ext.gradientCli,
        heroTag    : 'hero-cli',
        onTap      : () => _navigate(const CiscoCliPage()),
      ),
      _FeatureItem(
        title      : tr.translate('ipCalculator'),
        description: tr.translate('ipCalculatorDesc'),
        icon       : Icons.calculate_rounded,
        gradient   : ext.gradientIpCalc,
        heroTag    : 'hero-ip-calc',
        onTap      : () => _navigate(
          BlocProvider(
            create: (_) => IpCalculatorCubit(IpCalculatorRepositoryImpl()),
            child : const IpCalculatorPage(),
          ),
        ),
      ),
      _FeatureItem(
        title      : tr.translate('subnetCalculator'),
        description: tr.translate('subnetCalculatorDesc'),
        icon       : Icons.alt_route_rounded,
        gradient   : ext.gradientSubnet,
        heroTag    : 'hero-subnet',
        onTap      : () => _navigate(const SubnetCalculatorPage()),
      ),
      _FeatureItem(
        title      : tr.translate('ipConverter'),
        description: tr.translate('ipConverterDesc'),
        icon       : Icons.swap_horiz_rounded,
        gradient   : ext.gradientConverter,
        heroTag    : 'hero-converter',
        onTap      : () => _navigate(const IpConverterPage()),
      ),
      _FeatureItem(
        title      : tr.translate('ipClassifier'),
        description: tr.translate('ipClassifierDesc'),
        icon       : Icons.category_rounded,
        gradient   : ext.gradientClassifier,
        heroTag    : 'hero-classifier',
        onTap      : () => _navigate(const IpClassifierPage()),
      ),
      _FeatureItem(
        title      : tr.translate('rangeCalculator'),
        description: tr.translate('rangeCalculatorDesc'),
        icon       : Icons.linear_scale_rounded,
        gradient   : ext.gradientRange,
        heroTag    : 'hero-range',
        onTap      : () => _navigate(const RangeCalculatorPage()),
      ),
      _FeatureItem(
        title      : tr.translate('history'),
        description: tr.translate('historyDesc'),
        icon       : Icons.history_rounded,
        gradient   : ext.gradientHistory,
        heroTag    : 'hero-history',
        onTap      : () => _navigate(const HistoryPage()),
      ),
    ];
  }
}

// ─── Data Model ──────────────────────────────────────────────────────────────

class _FeatureItem {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final String heroTag;
  final VoidCallback onTap;

  const _FeatureItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.heroTag,
    required this.onTap,
  });
}

// ─── Section Header ──────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final int count;

  const _SectionHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                letterSpacing: 0.6,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical  : 2,
            ),
            decoration: BoxDecoration(
              color       : theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color     : theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
