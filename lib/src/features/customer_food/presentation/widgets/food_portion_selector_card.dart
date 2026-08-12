import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class FoodPortionSelectorCard extends StatelessWidget {
  final String selectedPortion;
  final ValueChanged<String> onPortionSelected;

  const FoodPortionSelectorCard({
    super.key,
    required this.selectedPortion,
    required this.onPortionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final options = [
      {'value': 'Single', 'title': 'Single', 'subtitle': 'Standard portion', 'price': 'PKR 0'},
      {'value': 'Double', 'title': 'Double', 'subtitle': 'Extra portion', 'price': '+ PKR 150'},
      {'value': 'Family', 'title': 'Family Pack', 'subtitle': 'Large sharing size', 'price': '+ PKR 350'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Portion Size',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: options.asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              final isSelected = selectedPortion == opt['value'];

              return Column(
                children: [
                  if (idx > 0) const Divider(height: 1),
                  InkWell(
                    onTap: () => onPortionSelected(opt['value']!),
                    borderRadius: BorderRadius.vertical(
                      top: idx == 0 ? const Radius.circular(16) : Radius.zero,
                      bottom: idx == options.length - 1 ? const Radius.circular(16) : Radius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          Icon(
                            isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opt['title']!,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  opt['subtitle']!,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            opt['price']!,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
