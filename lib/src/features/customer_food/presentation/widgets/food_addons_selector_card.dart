import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class FoodAddonsSelectorCard extends StatelessWidget {
  final Set<String> selectedAddons;
  final ValueChanged<String> onToggleAddon;

  const FoodAddonsSelectorCard({
    super.key,
    required this.selectedAddons,
    required this.onToggleAddon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Extra Add-ons',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              CheckboxListTile(
                title: const Text('Extra Cheese'),
                secondary: const Text('+ PKR 80'),
                value: selectedAddons.contains('Extra Cheese'),
                onChanged: (_) => onToggleAddon('Extra Cheese'),
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Mayo Dip'),
                secondary: const Text('+ PKR 40'),
                value: selectedAddons.contains('Mayo Dip'),
                onChanged: (_) => onToggleAddon('Mayo Dip'),
              ),
              const Divider(height: 1),
              CheckboxListTile(
                title: const Text('Cold Drink 345ml'),
                secondary: const Text('+ PKR 90'),
                value: selectedAddons.contains('Cold Drink 345ml'),
                onChanged: (_) => onToggleAddon('Cold Drink 345ml'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
