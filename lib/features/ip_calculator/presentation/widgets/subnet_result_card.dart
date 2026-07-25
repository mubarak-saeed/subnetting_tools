import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ip_address.dart';

class SubnetResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const SubnetResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (ipAddress.subnets.isEmpty) return const SizedBox();

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr.translate('subnets'),
              style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ipAddress.subnets.length,
              itemBuilder: (context, index) {
                final item = ipAddress.subnets[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${tr.translate('subnet')} ${item.index}: ${item.cidrNotation}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${item.usableHosts} ${tr.translate('usableHosts')}',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${tr.translate('networkAddress')}: ${item.networkAddress} | ${tr.translate('broadcastAddress')}: ${item.broadcastAddress}',
                        style: const TextStyle(fontSize: 11),
                      ),
                      Text(
                        '${tr.translate('firstUsableIp')}: ${item.firstUsableIp} - ${tr.translate('lastUsableIp')}: ${item.lastUsableIp}',
                        style: TextStyle(fontSize: 11, color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
