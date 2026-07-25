import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/widgets/bit_grid_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class IpConverterPage extends StatefulWidget {
  const IpConverterPage({super.key});

  @override
  State<IpConverterPage> createState() => _IpConverterPageState();
}

class _IpConverterPageState extends State<IpConverterPage> {
  final _controller = TextEditingController(text: '192.168.1.1');
  String _binary = '';
  String _hex = '';
  String _decimal = '';
  String? _errorKey;
  String _mode = 'decimal';

  void _convert() {
    setState(() {
      _errorKey = null;
      final input = _controller.text.trim();
      try {
        if (_mode == 'decimal') {
          if (!IpNetworkEngine.isValidIp(input)) {
            _errorKey = 'invalidInput';
            return;
          }
          _decimal = input;
          _binary = IpNetworkEngine.toBinaryString(input);
          _hex = IpNetworkEngine.toHexString(input);
        } else if (_mode == 'binary') {
          _decimal = IpNetworkEngine.binaryToDecimalIp(input);
          _binary = IpNetworkEngine.toBinaryString(_decimal);
          _hex = IpNetworkEngine.toHexString(_decimal);
        } else if (_mode == 'hex') {
          _decimal = IpNetworkEngine.hexToDecimalIp(input);
          _binary = IpNetworkEngine.toBinaryString(_decimal);
          _hex = IpNetworkEngine.toHexString(_decimal);
        }

        HistoryStorage.addHistoryEntry(
          HistoryEntry(
            title: 'IP Conversion ($_mode)',
            details: 'Decimal: $_decimal\nBinary: $_binary\nHex: $_hex',
            featureType: 'IP Converter',
          ),
        );
      } catch (_) {
        _errorKey = 'invalidInput';
        _binary = '';
        _hex = '';
        _decimal = '';
      }
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
      appBar: AppBar(title: Text(tr.translate('ipConverter'))),
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
                    DropdownButtonFormField<String>(
                      value: _mode,
                      decoration: InputDecoration(
                        labelText: tr.translate('mode'),
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: 'decimal', child: Text(tr.translate('decimal'))),
                        DropdownMenuItem(value: 'binary', child: Text(tr.translate('binary'))),
                        DropdownMenuItem(value: 'hex', child: Text(tr.translate('hex'))),
                      ],
                      onChanged: (v) => setState(() => _mode = v!),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: '${tr.translate('enterIp')} (${tr.translate(_mode)})',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _controller.clear(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _convert,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.swap_horiz),
                      label: Text(tr.translate('convert')),
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
            if (_decimal.isNotEmpty && _errorKey == null) ...[
              BitGridWidget(binaryIp: _binary, cidr: 32),
              const SizedBox(height: 12),
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
                            tr.translate('ipConverter'),
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy),
                            tooltip: tr.translate('copy'),
                            onPressed: () {
                              final text = 'Decimal: $_decimal\nBinary: $_binary\nHex: $_hex';
                              Clipboard.setData(ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      _buildRow(context, tr.translate('decimal'), _decimal),
                      _buildRow(context, tr.translate('binaryIp'), _binary),
                      _buildRow(context, tr.translate('hexIp'), _hex),
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
