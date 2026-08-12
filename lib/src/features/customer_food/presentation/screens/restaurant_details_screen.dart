import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../bloc/restaurant_detail_bloc.dart';
import '../widgets/restaurant_info_header.dart';
import '../widgets/dish_menu_item_tile.dart';

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
  bool isFavorite = false;

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
                      CircleAvatar(
                        backgroundColor: Colors.black.withAlpha(120),
                        child: IconButton(
                          icon: Icon(
                            isFavorite
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: isFavorite
                                ? theme.colorScheme.primary
                                : Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isFavorite = !isFavorite;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
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

                  // Sticky Menu Category Tabs
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            'Popular',
                            'Deals',
                            'Fast Food',
                            'Drinks & Desserts'
                          ].map((cat) {
                            final isSelected = state.activeTab == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(cat),
                                selected: isSelected,
                                onSelected: (_) {
                                  context
                                      .read<RestaurantDetailBloc>()
                                      .filterByCategory(cat);
                                },
                                selectedColor: theme.colorScheme.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : theme.colorScheme.onSurface,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Dish Items List
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final dish = state.menuItems[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DishMenuItemTile(
                              dish: dish,
                              onSelectDish: () => widget.onSelectDish(dish),
                            ),
                          );
                        },
                        childCount: state.menuItems.length,
                      ),
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
