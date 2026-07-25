import 'package:flutter/material.dart';

class QuickPresetChips extends StatelessWidget {
  final ValueChanged<String> onSelected;

  const QuickPresetChips({super.key, required this.onSelected});

  static const List<String> presets = [
    '192.168.1.1',
    '10.0.0.1',
    '172.16.0.1',
    '8.8.8.8',
    '127.0.0.1',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: presets.map((ip) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ActionChip(
              label: Text(ip, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onPressed: () => onSelected(ip),
            ),
          );
        }).toList(),
      ),
    );
  }
}
