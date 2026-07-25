import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/ip_address.dart';

class SubnetResultCard extends StatelessWidget {
  final IpAddress ipAddress;

  const SubnetResultCard({super.key, required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${tr.translate('subnet')} ${item.index}: ${item.cidrNotation}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${item.usableHosts} ${tr.translate('usableHosts')}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tr.translate('networkAddress')}: ${item.networkAddress} | ${tr.translate('broadcastAddress')}: ${item.broadcastAddress}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        '${tr.translate('firstUsableIp')}: ${item.firstUsableIp} - ${tr.translate('lastUsableIp')}: ${item.lastUsableIp}',
                        style: const TextStyle(fontSize: 12),
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
