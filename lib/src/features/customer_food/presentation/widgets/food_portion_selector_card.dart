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
            children: [
              RadioListTile<String>(
                title: const Text('Single'),
                subtitle: const Text('Standard portion'),
                secondary: const Text('PKR 0'),
                value: 'Single',
                groupValue: selectedPortion,
                onChanged: (val) => onPortionSelected(val!),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text('Double'),
                subtitle: const Text('Extra portion'),
                secondary: const Text('+ PKR 150'),
                value: 'Double',
                groupValue: selectedPortion,
                onChanged: (val) => onPortionSelected(val!),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                title: const Text('Family Pack'),
                subtitle: const Text('Large sharing size'),
                secondary: const Text('+ PKR 350'),
                value: 'Family',
                groupValue: selectedPortion,
                onChanged: (val) => onPortionSelected(val!),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
