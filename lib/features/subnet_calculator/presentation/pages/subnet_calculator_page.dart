import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/network/ip_network_engine.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/cidr_selector_chips.dart';
import '../../../../core/widgets/ip_input_field.dart';
import '../../../../core/widgets/quick_preset_chips.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../history/logic/history_storage.dart';

class SubnetCalculatorPage extends StatefulWidget {
  const SubnetCalculatorPage({super.key});

  @override
  State<SubnetCalculatorPage> createState() => _SubnetCalculatorPageState();
}

class _SubnetCalculatorPageState extends State<SubnetCalculatorPage> {
  final _ipController = TextEditingController(text: '176.123.31.150');
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
    final tr    = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr.translate('subnetCalculator'))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Controls Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IpInputField(
                      controller: _ipController,
                      labelText: tr.translate('enterIp'),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    QuickPresetChips(
                      onSelected: (ip) {
                        setState(() {
                          _ipController.text = ip;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.translate('netmask')}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text('/$_subnetMask', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Slider(
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
                    CidrSelectorChips(
                      selectedCidr: _subnetMask,
                      onCidrSelected: (cidr) {
                        setState(() => _subnetMask = cidr);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${tr.translate('numberOfSubnets')}:', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                          ),
                          child: Text('$_numberOfSubnets', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Slider(
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
                    const SizedBox(height: AppSpacing.md),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.hub_rounded),
                      label: Text(tr.translate('calculateSubnets')),
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
            if (_subnets.isNotEmpty && _errorKey == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${tr.translate('subnets')} (${_subnets.length}):',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      ElevatedButton.icon(
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
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _subnets.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final subnet   = _subnets[index];
                      final isActive = subnet.isCurrentActive;

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          side: BorderSide(
                            color: isActive ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                            width: isActive ? 2.0 : 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isActive ? theme.colorScheme.primary : theme.colorScheme.primary.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${subnet.index}',
                                      style: TextStyle(
                                          color: isActive ? Colors.white : theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      subnet.cidrNotation,
                                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isActive) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                      ),
                                      child: Text(
                                        tr.translate('activeIp'),
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
                                      ),
                                    ),
                                  ],
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                                    ),
                                    child: Text(
                                      '${subnet.usableHosts}h',
                                      style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.copy_rounded, size: 16),
                                    onPressed: () {
                                      final text = 'Subnet ${subnet.index}: ${subnet.cidrNotation}\nNet: ${subnet.networkAddress}\nBroad: ${subnet.broadcastAddress}\nRange: ${subnet.firstUsableIp} - ${subnet.lastUsableIp}';
                                      Clipboard.setData(ClipboardData(text: text));
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                                child: Divider(height: 1),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${tr.translate("networkAddress")}: ${subnet.networkAddress}',
                                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      '${tr.translate("broadcastAddress")}: ${subnet.broadcastAddress}',
                                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${tr.translate("usableRange")}: ${subnet.firstUsableIp} - ${subnet.lastUsableIp}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                                ),
                              ),
                            ],
                          ),
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
