import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/cisco_network_engine.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class Ipv6CalculatorPage extends StatefulWidget {
  const Ipv6CalculatorPage({super.key});

  @override
  State<Ipv6CalculatorPage> createState() => _Ipv6CalculatorPageState();
}

class _Ipv6CalculatorPageState extends State<Ipv6CalculatorPage> {
  final _ipController = TextEditingController(text: '2001:0db8:85a3:0000:0000:8a2e:0370:7334');
  int _prefixLength = 64;
  Ipv6Details? _details;

  void _calculate() {
    setState(() {
      final input = _ipController.text.trim();
      if (input.isEmpty) return;

      _details = CiscoNetworkEngine.calculateIpv6Details(input, _prefixLength);

      HistoryStorage.addHistoryEntry(
        HistoryEntry(
          title: 'IPv6 Subnet ($_prefixLength)',
          details: 'Compressed: ${_details!.compressedIp}\nExpanded: ${_details!.expandedIp}\nType: ${_details!.ipType}',
          featureType: 'IPv6 Calculator',
        ),
      );
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('ipv6Calculator'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _ipController,
                      decoration: const InputDecoration(
                        labelText: 'IPv6 Address',
                        hintText: '2001:db8::1',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Prefix Length:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('/$_prefixLength', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Slider(
                      value: _prefixLength.toDouble(),
                      min: 1,
                      max: 128,
                      divisions: 127,
                      label: '/$_prefixLength',
                      onChanged: (v) => setState(() => _prefixLength = v.toInt()),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.language),
                      label: Text(tr.translate('calculate')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_details != null) ...[
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
                          Expanded(
                            child: Text(
                              _details!.networkPrefix,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: tr.translate('copy'),
                            onPressed: () {
                              final text = '''
IPv6: ${_details!.compressedIp}/${_details!.prefixLength}
Expanded: ${_details!.expandedIp}
Scope: ${_details!.ipType}
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
                      _buildRow(context, 'Compressed IPv6', _details!.compressedIp),
                      _buildRow(context, 'Expanded (128-bit)', _details!.expandedIp),
                      _buildRow(context, 'Prefix Notation', _details!.networkPrefix),
                      _buildRow(context, 'Address Scope', _details!.ipType),
                    ],
                  ),
                ),
              ),
            ],
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: SelectableText(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
