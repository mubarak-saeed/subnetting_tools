import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/widgets/bit_grid_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ip_address.dart';

class IpResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const IpResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Column(
      children: [
        BitGridWidget(
          binaryIp: ipAddress.binaryAddress,
          cidr: ipAddress.subnetMask,
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${tr.translate('ipCalculator')} (${ipAddress.address}/${ipAddress.subnetMask})',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      tooltip: tr.translate('copy'),
                      onPressed: () {
                        final data = '''
${tr.translate('ipCalculator')}: ${ipAddress.address}/${ipAddress.subnetMask}
${tr.translate('netmask')}: ${ipAddress.netmask}
${tr.translate('wildcardMask')}: ${ipAddress.wildcardMask}
${tr.translate('networkAddress')}: ${ipAddress.networkAddress}
${tr.translate('broadcastAddress')}: ${ipAddress.broadcastAddress}
${tr.translate('firstUsableIp')}: ${ipAddress.firstUsableIp}
${tr.translate('lastUsableIp')}: ${ipAddress.lastUsableIp}
${tr.translate('usableHosts')}: ${ipAddress.usableHosts}
${tr.translate('totalHosts')}: ${ipAddress.totalHosts}
${tr.translate('ipClass')}: ${ipAddress.networkClass}
${tr.translate('ipType')}: ${ipAddress.ipTypeDescription}
${tr.translate('binaryIp')}: ${ipAddress.binaryAddress}
''';
                        Clipboard.setData(ClipboardData(text: data));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(tr.translate('copiedToClipboard'))),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                _buildRow(context, tr.translate('netmask'), ipAddress.netmask),
                _buildRow(context, tr.translate('wildcardMask'), ipAddress.wildcardMask),
                _buildRow(context, tr.translate('networkAddress'), ipAddress.networkAddress),
                _buildRow(context, tr.translate('broadcastAddress'), ipAddress.broadcastAddress),
                _buildRow(context, tr.translate('firstUsableIp'), ipAddress.firstUsableIp),
                _buildRow(context, tr.translate('lastUsableIp'), ipAddress.lastUsableIp),
                _buildRow(context, tr.translate('usableHosts'), '${ipAddress.usableHosts}'),
                _buildRow(context, tr.translate('totalHosts'), '${ipAddress.totalHosts}'),
                _buildRow(context, tr.translate('ipClass'), ipAddress.networkClass),
                _buildRow(context, tr.translate('ipType'), ipAddress.ipTypeDescription),
                _buildRow(context, tr.translate('binaryIp'), ipAddress.binaryAddress),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
