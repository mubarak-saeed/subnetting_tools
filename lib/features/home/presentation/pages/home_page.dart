import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/l10n/app_localizations.dart';
import '/features/ip_calculator/data/repositories/ip_calculator_repository_impl.dart';
import '/features/ip_calculator/presentation/cubit/ip_calculator_cubit.dart';
import '/features/ip_calculator/presentation/pages/ip_calculator_page.dart';
import '/features/subnet_calculator/presentation/pages/subnet_calculator_page.dart';
import '/features/ip_converter/presentation/pages/ip_converter_page.dart';
import '/features/ip_classifier/presentation/pages/ip_classifier_page.dart';
import '/features/range_calculator/presentation/pages/range_calculator_page.dart';
import '/features/history/presentation/pages/history_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onToggleTheme;
  final VoidCallback? onToggleLocale;
  const HomePage({super.key, this.onToggleTheme, this.onToggleLocale});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onToggleLocale,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Center(
            child: SizedBox(
              height: 90,
              child: Icon(Icons.network_check,size: 60,)
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              tr.translate('chooseFeature'),
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return GridView.count(
                  padding: const EdgeInsets.all(16.0),
                  crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 1.6,
                  children: [
                    _buildFeatureCard(
                      context,
                      tr.translate('ipCalculator'),
                      Icons.calculate,
                      tr.translate('ipCalculator'),
                      () {
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
                      tr.translate('subnetCalculator'),
                      Icons.subdirectory_arrow_right,
                      tr.translate('subnetCalculator'),
                      () {
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
                      tr.translate('ipConverter'),
                      Icons.swap_horiz,
                      tr.translate('ipConverter'),
                      () {
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
                      tr.translate('ipClassifier'),
                      Icons.category,
                      tr.translate('ipClassifier'),
                      () {
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
                      tr.translate('rangeCalculator'),
                      Icons.linear_scale,
                      tr.translate('rangeCalculator'),
                      () {
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
                      tr.translate('history'),
                      Icons.history,
                      tr.translate('history'),
                      () {
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
    BuildContext context,
    String title,
    IconData icon,
    String description,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  description,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 11),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
