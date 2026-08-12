import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';

class OwnerOrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final String statusType;
  final Function(String orderId, String nextStatus) onUpdateStatus;

  const OwnerOrderCard({
    super.key,
    required this.order,
    required this.statusType,
    required this.onUpdateStatus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = order['items'] is List ? (order['items'] as List) : [];

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['id'] ?? '',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                order['time'] ?? '',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Customer: ${order['customer'] ?? ""} • ${order['address'] ?? ""}',
            style: theme.textTheme.bodyMedium,
          ),
          const Divider(height: 16),
          Text(
            'Ordered Items:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(item.toString(), style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      order['paymentStatus'] ?? 'Unpaid',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'PKR ${order['amount'] != null ? order['amount'].toInt() : 0}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.print_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Printing Thermal Receipt...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (statusType == 'Pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    text: 'Accept Order',
                    onPressed: () => onUpdateStatus(order['id'], 'Preparing'),
                  ),
                ),
              ],
            ),
          if (statusType == 'Preparing')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => onUpdateStatus(order['id'], 'Dispatched'),
                icon: const Icon(Icons.two_wheeler),
                label: const Text('Mark Ready / Dispatch Rider'),
              ),
            ),
        ],
      ),
    );
  }
}
