import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class CheckoutPaymentCard extends StatelessWidget {
  final String selectedPaymentMethod;
  final ValueChanged<String> onPaymentMethodSelected;

  const CheckoutPaymentCard({
    super.key,
    required this.selectedPaymentMethod,
    required this.onPaymentMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final methods = [
      {
        'value': 'COD',
        'title': 'Cash on Delivery (COD)',
        'subtitle': 'Pay with cash upon delivery',
        'icon': Icons.payments_outlined,
        'color': Colors.green,
      },
      {
        'value': 'JazzCash',
        'title': 'JazzCash / EasyPaisa',
        'subtitle': 'Instant digital mobile wallet payment',
        'icon': Icons.account_balance_wallet_outlined,
        'color': Colors.orange,
      },
      {
        'value': 'Card',
        'title': 'Credit / Debit Card',
        'subtitle': 'Visa / MasterCard support',
        'icon': Icons.credit_card_outlined,
        'color': Colors.blue,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        CustomCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: methods.asMap().entries.map((entry) {
              final idx = entry.key;
              final pm = entry.value;
              final isSelected = selectedPaymentMethod == pm['value'];

              return Column(
                children: [
                  if (idx > 0) const Divider(height: 1),
                  InkWell(
                    onTap: () => onPaymentMethodSelected(pm['value'] as String),
                    borderRadius: BorderRadius.vertical(
                      top: idx == 0 ? const Radius.circular(16) : Radius.zero,
                      bottom: idx == methods.length - 1 ? const Radius.circular(16) : Radius.zero,
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
                                  pm['title'] as String,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  pm['subtitle'] as String,
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            pm['icon'] as IconData,
                            size: 22,
                            color: pm['color'] as Color,
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
