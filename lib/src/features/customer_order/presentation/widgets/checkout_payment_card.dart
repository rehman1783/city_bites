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
            children: [
              RadioListTile<String>(
                value: 'COD',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => onPaymentMethodSelected(val!),
                title: const Text('Cash on Delivery (COD)'),
                subtitle: const Text('Pay with cash upon delivery'),
                secondary:
                    const Icon(Icons.payments_outlined, color: Colors.green),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: 'JazzCash',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => onPaymentMethodSelected(val!),
                title: const Text('JazzCash / EasyPaisa'),
                subtitle: const Text('Instant digital mobile wallet payment'),
                secondary: const Icon(Icons.account_balance_wallet_outlined,
                    color: Colors.orange),
              ),
              const Divider(height: 1),
              RadioListTile<String>(
                value: 'Card',
                groupValue: selectedPaymentMethod,
                onChanged: (val) => onPaymentMethodSelected(val!),
                title: const Text('Credit / Debit Card'),
                subtitle: const Text('Visa / MasterCard support'),
                secondary:
                    const Icon(Icons.credit_card_outlined, color: Colors.blue),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
