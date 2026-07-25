import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/cisco_network_engine.dart';
import '../../../../core/widgets/cidr_selector_chips.dart';
import '../../../../core/widgets/ip_input_field.dart';
import '../../../../l10n/app_localizations.dart';

class CiscoCliPage extends StatefulWidget {
  const CiscoCliPage({super.key});

  @override
  State<CiscoCliPage> createState() => _CiscoCliPageState();
}

class _CiscoCliPageState extends State<CiscoCliPage> {
  final _ipController = TextEditingController(text: '192.168.1.0');
  int _cidr = 24;

  final _summaryInputController = TextEditingController(text: '172.16.0.0/24\n172.16.1.0/24\n172.16.2.0/24\n172.16.3.0/24');
  String? _summaryResult;

  void _calculateSummary() {
    setState(() {
      final lines = _summaryInputController.text
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      _summaryResult = CiscoNetworkEngine.calculateSummaryRoute(lines);
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _summaryInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final cli = CiscoNetworkEngine.generateCiscoCliConfig(
      ip: _ipController.text.trim(),
      cidr: _cidr,
    );

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('ciscoCli'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section 1: Wildcard & CLI Command Generator
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.terminal, color: Color(0xFF4F46E5)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cisco IOS Command Generator',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    IpInputField(
                      controller: _ipController,
                      labelText: tr.translate('enterIp'),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.translate('netmask')}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Wildcard: ${cli['wildcard']}',
                              style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    CidrSelectorChips(
                      selectedCidr: _cidr,
                      onCidrSelected: (c) => setState(() => _cidr = c),
                    ),
                    const SizedBox(height: 16),
                    _buildCliBox(context, tr.translate('ospfConfig'), cli['ospf']!),
                    const SizedBox(height: 8),
                    _buildCliBox(context, tr.translate('eigrpConfig'), cli['eigrp']!),
                    const SizedBox(height: 8),
                    _buildCliBox(context, tr.translate('aclConfig'), cli['acl']!),
                    const SizedBox(height: 8),
                    _buildCliBox(context, tr.translate('interfaceConfig'), cli['interface']!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Section 2: Route Summarization (Aggregation)
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.compress, color: Color(0xFF06B6D4)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            tr.translate('routeSummarization'),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tr.translate('routeSummarizationDesc'),
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _summaryInputController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: '172.16.0.0/24\n172.16.1.0/24\n172.16.2.0/24\n172.16.3.0/24',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _calculateSummary,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.merge_type),
                      label: Text(tr.translate('routeSummarization')),
                    ),
                    if (_summaryResult != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF10B981)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Summary Route: $_summaryResult',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF10B981)),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18, color: Color(0xFF10B981)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: _summaryResult!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCliBox(BuildContext context, String title, String code) {
    final tr = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 14, color: Color(0xFF38BDF8)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: code));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                  );
                },
              ),
            ],
          ),
          SelectableText(
            code,
            style: const TextStyle(color: Color(0xFF38BDF8), fontFamily: 'monospace', fontSize: 12),
          ),
        ],
      ),
    );
  }
}
