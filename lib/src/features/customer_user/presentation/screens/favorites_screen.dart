import 'package:flutter/material.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/services/favorites_service.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/dish_menu_item_tile.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/food_details_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/restaurant_details_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
            Text(
              'Products',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: favSvc.products,
              builder: (context, products, _) {
                if (products.isEmpty) {
                  return const Text('No favorite products yet.');
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
                                  context.read<CartBloc>().addItem(newItem);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${sanitized['name']} added to cart',
                                      ),
                                    ),
                                  );
                                },
                                onBuyNow: (newItem) {},
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${sanitized['name']} added to cart',
                              ),
                            ),
                          );
                        },
                        onSelectDish: () {},
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Restaurants',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: favSvc.restaurants,
              builder: (context, restos, _) {
                if (restos.isEmpty) {
                  return const Text('No favorite restaurants yet.');
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
                                onSelectDish: (dish) {
                                  final sanitized = {
                                    'id': dish['id'] ?? '',
                                    'name': dish['name'] ?? '',
                                    'description': dish['description'] ?? '',
                                    'price': dish['price'] ?? 0.0,
                                    'image': dish['image'] ?? '',
                                    'isSpicy': dish['isSpicy'] ?? false,
                                  };
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FoodDetailsScreen(
                                        dish: sanitized,
                                        onBack: () =>
                                            Navigator.of(context).pop(),
                                        onAddToCart: (newItem) {},
                                        onBuyNow: (newItem) {},
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                        child: CustomCard(
                          padding: EdgeInsets.zero,
                          child: SizedBox(
                            height: 90,
                            child: Row(
                              children: [
                                ImageLoader(
                                  imageUrl: r['image'] ?? '',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                  borderRadius: 12,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                      const SizedBox(height: 4),
                                      Text(
                                        r['location'] ?? '',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () async {
                                    await favSvc.toggleRestaurant(r);
                                  },
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
