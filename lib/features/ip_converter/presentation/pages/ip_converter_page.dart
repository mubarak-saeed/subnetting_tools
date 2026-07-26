import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/bit_grid_widget.dart';
import '../../../../core/widgets/ip_input_field.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class IpConverterPage extends StatefulWidget {
  const IpConverterPage({super.key});

  @override
  State<IpConverterPage> createState() => _IpConverterPageState();
}

class _IpConverterPageState extends State<IpConverterPage> {
  final _controller = TextEditingController(text: '192.168.1.1');
  String _binary   = '';
  String _hex      = '';
  String _decimal  = '';
  String? _errorKey;
  String _mode     = 'decimal';

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
          _binary  = IpNetworkEngine.toBinaryString(input);
          _hex     = IpNetworkEngine.toHexString(input);
        } else if (_mode == 'binary') {
          _decimal = IpNetworkEngine.binaryToDecimalIp(input);
          _binary  = IpNetworkEngine.toBinaryString(_decimal);
          _hex     = IpNetworkEngine.toHexString(_decimal);
        } else if (_mode == 'hex') {
          _decimal = IpNetworkEngine.hexToDecimalIp(input);
          _binary  = IpNetworkEngine.toBinaryString(_decimal);
          _hex     = IpNetworkEngine.toHexString(_decimal);
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
        _binary   = '';
        _hex      = '';
        _decimal  = '';
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
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('ipConverter'))),
      body: ResponsiveLayout(
        maxWidth: 1000.0,
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Mode Select & Input Form
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _mode,
                      decoration: InputDecoration(
                        labelText: tr.translate('mode'),
                      ),
                      items: [
                        DropdownMenuItem(value: 'decimal', child: Text(tr.translate('decimal'))),
                        DropdownMenuItem(value: 'binary', child: Text(tr.translate('binary'))),
                        DropdownMenuItem(value: 'hex', child: Text(tr.translate('hex'))),
                      ],
                      onChanged: (v) => setState(() => _mode = v!),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (_mode == 'decimal')
                      IpInputField(
                        controller: _controller,
                        labelText: '${tr.translate('enterIp')} (${tr.translate(_mode)})',
                      )
                    else
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: '${tr.translate('enterIp')} (${tr.translate(_mode)})',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () => _controller.clear(),
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: _convert,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.swap_horiz_rounded),
                      label: Text(tr.translate('convert')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_errorKey != null)
              Card(
                color: theme.colorScheme.error,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    tr.translate(_errorKey!),
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            if (_decimal.isNotEmpty && _errorKey == null) ...[
              // Bit Grid Visualization
              BitGridWidget(binaryIp: _binary, cidr: 32),
              const SizedBox(height: AppSpacing.md),

              // Conversion Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              tr.translate('ipConverter'),
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ElevatedButton.icon(
                            onPressed: () {
                              final text = 'Decimal: $_decimal\nBinary: $_binary\nHex: $_hex';
                              Clipboard.setData(ClipboardData(text: text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            icon: const Icon(Icons.copy_rounded, size: 14),
                            label: Text(tr.translate('copy'), style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Divider(height: 1),
                      ),
                      _buildConversionBox(context, tr.translate('decimal'), _decimal),
                      const SizedBox(height: AppSpacing.xs),
                      _buildConversionBox(context, tr.translate('binaryIp'), _formatBinaryWithDots(_binary)),
                      const SizedBox(height: AppSpacing.xs),
                      _buildConversionBox(context, tr.translate('hexIp'), _hex),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildConversionBox(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: SelectableText(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontFamily: 'monospace',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 16),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: value));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text('$value ${AppLocalizations.of(context).translate("copiedToClipboard")}'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatBinaryWithDots(String rawBinary) {
    final clean = rawBinary.replaceAll('.', '');
    if (clean.length != 32) return rawBinary;
    return '${clean.substring(0, 8)}.${clean.substring(8, 16)}.${clean.substring(16, 24)}.${clean.substring(24, 32)}';
  }
}
