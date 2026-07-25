import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
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
  final _endController   = TextEditingController(text: '192.168.1.10');
  List<String> _range = [];
  String? _errorKey;

  void _calculate() {
    setState(() {
      _errorKey = null;
      final start = _startController.text.trim();
      final end   = _endController.text.trim();

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
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('rangeCalculator'))),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  children: [
                    IpInputField(
                      controller: _startController,
                      labelText: tr.translate('startIp'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    IpInputField(
                      controller: _endController,
                      labelText: tr.translate('endIp'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.linear_scale_rounded),
                      label: Text(tr.translate('calculateRange')),
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
            if (_range.isNotEmpty && _errorKey == null)
              Expanded(
                child: Card(
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
                                '${tr.translate("rangeCalculator")} (${_range.length})',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            ElevatedButton.icon(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _range.join('\n')));
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
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: _range.length,
                            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                            itemBuilder: (context, i) {
                              final ipStr = _range[i];
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${i + 1}',
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppSpacing.sm),
                                    Expanded(
                                      child: Text(
                                        ipStr,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'monospace',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.copy_rounded, size: 16),
                                      onPressed: () {
                                        Clipboard.setData(ClipboardData(text: ipStr));
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            duration: const Duration(seconds: 1),
                                            content: Text('$ipStr ${tr.translate("copiedToClipboard")}'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
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
