import 'package:flutter/material.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/services/favorites_service.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/dish_menu_item_tile.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/food_details_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/restaurant_details_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_checkout_screen.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:city_bites/src/core/widgets/snackbar_helper.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selected = 0; // 0 = products, 1 = restaurants

  Widget _buildSegmentItem({required String label, required int index}) {
    final theme = Theme.of(context);
    final isSelected = _selected == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selected = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(50.0),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favSvc = FavoritesService.instance;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Favorites'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Segmented control matching the auth screen's RoleToggleButton
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(50.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSegmentItem(label: 'Products', index: 0),
                  _buildSegmentItem(label: 'Restaurants', index: 1),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Content
            if (_selected == 0)
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: favSvc.products,
                builder: (context, products, _) {
                  if (products.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('No favorite products yet.'),
                    );
                  }
                  return Column(
                    children: products.map((p) {
                      final sanitized = {
                        'id': p['id'] ?? '',
                        'name': p['name'] ?? '',
                        'description': p['description'] ?? '',
                        'price': p['price'] ?? 0.0,
                        'image': p['image'] ?? '',
                        'isSpicy': p['isSpicy'] ?? false,
                      };
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DishMenuItemTile(
                          dish: sanitized,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => FoodDetailsScreen(
                                  dish: sanitized,
                                  onBack: () => Navigator.of(context).pop(),
                                  onAddToCart: (newItem) {
                                    try {
                                      context.read<CartBloc>().addItem(newItem);
                                    } catch (_) {}
                                    showAppSnackBar(
                                      context,
                                      '${newItem['name']} added to cart',
                                    );
                                  },
                                  onBuyNow: (newItem) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => CustomerCheckoutScreen(
                                          previewItems: [
                                            {
                                              'id': newItem['id'],
                                              'name': newItem['name'],
                                              'price': newItem['price'] ?? 0,
                                              'quantity':
                                                  newItem['quantity'] ?? 1,
                                              'image': newItem['image'] ?? '',
                                            },
                                          ],
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
                          onAdd: () {
                            context.read<CartBloc>().addItem({
                              'id': sanitized['id'],
                              'name': sanitized['name'],
                              'price': sanitized['price'],
                              'quantity': 1,
                              'portion': 'Single',
                              'addons': [],
                              'image': sanitized['image'],
                            });
                            showAppSnackBar(
                              context,
                              '${sanitized['name']} added to cart',
                            );
                          },
                          onSelectDish: () {},
                        ),
                      );
                    }).toList(),
                  );
                },
              )
            else
              ValueListenableBuilder<List<Map<String, dynamic>>>(
                valueListenable: favSvc.restaurants,
                builder: (context, restos, _) {
                  if (restos.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text('No favorite restaurants yet.'),
                    );
                  }
                  return Column(
                    children: restos.map((r) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RestaurantDetailsScreen(
                                  restaurant: r,
                                  onBack: () => Navigator.of(context).pop(),
                                  onSelectDish: (dish) {},
                                ),
                              ),
                            );
                          },
                          child: CustomCard(
                            padding: EdgeInsets.zero,
                            child: SizedBox(
                              height: 110,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            r['name'] ?? '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            r['location'] ?? '',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                '${r['rating'] ?? '-'}',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 110,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: ImageLoader(
                                            imageUrl: r['image'] ?? '',
                                            width: 100,
                                            height: 110,
                                            fit: BoxFit.cover,
                                            borderRadius: 12,
                                          ),
                                        ),
                                        Positioned(
                                          top: 6,
                                          right: 6,
                                          child:
                                              ValueListenableBuilder<
                                                List<Map<String, dynamic>>
                                              >(
                                                valueListenable:
                                                    FavoritesService
                                                        .instance
                                                        .restaurants,
                                                builder: (context, value, _) {
                                                  final isFav = value.any(
                                                    (e) =>
                                                        (e['id']?.toString() ??
                                                            '') ==
                                                        (r['id']?.toString() ??
                                                            ''),
                                                  );
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      final added =
                                                          await FavoritesService
                                                              .instance
                                                              .toggleRestaurant(
                                                                r,
                                                              );
                                                      setState(() {});
                                                      showAppSnackBar(
                                                        context,
                                                        added
                                                            ? '${r['name']} added to favorites'
                                                            : '${r['name']} removed from favorites',
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            6,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        isFav
                                                            ? Icons.favorite
                                                            : Icons
                                                                  .favorite_border,
                                                        color: isFav
                                                            ? Colors.red
                                                            : Colors.black54,
                                                        size: 18,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                        ),
                                        // Delivery time overlay
                                        Positioned(
                                          bottom: 6,
                                          left: 6,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withAlpha(
                                                190,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons
                                                      .access_time_filled_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                const SizedBox(width: 6),
                                                Text(
                                                  r['deliveryTime'] ??
                                                      r['delivery_time'] ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
