import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/bit_grid_widget.dart';
import '../../../../core/widgets/ip_input_field.dart';
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
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('ipClassifier'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input Form Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    IpInputField(
                      controller: _controller,
                      labelText: tr.translate('enterIp'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: _classify,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.category_rounded),
                      label: Text(tr.translate('classify')),
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
            if (_details != null && _errorKey == null) ...[
              // Bit Grid Map
              BitGridWidget(binaryIp: _details!.binaryIp, cidr: 24),
              const SizedBox(height: AppSpacing.md),

              // Classification Dashboard Card
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
                              _details!.ipAddress,
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          ElevatedButton.icon(
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
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [
                          _ClassificationBadge(
                            label: '${tr.translate("ipClass")}: ${_details!.ipClass}',
                            color: theme.colorScheme.primary,
                          ),
                          _ClassificationBadge(
                            label: _details!.isPrivate ? 'Private RFC 1918' : 'Public Internet',
                            color: _details!.isPrivate ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                        child: Divider(height: 1),
                      ),
                      _buildDetailRow(context, tr.translate('ipType'), _details!.ipTypeDescription),
                      const SizedBox(height: AppSpacing.xs),
                      _buildDetailRow(context, tr.translate('binaryIp'), _details!.binaryIp, isCode: true),
                      const SizedBox(height: AppSpacing.xs),
                      _buildDetailRow(context, 'Integer ID', IpNetworkEngine.ipToInt(_details!.ipAddress).toString(), isCode: true),
                      const SizedBox(height: AppSpacing.xs),
                      _buildDetailRow(context, 'Hexadecimal', IpNetworkEngine.toHexString(_details!.ipAddress), isCode: true),
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

  Widget _buildDetailRow(BuildContext context, String label, String value, {bool isCode = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 110,
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
                fontFamily: isCode ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClassificationBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _ClassificationBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
