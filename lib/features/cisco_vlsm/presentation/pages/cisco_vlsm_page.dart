import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/cisco_network_engine.dart';
import '../../../../core/widgets/cidr_selector_chips.dart';
import '../../../../core/widgets/ip_input_field.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';
import '../widgets/vlsm_allocation_card.dart';

/// Page for configuring VLSM subnet allocations by host requirements.
class CiscoVlsmPage extends StatefulWidget {
  const CiscoVlsmPage({super.key});

  @override
  State<CiscoVlsmPage> createState() => _CiscoVlsmPageState();
}

class _CiscoVlsmPageState extends State<CiscoVlsmPage> {
  final _baseIpController = TextEditingController(text: '192.168.1.0');
  int _baseCidr = 24;

  final List<TextEditingController> _nameControllers = [
    TextEditingController(text: 'Sales / المبيعات'),
    TextEditingController(text: 'Engineering / الهندسة'),
    TextEditingController(text: 'HR / الموارد البشرية'),
    TextEditingController(text: 'Router Link / وصلة الروترات'),
  ];

  final List<TextEditingController> _hostControllers = [
    TextEditingController(text: '60'),
    TextEditingController(text: '28'),
    TextEditingController(text: '12'),
    TextEditingController(text: '2'),
  ];

  List<VlsmAllocation> _allocations = [];
  String? _errorKey;

  void _addRequirement() {
    setState(() {
      _nameControllers.add(TextEditingController(text: 'Dept ${_nameControllers.length + 1}'));
      _hostControllers.add(TextEditingController(text: '10'));
    });
  }

  void _removeRequirement(int index) {
    if (_nameControllers.length <= 1) return;
    setState(() {
      _nameControllers[index].dispose();
      _hostControllers[index].dispose();
      _nameControllers.removeAt(index);
      _hostControllers.removeAt(index);
    });
  }

  void _calculateVlsm() {
    setState(() {
      _errorKey = null;
      final baseIp = _baseIpController.text.trim();
      final reqs = <VlsmRequirement>[];

      for (int i = 0; i < _nameControllers.length; i++) {
        final name = _nameControllers[i].text.trim();
        final hosts = int.tryParse(_hostControllers[i].text.trim()) ?? 0;
        if (hosts > 0) {
          reqs.add(VlsmRequirement(
            name: name.isEmpty ? 'Dept ${i + 1}' : name,
            requiredHosts: hosts,
          ));
        }
      }

      if (reqs.isEmpty) {
        _errorKey = 'invalidInput';
        _allocations = [];
        return;
      }

      _allocations = CiscoNetworkEngine.calculateVlsm(
        baseIp: baseIp,
        baseCidr: _baseCidr,
        requirements: reqs,
      );

      if (_allocations.isNotEmpty) {
        HistoryStorage.addHistoryEntry(
          HistoryEntry(
            title: 'VLSM Subnetting ($baseIp/$_baseCidr)',
            details: 'Allocated ${_allocations.length} subnets.',
            featureType: 'VLSM Subnet Planner',
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _baseIpController.dispose();
    for (final c in _nameControllers) {
      c.dispose();
    }
    for (final c in _hostControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('ciscoVlsm'))),
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
                    IpInputField(
                      controller: _baseIpController,
                      labelText: tr.translate('startIp'),
                      hintText: '192.168.1.0',
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.translate('netmask')}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text('/$_baseCidr', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    CidrSelectorChips(
                      selectedCidr: _baseCidr,
                      onCidrSelected: (cidr) => setState(() => _baseCidr = cidr),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tr.translate('addRequirement'),
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Color(0xFF4F46E5)),
                          onPressed: _addRequirement,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _nameControllers.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  controller: _nameControllers[i],
                                  decoration: InputDecoration(
                                    labelText: tr.translate('deptName'),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _hostControllers[i],
                                  decoration: InputDecoration(
                                    labelText: tr.translate('hostsNeeded'),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              if (_nameControllers.length > 1)
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () => _removeRequirement(i),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _calculateVlsm,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.architecture),
                      label: Text(tr.translate('ciscoVlsm')),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_errorKey != null)
              Card(
                color: theme.colorScheme.error,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(tr.translate(_errorKey!), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            if (_allocations.isNotEmpty && _errorKey == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VLSM Subnets (${_allocations.length}):',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          final text = _allocations.map((a) => '''
[${a.name}]
Subnet: ${a.networkAddress}/${a.cidr}
Netmask: ${a.netmask}
Wildcard: ${a.wildcardMask}
Range: ${a.firstUsableIp} - ${a.lastUsableIp}
Broadcast: ${a.broadcastAddress}
Requested: ${a.requestedHosts} | Allocated: ${a.allocatedHosts} | Wasted: ${a.wastedHosts}
''').join('\n---\n');
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
                        icon: const Icon(Icons.copy, size: 14),
                        label: Text(tr.translate('copy'), style: const TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _allocations.length,
                    itemBuilder: (context, idx) {
                      return VlsmAllocationCard(item: _allocations[idx]);
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
