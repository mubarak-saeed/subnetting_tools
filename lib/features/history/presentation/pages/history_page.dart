import 'package:flutter/material.dart';
import '../../logic/history_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _loading = true);
    _history = await HistoryStorage.getHistory();
    setState(() => _loading = false);
  }

  Future<void> _clearHistory() async {
    await HistoryStorage.clearHistory();
    await _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear History',
            onPressed: _history.isEmpty ? null : _clearHistory,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _history.isEmpty
              ? const Center(child: Text('No history yet.'))
              : ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (context, i) => ListTile(
                    leading: Text('${i + 1}'),
                    title: Text(_history[i]),
                  ),
                ),
    );
  }
}
