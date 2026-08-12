import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class CartBillSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final double discountAmount;
  final double totalPayable;

  const CartBillSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.discountAmount,
    required this.totalPayable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment & Bill Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildBillRow(
            theme,
            label: 'Item Subtotal',
            value: 'PKR ${subtotal.toInt()}',
          ),
          const SizedBox(height: 8),
          _buildBillRow(
            theme,
            label: 'Sahiwal Local Delivery Fee',
            value: 'PKR ${deliveryFee.toInt()}',
          ),
          const SizedBox(height: 8),
          _buildBillRow(
            theme,
            label: 'Platform Service Fee',
            value: 'PKR ${serviceFee.toInt()}',
          ),
          if (discountAmount > 0) ...[
            const SizedBox(height: 8),
            _buildBillRow(
              theme,
              label: 'Promo Discount',
              value: '- PKR ${discountAmount.toInt()}',
              isDiscount: true,
            ),
          ],
          const Divider(height: 24),
          _buildBillRow(
            theme,
            label: 'Total Payable',
            value: 'PKR ${totalPayable.toInt()}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(
    ThemeData theme, {
    required String label,
    required String value,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final style = isTotal
        ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : isDiscount
            ? theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              )
            : theme.textTheme.bodyMedium;

    final valStyle = isTotal
        ? theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
        : isDiscount
            ? theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              )
            : theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            label,
            style: style,
            softWrap: true,
          ),
        ),
        const SizedBox(width: 10),
        Text(value, style: valStyle),
      ],
    );
  }
}
