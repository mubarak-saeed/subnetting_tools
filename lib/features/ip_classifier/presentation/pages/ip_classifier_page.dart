import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class IpClassifierPage extends StatefulWidget {
  const IpClassifierPage({super.key});

  @override
  State<IpClassifierPage> createState() => _IpClassifierPageState();
}

class _IpClassifierPageState extends State<IpClassifierPage> {
  final _controller = TextEditingController(text: '192.168.1.1');
  IpNetworkDetails? _details;
  String? _errorKey;

  void _classify() {
    setState(() {
      _errorKey = null;
      final input = _controller.text.trim();
      if (!IpNetworkEngine.isValidIp(input)) {
        _errorKey = 'invalidInput';
        _details = null;
        return;
      }

      _details = IpNetworkEngine.calculateDetails(input, 24);

      HistoryStorage.addHistoryEntry(
        HistoryEntry(
          title: 'IP Classification ($input)',
          details: 'Class: ${_details!.ipClass}\nType: ${_details!.ipTypeDescription}\nPrivate: ${_details!.isPrivate}',
          featureType: 'IP Classifier',
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('ipClassifier'))),
      body: SingleChildScrollView(
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
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: tr.translate('enterIp'),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _controller.clear(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _classify,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.category),
                      label: Text(tr.translate('classify')),
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
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (_details != null && _errorKey == null)
              Card(
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
                            _details!.ipAddress,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: tr.translate('copy'),
                            onPressed: () {
                              final text = '''
${tr.translate('ipClassifier')}: ${_details!.ipAddress}
${tr.translate('ipClass')}: ${_details!.ipClass}
${tr.translate('ipType')}: ${_details!.ipTypeDescription}
''';
                              Clipboard.setData(ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildRow(context, tr.translate('ipClass'), _details!.ipClass),
                      _buildRow(context, tr.translate('ipType'), _details!.ipTypeDescription),
                      _buildRow(context, tr.translate('binaryIp'), _details!.binaryIp),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
