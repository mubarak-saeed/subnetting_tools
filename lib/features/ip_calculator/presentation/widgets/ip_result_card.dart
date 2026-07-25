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
    final theme = Theme.of(context);

    return Column(
      children: [
        BitGridWidget(
          binaryIp: ipAddress.binaryAddress,
          cidr: ipAddress.subnetMask,
        ),
        const SizedBox(height: 14),
        // Stat Metric Badges Row
        Row(
          children: [
            Expanded(
              child: _buildMetricCard(
                context,
                title: tr.translate('usableHosts'),
                value: '${ipAddress.usableHosts}',
                icon: Icons.devices,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                title: tr.translate('ipClass'),
                value: 'Class ${ipAddress.networkClass}',
                icon: Icons.military_tech,
                color: const Color(0xFF6366F1),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildMetricCard(
                context,
                title: tr.translate('ipType'),
                value: ipAddress.isPrivate ? 'Private' : 'Public',
                icon: ipAddress.isPrivate ? Icons.lock : Icons.public,
                color: ipAddress.isPrivate ? const Color(0xFFF59E0B) : const Color(0xFF06B6D4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Main Network Details Card
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.hub, color: theme.colorScheme.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${ipAddress.address}/${ipAddress.subnetMask}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _copyAll(context, tr),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      icon: const Icon(Icons.copy, size: 16),
                      label: Text(tr.translate('copy'), style: const TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1),
                ),
                _buildCopyableRow(context, tr.translate('netmask'), ipAddress.netmask, Icons.grid_4x4),
                _buildCopyableRow(context, tr.translate('wildcardMask'), ipAddress.wildcardMask, Icons.blur_on),
                _buildCopyableRow(context, tr.translate('networkAddress'), ipAddress.networkAddress, Icons.dns),
                _buildCopyableRow(context, tr.translate('broadcastAddress'), ipAddress.broadcastAddress, Icons.podcasts),
                _buildCopyableRow(context, tr.translate('firstUsableIp'), ipAddress.firstUsableIp, Icons.play_arrow),
                _buildCopyableRow(context, tr.translate('lastUsableIp'), ipAddress.lastUsableIp, Icons.stop),
                _buildCopyableRow(context, tr.translate('totalHosts'), '${ipAddress.totalHosts}', Icons.format_list_numbered),
                _buildCopyableRow(context, tr.translate('binaryIp'), ipAddress.binaryAddress, Icons.code),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCopyableRow(BuildContext context, String label, String value, IconData icon) {
    final tr = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(seconds: 1),
            content: Text('$label: $value ${tr.translate('copiedToClipboard')}'),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7)),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.copy, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _copyAll(BuildContext context, AppLocalizations tr) {
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
  }
}
