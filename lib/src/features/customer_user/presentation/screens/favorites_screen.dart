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

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selected = 0; // 0 = products, 1 = restaurants

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
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _selected == 0
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          color: _selected == 0
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = 1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurants',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: _selected == 1
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 3,
                          color: _selected == 1
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                                    context.read<CartBloc>().addItem(newItem);
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
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                            ),
                                            color: Colors.white,
                                            onPressed: () async {
                                              await favSvc.toggleRestaurant(r);
                                              setState(() {});
                                            },
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
