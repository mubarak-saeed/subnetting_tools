import 'package:flutter/material.dart';

class CidrSelectorChips extends StatelessWidget {
  final int selectedCidr;
  final ValueChanged<int> onCidrSelected;

  const CidrSelectorChips({
    super.key,
    required this.selectedCidr,
    required this.onCidrSelected,
  });

  static const List<int> commonCidrs = [8, 16, 24, 27, 28, 30, 32];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: commonCidrs.map((cidr) {
          final isSelected = selectedCidr == cidr;
          final primary = Theme.of(context).colorScheme.primary;
          return Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: ChoiceChip(
              label: Text('/$cidr',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
                  )),
              selected: isSelected,
              selectedColor: primary,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (_) => onCidrSelected(cidr),
            ),
          );
        }).toList(),
      ),
    );
  }
}
