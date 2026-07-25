import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class HomePage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final VoidCallback? onToggleLocale;

  const HomePage({super.key, this.onToggleTheme, this.onToggleLocale});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final allFeatures = [
      {
        'id': 'ciscoVlsm',
        'title': tr.translate('ciscoVlsm'),
        'description': tr.translate('ciscoVlsmDesc'),
        'icon': Icons.architecture,
        'color': const Color(0xFF0284C7),
        'gradient': [const Color(0xFF38BDF8), const Color(0xFF0284C7)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CiscoVlsmPage(),
            ),
          );
        },
      },
      {
        'id': 'ciscoCli',
        'title': tr.translate('ciscoCli'),
        'description': tr.translate('ciscoCliDesc'),
        'icon': Icons.terminal,
        'color': const Color(0xFF4F46E5),
        'gradient': [const Color(0xFF6366F1), const Color(0xFF4F46E5)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CiscoCliPage(),
            ),
          );
        },
      },
      {
        'id': 'ipCalculator',
        'title': tr.translate('ipCalculator'),
        'description': tr.translate('ipCalculatorDesc'),
        'icon': Icons.calculate,
        'color': const Color(0xFF10B981),
        'gradient': [const Color(0xFF34D399), const Color(0xFF10B981)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => IpCalculatorCubit(
                  IpCalculatorRepositoryImpl(),
                ),
                child: const IpCalculatorPage(),
              ),
            ),
          );
        },
      },
      {
        'id': 'subnetCalculator',
        'title': tr.translate('subnetCalculator'),
        'description': tr.translate('subnetCalculatorDesc'),
        'icon': Icons.alt_route,
        'color': const Color(0xFFF59E0B),
        'gradient': [const Color(0xFFFBBF24), const Color(0xFFF59E0B)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SubnetCalculatorPage(),
            ),
          );
        },
      },
      {
        'id': 'ipConverter',
        'title': tr.translate('ipConverter'),
        'description': tr.translate('ipConverterDesc'),
        'icon': Icons.swap_horiz,
        'color': const Color(0xFF8B5CF6),
        'gradient': [const Color(0xFFA78BFA), const Color(0xFF8B5CF6)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IpConverterPage(),
            ),
          );
        },
      },
      {
        'id': 'ipClassifier',
        'title': tr.translate('ipClassifier'),
        'description': tr.translate('ipClassifierDesc'),
        'icon': Icons.category,
        'color': const Color(0xFFEC4899),
        'gradient': [const Color(0xFFF472B6), const Color(0xFFEC4899)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IpClassifierPage(),
            ),
          );
        },
      },
      {
        'id': 'rangeCalculator',
        'title': tr.translate('rangeCalculator'),
        'description': tr.translate('rangeCalculatorDesc'),
        'icon': Icons.linear_scale,
        'color': const Color(0xFF06B6D4),
        'gradient': [const Color(0xFF38BDF8), const Color(0xFF06B6D4)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RangeCalculatorPage(),
            ),
          );
        },
      },
      {
        'id': 'history',
        'title': tr.translate('history'),
        'description': tr.translate('historyDesc'),
        'icon': Icons.history,
        'color': const Color(0xFF64748B),
        'gradient': [const Color(0xFF94A3B8), const Color(0xFF64748B)],
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryPage(),
            ),
          );
        },
      },
    ];

    final filteredFeatures = allFeatures.where((f) {
      final q = _searchQuery.toLowerCase();
      final title = (f['title'] as String).toLowerCase();
      final desc = (f['description'] as String).toLowerCase();
      return title.contains(q) || desc.contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.lan, color: theme.colorScheme.primary, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                tr.translate('appTitle'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: tr.translate('themeMode'),
            onPressed: widget.onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: tr.translate('language'),
            onPressed: widget.onToggleLocale,
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Banner
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.tertiary,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Network Engineering & Student Toolkit',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Icon(Icons.workspace_premium, color: Colors.amberAccent, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr.translate('appTitle'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.translate('appSubtitle'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: tr.translate('chooseFeature'),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _searchQuery = ''),
                        )
                      : null,
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Grid of Feature Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final feature = filteredFeatures[index];
                  final List<Color> gradient = feature['gradient'] as List<Color>;

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: feature['onTap'] as VoidCallback,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: gradient),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: gradient.last.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                feature['icon'] as IconData,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feature['title'] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  feature['description'] as String,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                        fontSize: 11,
                                        color: theme.textTheme.bodySmall?.color
                                            ?.withValues(alpha: 0.7),
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredFeatures.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}
