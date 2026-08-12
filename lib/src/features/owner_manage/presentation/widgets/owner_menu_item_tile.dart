import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';

class OwnerMenuItemTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final ValueChanged<bool> onToggleAvailability;
  final VoidCallback onDelete;

  const OwnerMenuItemTile({
    super.key,
    required this.item,
    required this.onToggleAvailability,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = item['isAvailable'] as bool? ?? true;

    return CustomCard(
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
                const SizedBox(height: 2),
                Text(
                  'Category: ${item['category'] ?? "General"}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  'PKR ${item['price'] != null ? item['price'].toInt() : 0}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: isAvailable,
                activeThumbColor: Colors.green,
                onChanged: onToggleAvailability,
              ),
              Text(
                isAvailable ? 'In Stock' : 'Out of Stock',
                style: TextStyle(
                  fontSize: 10,
                  color: isAvailable ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (action) {
              if (action == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Text('Edit Dish'),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete Item',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
