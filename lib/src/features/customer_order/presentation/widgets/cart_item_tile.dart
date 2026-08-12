import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/food_details_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_checkout_screen.dart';

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
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 360;
          final imageSize = isCompact ? 56.0 : 72.0;

          return CustomCard(
            padding: const EdgeInsets.all(12),
            onTap: () {
              final sanitized = {
                'id': item['id'] ?? '',
                'name': item['name'] ?? '',
                'description': item['description'] ?? '',
                'price': item['price'] ?? 0.0,
                'quantity': item['quantity'] ?? 1,
                'portion': item['portion'] ?? 'Single',
                'addons': item['addons'] ?? [],
                'image': item['image'] ?? '',
                'isSpicy': item['isSpicy'] ?? false,
              };

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FoodDetailsScreen(
                    dish: sanitized,
                    onBack: () => Navigator.of(context).pop(),
                    onAddToCart: (newItem) {
                      try {
                        context.read<CartBloc>().addItem(newItem);
                      } catch (_) {}
                      Navigator.of(context).pop();
                    },
                    onBuyNow: (newItem) {
                      try {
                        context.read<CartBloc>().addItem(newItem);
                      } catch (_) {}
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => CustomerCheckoutScreen(
                            onOrderPlaced: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: NetworkImageLoader(
                    imageUrl: item['image'] ?? '',
                    width: imageSize,
                    height: imageSize,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item['name'] ?? '',
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.25,
                        ),
                      ),
                      if (addons.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Addons: ${addons.join(", ")}',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withAlpha(
                              200,
                            ),
                          ),
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
                const SizedBox(width: 8),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    QuantityStepper(
                      count: item['quantity'] ?? 1,
                      onChanged: onQuantityChanged,
                      isCompact: isCompact,
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: isCompact ? 30 : 36,
                      child: OutlinedButton.icon(
                        onPressed: onDismissed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: theme.colorScheme.error.withAlpha(230),
                          ),
                          foregroundColor: theme.colorScheme.error,
                          backgroundColor: theme.colorScheme.error.withAlpha(
                            20,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: isCompact ? 8 : 10,
                            vertical: isCompact ? 4 : 6,
                          ),
                          minimumSize: const Size(0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          visualDensity: VisualDensity.compact,
                        ),
                        icon: Icon(
                          Icons.delete_outline,
                          size: isCompact ? 14 : 16,
                          color: theme.colorScheme.error,
                        ),
                        label: Text(
                          'Remove',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
