import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class CheckoutAddressCard extends StatelessWidget {
  final String selectedAddress;
  final ValueChanged<String> onAddressSelected;

  const CheckoutAddressCard({
    super.key,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Address (Sahiwal)',
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
                value: 'Scheme 3, College Road, Sahiwal',
                groupValue: selectedAddress,
                onChanged: (val) => onAddressSelected(val!),
                title: const Text('Home (Default)'),
                subtitle: const Text(
                    'House #42, Scheme 3, College Road, Sahiwal'),
                secondary: const Icon(Icons.home_outlined, size: 20),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: 'High Street Market, Sahiwal',
                groupValue: selectedAddress,
                onChanged: (val) => onAddressSelected(val!),
                title: const Text('Office'),
                subtitle: const Text(
                    'Plaza 3, High Street Market, Sahiwal'),
                secondary: const Icon(Icons.work_outline, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
