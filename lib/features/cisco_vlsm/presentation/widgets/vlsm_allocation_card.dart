import 'package:flutter/material.dart';
import '../../../../core/network/cisco_network_engine.dart';
import '../../../../l10n/app_localizations.dart';

/// Card component for presenting individual VLSM subnet allocation results.
class VlsmAllocationCard extends StatelessWidget {
  final VlsmAllocation item;

  const VlsmAllocationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final cli = CiscoNetworkEngine.generateCiscoCliConfig(
      ip: item.networkAddress,
      cidr: item.cidr,
    );

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${item.networkAddress}/${item.cidr}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            _buildVlsmRow(context, tr.translate('netmask'), item.netmask),
            _buildVlsmRow(context, tr.translate('wildcardMask'), item.wildcardMask),
            _buildVlsmRow(context, tr.translate('firstUsableIp'), item.firstUsableIp),
            _buildVlsmRow(context, tr.translate('lastUsableIp'), item.lastUsableIp),
            _buildVlsmRow(context, tr.translate('broadcastAddress'), item.broadcastAddress),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildBadge('${tr.translate('requestedHosts')}: ${item.requestedHosts}', Colors.blue),
                  const SizedBox(width: 6),
                  _buildBadge('${tr.translate('allocatedHosts')}: ${item.allocatedHosts}', Colors.green),
                  const SizedBox(width: 6),
                  _buildBadge('${tr.translate('wastedHosts')}: ${item.wastedHosts}', Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(tr.translate('copyCliCommands'), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              iconColor: theme.colorScheme.primary,
              tilePadding: EdgeInsets.zero,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        '! OSPF Command\n${cli['ospf']}\n\n! Interface Config\n${cli['interface']}\n\n! ACL Command\n${cli['acl']}',
                        style: const TextStyle(color: Color(0xFF38BDF8), fontFamily: 'monospace', fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVlsmRow(BuildContext context, String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(val, style: const TextStyle(fontSize: 12), textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
