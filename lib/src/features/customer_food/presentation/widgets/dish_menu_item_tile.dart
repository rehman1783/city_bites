import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';

class DishMenuItemTile extends StatelessWidget {
  final Map<String, dynamic> dish;
  final VoidCallback onSelectDish;

  const DishMenuItemTile({
    super.key,
    required this.dish,
    required this.onSelectDish,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCard(
      onTap: onSelectDish,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Left Side Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (dish['isSpicy'] == true) ...[
                      const Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        dish['name'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  dish['description'] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'PKR ${dish['price'] != null ? dish['price'].toInt() : 0}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Right Side Image with "+ ADD" Floating Overlay
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: NetworkImageLoader(
                    imageUrl: dish['image'] ?? '',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: ElevatedButton(
                    onPressed: onSelectDish,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      '+ ADD',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
