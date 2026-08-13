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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> onSystemBackPressed() async {
    if (MediaQuery.of(context).viewInsets.bottom > 0) {
      FocusScope.of(context).unfocus();
      return true;
    }
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      context.read<RestaurantDetailBloc>().loadRestaurant(widget.restaurant);
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      return true;
    }
    return false;
  }

  Future<void> refreshAndScrollToTop() async {
    context.read<RestaurantDetailBloc>().loadRestaurant(widget.restaurant);
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<RestaurantDetailBloc>().loadRestaurant(widget.restaurant);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final handled = await onSystemBackPressed();
        if (handled)
          return false; // we handled it (refresh/scroll-to-top) or will notify parent
        // Notify parent to close this details view, but prevent default system pop
        widget.onBack();
        return false;
      },
      child: Scaffold(
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
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<RestaurantDetailBloc>().loadRestaurant(
                      widget.restaurant,
                    );
                    setState(() {});
                  },
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Expandable Hero Banner SliverAppBar
                      SliverAppBar(
                        expandedHeight: 220,
                        pinned: true,
                        leading: CircleAvatar(
                          backgroundColor: Colors.black.withAlpha(120),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: widget.onBack,
                          ),
                        ),
                        actions: [
                          ValueListenableBuilder<List<Map<String, dynamic>>>(
                            valueListenable:
                                FavoritesService.instance.restaurants,
                            builder: (context, value, _) {
                              final isFav = value.any(
                                (e) =>
                                    (e['id']?.toString() ?? '') ==
                                    (widget.restaurant['id']?.toString() ?? ''),
                              );
                              return Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.black.withAlpha(
                                      120,
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFav
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                      onPressed: () async {
                                        final added = await FavoritesService
                                            .instance
                                            .toggleRestaurant(
                                              widget.restaurant,
                                            );
                                        if (!context.mounted) return;
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
                              // Use the same category palette as the Explore screen
                              final cats = <Map<String, String>>[
                                {'id': 'all', 'name': 'All', 'icon': '🍽️'},
                                {
                                  'id': 'biryani',
                                  'name': 'Biryani',
                                  'icon': '🍲',
                                },
                                {
                                  'id': 'burgers',
                                  'name': 'Burgers',
                                  'icon': '🍔',
                                },
                                {'id': 'pizza', 'name': 'Pizza', 'icon': '🍕'},
                                {
                                  'id': 'karahi',
                                  'name': 'Karahi',
                                  'icon': '🥘',
                                },
                                {
                                  'id': 'desserts',
                                  'name': 'Desserts',
                                  'icon': '🍰',
                                },
                                {
                                  'id': 'drinks',
                                  'name': 'Drinks',
                                  'icon': '🥤',
                                },
                              ];

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
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
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
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
