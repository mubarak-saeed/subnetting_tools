import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class BitGridWidget extends StatelessWidget {
  final String binaryIp;
  final int cidr;

  const BitGridWidget({
    super.key,
    required this.binaryIp,
    required this.cidr,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final octets = binaryIp.split('.');
    int currentBitIndex = 0;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tr.translate('bitVisualization'),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '/$cidr',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildLegendItem(
                  context,
                  color: Colors.blue.shade600,
                  label: '${tr.translate('networkBits')} ($cidr)',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  context,
                  color: Colors.amber.shade700,
                  label: '${tr.translate('hostBits')} (${32 - cidr})',
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(octets.length, (octetIdx) {
                  final octetStr = octets[octetIdx];
                  final bitBoxes = <Widget>[];

                  for (int bitIdx = 0; bitIdx < octetStr.length; bitIdx++) {
                    final bitChar = octetStr[bitIdx];
                    final isNetworkBit = currentBitIndex < cidr;
                    currentBitIndex++;

                    bitBoxes.add(
                      Container(
                        width: 22,
                        height: 28,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          color: isNetworkBit
                              ? Colors.blue.shade600
                              : Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          bitChar,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: [
                      ...bitBoxes,
                      if (octetIdx < octets.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            '.',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context,
      {required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
