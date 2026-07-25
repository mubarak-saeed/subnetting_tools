import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/presentation/pages/history_page.dart';
import '../../../ip_calculator/data/repositories/ip_calculator_repository_impl.dart';
import '../../../ip_calculator/presentation/cubit/ip_calculator_cubit.dart';
import '../../../ip_calculator/presentation/pages/ip_calculator_page.dart';
import '../../../ip_classifier/presentation/pages/ip_classifier_page.dart';
import '../../../ip_converter/presentation/pages/ip_converter_page.dart';
import '../../../range_calculator/presentation/pages/range_calculator_page.dart';
import '../../../subnet_calculator/presentation/pages/subnet_calculator_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final VoidCallback? onToggleLocale;

  const HomePage({super.key, this.onToggleTheme, this.onToggleLocale});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr.translate('appTitle'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: tr.translate('themeMode'),
            onPressed: onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: tr.translate('language'),
            onPressed: onToggleLocale,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lan,
              size: 54,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            tr.translate('chooseFeature'),
            style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth > 700
                    ? 3
                    : (constraints.maxWidth > 400 ? 2 : 1);
                return GridView.count(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  crossAxisCount: crossAxisCount,
                  mainAxisSpacing: 12.0,
                  crossAxisSpacing: 12.0,
                  childAspectRatio: constraints.maxWidth > 400 ? 1.4 : 2.2,
                  children: [
                    _buildFeatureCard(
                      context,
                      title: tr.translate('ipCalculator'),
                      description: tr.translate('ipCalculatorDesc'),
                      icon: Icons.calculate,
                      color: Colors.blue,
                      onTap: () {
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
                    ),
                    _buildFeatureCard(
                      context,
                      title: tr.translate('subnetCalculator'),
                      description: tr.translate('subnetCalculatorDesc'),
                      icon: Icons.alt_route,
                      color: Colors.teal,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SubnetCalculatorPage(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: tr.translate('ipConverter'),
                      description: tr.translate('ipConverterDesc'),
                      icon: Icons.swap_horiz,
                      color: Colors.orange,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IpConverterPage(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: tr.translate('ipClassifier'),
                      description: tr.translate('ipClassifierDesc'),
                      icon: Icons.category,
                      color: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IpClassifierPage(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: tr.translate('rangeCalculator'),
                      description: tr.translate('rangeCalculatorDesc'),
                      icon: Icons.linear_scale,
                      color: Colors.indigo,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RangeCalculatorPage(),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      title: tr.translate('history'),
                      description: tr.translate('historyDesc'),
                      icon: Icons.history,
                      color: Colors.blueGrey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryPage(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.7),
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
