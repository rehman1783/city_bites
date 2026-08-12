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

    final addresses = [
      {
        'value': 'Scheme 3, College Road, Sahiwal',
        'title': 'Home (Default)',
        'subtitle': 'House #42, Scheme 3, College Road, Sahiwal',
        'icon': Icons.home_outlined,
      },
      {
        'value': 'High Street Market, Sahiwal',
        'title': 'Office',
        'subtitle': 'Plaza 3, High Street Market, Sahiwal',
        'icon': Icons.work_outline,
      },
    ];

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
            children: addresses.asMap().entries.map((entry) {
              final idx = entry.key;
              final addr = entry.value;
              final isSelected = selectedAddress == addr['value'];

              return Column(
                children: [
                  if (idx > 0) const Divider(height: 1),
                  InkWell(
                    onTap: () => onAddressSelected(addr['value'] as String),
                    borderRadius: BorderRadius.vertical(
                      top: idx == 0 ? const Radius.circular(16) : Radius.zero,
                      bottom: idx == addresses.length - 1 ? const Radius.circular(16) : Radius.zero,
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
                                  addr['title'] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  addr['subtitle'] as String,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            addr['icon'] as IconData,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
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
