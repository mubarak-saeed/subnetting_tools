import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class SubnetCalculatorPage extends StatefulWidget {
  const SubnetCalculatorPage({super.key});

  @override
  State<SubnetCalculatorPage> createState() => _SubnetCalculatorPageState();
}

class _SubnetCalculatorPageState extends State<SubnetCalculatorPage> {
  final _ipController = TextEditingController(text: '192.168.1.0');
  int _subnetMask = 24;
  int _numberOfSubnets = 4;
  List<SubnetItem> _subnets = [];
  String? _errorKey;

  void _calculate() {
    setState(() {
      _errorKey = null;
      final ip = _ipController.text.trim();
      if (!IpNetworkEngine.isValidIp(ip)) {
        _errorKey = 'invalidInput';
        _subnets = [];
        return;
      }

      _subnets = IpNetworkEngine.calculateSubnets(
        baseIp: ip,
        baseCidr: _subnetMask,
        targetSubnetsCount: _numberOfSubnets,
      );

      if (_subnets.isEmpty) {
        _errorKey = 'invalidSubnetMask';
      } else {
        HistoryStorage.addHistoryEntry(
          HistoryEntry(
            title: '$ip/$_subnetMask (${_subnets.length} ${AppLocalizations.of(context).translate('subnets')})',
            details: 'Subdivided into ${_subnets.length} subnets starting at ${_subnets.first.cidrNotation}',
            featureType: 'Subnet Calculator',
          ),
        );
      }
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

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('subnetCalculator'))),
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
                      controller: _ipController,
                      decoration: InputDecoration(
                        labelText: tr.translate('enterIp'),
                        hintText: '192.168.1.0',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('${tr.translate('netmask')}: '),
                        Expanded(
                          child: Slider(
                            value: _subnetMask.toDouble(),
                            min: 0,
                            max: 30,
                            divisions: 30,
                            label: '/$_subnetMask',
                            onChanged: (value) {
                              setState(() {
                                _subnetMask = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('/$_subnetMask', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('${tr.translate('numberOfSubnets')}: '),
                        Expanded(
                          child: Slider(
                            value: _numberOfSubnets.toDouble(),
                            min: 2,
                            max: 64,
                            divisions: 62,
                            label: '$_numberOfSubnets',
                            onChanged: (value) {
                              setState(() {
                                _numberOfSubnets = value.toInt();
                              });
                            },
                          ),
                        ),
                        Text('$_numberOfSubnets', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                      ),
                      icon: const Icon(Icons.calculate),
                      label: Text(tr.translate('calculateSubnets')),
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
            if (_subnets.isNotEmpty && _errorKey == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tr.translate('subnets')} (${_subnets.length}):',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        tooltip: tr.translate('copy'),
                        onPressed: () {
                          final text = _subnets
                              .map((s) =>
                                  'Subnet ${s.index}: ${s.cidrNotation} (Net: ${s.networkAddress}, Broad: ${s.broadcastAddress}, Hosts: ${s.usableHosts})')
                              .join('\n');
                          Clipboard.setData(ClipboardData(text: text));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subnets.length,
                    itemBuilder: (context, index) {
                      final subnet = _subnets[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text('${tr.translate('subnet')} ${subnet.index}: ${subnet.cidrNotation}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              '${tr.translate('networkAddress')}: ${subnet.networkAddress}\n${tr.translate('broadcastAddress')}: ${subnet.broadcastAddress}\n${tr.translate('firstUsableIp')}: ${subnet.firstUsableIp}\n${tr.translate('lastUsableIp')}: ${subnet.lastUsableIp}\n${tr.translate('usableHosts')}: ${subnet.usableHosts}'),
                        ),
                      );
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
