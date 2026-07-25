import 'package:flutter/material.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/page_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../ip_calculator/data/repositories/ip_calculator_repository_impl.dart';
import '../../../ip_calculator/presentation/pages/ip_details_page.dart';
import '../../logic/favorites_storage.dart';
import '../../logic/history_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HistoryEntry> _history   = [];
  List<HistoryEntry> _favorites = [];
  bool _loading     = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final h = await HistoryStorage.getHistoryEntries();
    final f = await FavoritesStorage.getFavorites();
    if (mounted) {
      setState(() {
        _history   = h;
        _favorites = f;
        _loading   = false;
      });
    }
  }

  Future<void> _toggleFav(HistoryEntry entry) async {
    await FavoritesStorage.toggleFavorite(entry);
    _loadData();
  }

  Future<void> _deleteEntry(int index) async {
    await HistoryStorage.deleteHistoryEntryAt(index);
    _loadData();
  }

  Future<void> _clearHistory() async {
    await HistoryStorage.clearHistory();
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final filteredHistory = _history.where((e) {
      final q = _searchQuery.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.featureType.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q);
    }).toList();

    final filteredFavorites = _favorites.where((e) {
      final q = _searchQuery.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.featureType.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('historyAndFavorites')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: tr.translate('clearHistory'),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(tr.translate('clearHistory')),
                  content: Text(tr.translate('confirmClearHistory')),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(tr.translate('cancel')),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _clearHistory();
                      },
                      child: Text(
                        tr.translate('clear'),
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.history_rounded), text: tr.translate('history')),
            Tab(icon: const Icon(Icons.star_rounded), text: tr.translate('starredTab')),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: tr.translate('searchHint'),
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildList(filteredHistory, isFavTab: false, tr: tr),
                      _buildList(filteredFavorites, isFavTab: true, tr: tr),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<HistoryEntry> list, {required bool isFavTab, required AppLocalizations tr}) {
    final theme = Theme.of(context);

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFavTab ? Icons.star_border_rounded : Icons.history_toggle_off_rounded,
              size: 64,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              isFavTab ? 'No starred calculations saved.' : tr.translate('noHistory'),
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.55), fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (context, i) {
        final item  = list[i];
        final isFav = _favorites.any((f) => f.title == item.title && f.featureType == item.featureType);

        return Card(
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Text(
                item.featureType,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            title: Text(
              item.title,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            subtitle: Text(
              _formatTime(item.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.55)),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.star_rounded : Icons.star_border_rounded,
                    color: isFav ? Colors.amber : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  onPressed: () => _toggleFav(item),
                ),
                if (!isFavTab)
                  IconButton(
                    icon: Icon(Icons.delete_outline_rounded, size: 20, color: theme.colorScheme.error),
                    onPressed: () => _deleteEntry(i),
                  ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      child: SelectableText(
                        item.details,
                        style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: () {
                        final match = RegExp(r'(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(?:/(\d{1,2}))?').firstMatch(item.title);
                        final ip   = match?.group(1) ?? '192.168.1.1';
                        final cidr = int.tryParse(match?.group(2) ?? '') ?? 24;

                        if (IpNetworkEngine.isValidIp(ip)) {
                          final ipAddress = IpCalculatorRepositoryImpl().calculateAll(ip, cidr);
                          Navigator.push(
                            context,
                            AppPageRoutes.fadeSlide(IpDetailsPage(ipAddress: ipAddress)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.analytics_outlined, size: 16),
                      label: Text(tr.translate('viewFullDetails'), style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
