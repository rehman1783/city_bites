import 'package:flutter/material.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/services/favorites_service.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/dish_menu_item_tile.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/food_details_screen.dart';

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
            Text('Products', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: favSvc.products,
              builder: (context, products, _) {
                if (products.isEmpty) {
                  return const Text('No favorite products yet.');
                }
                return Column(
                  children: products.map((p) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: SizedBox(width: 56, height: 56, child: Image.network(p['image'] ?? '', fit: BoxFit.cover)),
                        title: Text(p['name'] ?? ''),
                        subtitle: Text('PKR ${p['price'] ?? 0}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await favSvc.toggleProduct(p);
                          },
                        ),
                        onTap: () {
                          final sanitized = {
                            'id': p['id'] ?? '',
                            'name': p['name'] ?? '',
                            'description': p['description'] ?? '',
                            'price': p['price'] ?? 0.0,
                            'image': p['image'] ?? '',
                            'isSpicy': p['isSpicy'] ?? false,
                          };
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => FoodDetailsScreen(
                              dish: sanitized,
                              onBack: () => Navigator.of(context).pop(),
                              onAddToCart: (newItem) {
                                Navigator.of(context).pop();
                              },
                              onBuyNow: (newItem) {
                                Navigator.of(context).pop();
                              },
                            ),
                          ));
                        },
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text('Restaurants', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                      child: ListTile(
                        leading: SizedBox(width: 56, height: 56, child: Image.network(r['image'] ?? '', fit: BoxFit.cover)),
                        title: Text(r['name'] ?? ''),
                        subtitle: Text(r['location'] ?? ''),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await favSvc.toggleRestaurant(r);
                          },
                        ),
                        onTap: () {
                          // For now, do nothing or navigate to restaurant details when available
                        },
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
