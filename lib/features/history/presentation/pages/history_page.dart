import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/favorites_storage.dart';
import '../../logic/history_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<HistoryEntry> _history = [];
  List<HistoryEntry> _favorites = [];
  bool _loading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final history = await HistoryStorage.getHistoryEntries();
    final favorites = await FavoritesStorage.getFavorites();
    setState(() {
      _history = history;
      _favorites = favorites;
      _loading = false;
    });
  }

  Future<void> _clearHistory() async {
    await HistoryStorage.clearHistory();
    await _loadData();
  }

  Future<void> _deleteEntry(int index) async {
    await HistoryStorage.deleteHistoryEntryAt(index);
    await _loadData();
  }

  Future<void> _toggleFav(HistoryEntry entry) async {
    await FavoritesStorage.toggleFavorite(entry);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    final filteredHistory = _history.where((e) {
      final q = _searchQuery.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q) ||
          e.featureType.toLowerCase().contains(q);
    }).toList();

    final filteredFavorites = _favorites.where((e) {
      final q = _searchQuery.toLowerCase();
      return e.title.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q) ||
          e.featureType.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.translate('history')),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: tr.translate('clearHistory'),
            onPressed: _history.isEmpty ? null : _clearHistory,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: tr.translate('history'), icon: const Icon(Icons.history, size: 20)),
            const Tab(text: 'Favorites', icon: Icon(Icons.star, size: 20, color: Colors.amber)),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
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
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isFavTab ? Icons.star_border : Icons.history_toggle_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              isFavTab ? 'No starred calculations saved.' : tr.translate('noHistory'),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final item = list[i];
        final isFav = _favorites.any((f) => f.title == item.title && f.featureType == item.featureType);

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ExpansionTile(
            leading: Chip(
              label: Text(
                item.featureType,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _formatTime(item.timestamp),
              style: const TextStyle(fontSize: 11),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: isFav ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () => _toggleFav(item),
                ),
                if (!isFavTab)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _deleteEntry(i),
                  ),
              ],
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SelectableText(
                    item.details,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
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
