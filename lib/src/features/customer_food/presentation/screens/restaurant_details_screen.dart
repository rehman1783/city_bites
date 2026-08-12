import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:city_bites/src/core/services/favorites_service.dart';
import 'package:city_bites/src/core/widgets/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../bloc/restaurant_detail_bloc.dart';
import '../widgets/restaurant_info_header.dart';
import '../widgets/dish_menu_item_tile.dart';
import '../widgets/home_category_selector.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  final VoidCallback onBack;
  final Function(Map<String, dynamic> dish) onSelectDish;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    required this.onBack,
    required this.onSelectDish,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailBloc>().loadRestaurant(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
        builder: (context, state) {
          if (state is RestaurantLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is RestaurantLoaded) {
            final rest = state.restaurant;

            return ResponsiveWrapper(
              maxWidth: 1000,
              padding: EdgeInsets.zero,
              child: CustomScrollView(
                slivers: [
                  // Expandable Hero Banner SliverAppBar
                  SliverAppBar(
                    expandedHeight: 220,
                    pinned: true,
                    leading: CircleAvatar(
                      backgroundColor: Colors.black.withAlpha(120),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: widget.onBack,
                      ),
                    ),
                    actions: [
                      ValueListenableBuilder<List<Map<String, dynamic>>>(
                        valueListenable: FavoritesService.instance.restaurants,
                        builder: (context, value, _) {
                          final isFav = value.any(
                            (e) =>
                                (e['id']?.toString() ?? '') ==
                                (widget.restaurant['id']?.toString() ?? ''),
                          );
                          return Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.black.withAlpha(120),
                                child: IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : Colors.white,
                                  ),
                                  onPressed: () async {
                                    final added = await FavoritesService
                                        .instance
                                        .toggleRestaurant(widget.restaurant);
                                    setState(() {});
                                    showAppSnackBar(
                                      context,
                                      added
                                          ? '${widget.restaurant['name']} added to favorites'
                                          : '${widget.restaurant['name']} removed from favorites',
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          );
                        },
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: NetworkImageLoader(
                        imageUrl: rest['image'],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Meta Overlay Header Card
                  SliverToBoxAdapter(
                    child: RestaurantInfoHeader(restaurant: rest),
                  ),

                  // Sticky Menu Category selector (reuse Explore's design)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Builder(
                        builder: (context) {
                          // Build a categories list from menu items, preserving display names
                          final items = state.fullMenuItems;
                          final seen = <String>{};
                          final cats = <Map<String, String>>[
                            {'id': 'All', 'name': 'All', 'icon': '🍽️'},
                          ];

                          for (final it in items) {
                            final catName = (it['category'] ?? '').toString();
                            if (catName.isEmpty) continue;
                            if (seen.add(catName)) {
                              // crude icon mapping for common types
                              String icon = '🍽️';
                              final lower = catName.toLowerCase();
                              if (lower.contains('pizza'))
                                icon = '🍕';
                              else if (lower.contains('burger') ||
                                  lower.contains('zinger'))
                                icon = '🍔';
                              else if (lower.contains('biryani') ||
                                  lower.contains('karahi'))
                                icon = '🍲';
                              else if (lower.contains('dessert') ||
                                  lower.contains('brownie'))
                                icon = '🍰';
                              else if (lower.contains('drink'))
                                icon = '🥤';

                              cats.add({
                                'id': catName,
                                'name': catName,
                                'icon': icon,
                              });
                            }
                          }

                          return HomeCategorySelector(
                            categories: cats,
                            selectedCategory: state.activeTab,
                            onSelectCategory: (catId) {
                              context
                                  .read<RestaurantDetailBloc>()
                                  .filterByCategory(catId);
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Dish Items List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final dish = state.menuItems[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DishMenuItemTile(
                            dish: dish,
                            onSelectDish: () => widget.onSelectDish(dish),
                          ),
                        );
                      }, childCount: state.menuItems.length),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
