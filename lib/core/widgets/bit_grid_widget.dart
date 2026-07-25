import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class BitGridWidget extends StatefulWidget {
  final String binaryIp;
  final int cidr;

  const BitGridWidget({
    super.key,
    required this.binaryIp,
    required this.cidr,
  });

  @override
  State<BitGridWidget> createState() => _BitGridWidgetState();
}

class _BitGridWidgetState extends State<BitGridWidget> {
  int? _hoveredBitIndex;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final octets = widget.binaryIp.split('.');
    int currentBitIndex = 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.memory, size: 18, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tr.translate('bitVisualization'),
                          style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '/${widget.cidr}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  _buildLegendBadge(
                    context,
                    color: const Color(0xFF4F46E5),
                    label: '${tr.translate('networkBits')}: ${widget.cidr}',
                  ),
                  const SizedBox(width: 10),
                  _buildLegendBadge(
                    context,
                    color: const Color(0xFFF59E0B),
                    label: '${tr.translate('hostBits')}: ${32 - widget.cidr}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: List.generate(octets.length, (octetIdx) {
                  final octetStr = octets[octetIdx];
                  final bitBoxes = <Widget>[];

                  for (int bitIdx = 0; bitIdx < octetStr.length; bitIdx++) {
                    final bitChar = octetStr[bitIdx];
                    final bitPosition = currentBitIndex;
                    final isNetworkBit = bitPosition < widget.cidr;
                    final isHovered = _hoveredBitIndex == bitPosition;
                    currentBitIndex++;

                    final bitColor = isNetworkBit
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFFF59E0B);

                    bitBoxes.add(
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _hoveredBitIndex = bitPosition;
                          });
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                'Bit #${bitPosition + 1}: $bitChar (${isNetworkBit ? tr.translate('networkBits') : tr.translate('hostBits')})',
                              ),
                            ),
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 24,
                          height: 32,
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            color: isHovered ? bitColor.withValues(alpha: 0.8) : bitColor,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: isHovered
                                ? [
                                    BoxShadow(
                                      color: bitColor.withValues(alpha: 0.6),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : [],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            bitChar,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(children: bitBoxes),
                      ),
                      if (octetIdx < octets.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            '.',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
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

  Widget _buildLegendBadge(BuildContext context,
      {required Color color, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
