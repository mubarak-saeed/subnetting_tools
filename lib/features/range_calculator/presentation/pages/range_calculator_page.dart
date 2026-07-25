import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/widgets/ip_input_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class RangeCalculatorPage extends StatefulWidget {
  const RangeCalculatorPage({super.key});

  @override
  State<RangeCalculatorPage> createState() => _RangeCalculatorPageState();
}

class _RangeCalculatorPageState extends State<RangeCalculatorPage> {
  final _startController = TextEditingController(text: '192.168.1.1');
  final _endController = TextEditingController(text: '192.168.1.10');
  List<String> _range = [];
  String? _errorKey;

  void _calculate() {
    setState(() {
      _errorKey = null;
      final start = _startController.text.trim();
      final end = _endController.text.trim();

      if (!IpNetworkEngine.isValidIp(start) || !IpNetworkEngine.isValidIp(end)) {
        _errorKey = 'invalidInput';
        _range = [];
        return;
      }

      _range = IpNetworkEngine.calculateRange(start, end);

      if (_range.isEmpty) {
        _errorKey = 'invalidRange';
      } else {
        HistoryStorage.addHistoryEntry(
          HistoryEntry(
            title: 'IP Range ($start - $end)',
            details: '${_range.length} IP addresses generated',
            featureType: 'Range Calculator',
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('rangeCalculator'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    IpInputField(
                      controller: _startController,
                      labelText: tr.translate('startIp'),
                    ),
                    const SizedBox(height: 12),
                    IpInputField(
                      controller: _endController,
                      labelText: tr.translate('endIp'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.linear_scale),
                      label: Text(tr.translate('calculateRange')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorKey != null)
              Card(
                color: Theme.of(context).colorScheme.error,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    tr.translate(_errorKey!),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_range.isNotEmpty && _errorKey == null)
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${tr.translate('rangeCalculator')} (${_range.length}):',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              tooltip: tr.translate('copy'),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _range.join('\n')));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _range.length,
                            itemBuilder: (context, i) => ListTile(
                              dense: true,
                              leading: CircleAvatar(
                                radius: 12,
                                child: Text('${i + 1}', style: const TextStyle(fontSize: 10)),
                              ),
                              title: Text(_range[i]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
