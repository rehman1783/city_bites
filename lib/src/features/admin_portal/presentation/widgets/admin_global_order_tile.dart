import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';

class AdminGlobalOrderTile extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onForceCancel;

  const AdminGlobalOrderTile({
    super.key,
    required this.order,
    required this.onForceCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = order['status']?.toString() ?? 'Pending';
    final isCancelled = status.contains('Cancelled');

    return CustomCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['id'] ?? '',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isCancelled
                      ? theme.colorScheme.error.withAlpha(40)
                      : theme.colorScheme.secondary.withAlpha(40),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isCancelled
                        ? theme.colorScheme.error
                        : theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Restaurant: ${order['restaurant'] ?? ""}',
            style: theme.textTheme.bodyMedium,
          ),
          Text(
            'Customer: ${order['customer'] ?? ""} • Date: ${order['date'] ?? ""}',
            style: theme.textTheme.bodySmall,
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Amount: PKR ${order['amount'] != null ? order['amount'].toInt() : 0}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (!isCancelled)
                OutlinedButton(
                  onPressed: onForceCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    side: BorderSide(color: theme.colorScheme.error),
                  ),
                  child: const Text('Force Cancel'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
