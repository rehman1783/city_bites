import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../../core/widgets/quantity_stepper.dart';

class CartItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onDismissed;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final addons = item['addons'] is List ? (item['addons'] as List) : [];

    return Dismissible(
      key: Key(item['id'] ?? ''),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => onDismissed(),
      child: CustomCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: NetworkImageLoader(
                imageUrl: item['image'] ?? '',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (addons.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Addons: ${addons.join(", ")}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    'PKR ${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toInt()}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            QuantityStepper(
              count: item['quantity'] ?? 1,
              onChanged: onQuantityChanged,
            ),
          ],
        ),
      ),
    );
  }
}
