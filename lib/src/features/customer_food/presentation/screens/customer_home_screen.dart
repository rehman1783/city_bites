import 'package:city_bites/src/features/customer_food/presentation/screens/location_picker_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/banner_carousel.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/featured_restaurants_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../bloc/home_feed_bloc.dart';
import '../widgets/home_header_bar.dart';
import '../widgets/home_category_selector.dart';
// restaurant_card_tile removed for Home -> Top Products view
import '../widgets/dish_menu_item_tile.dart';
import 'food_details_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_checkout_screen.dart';
import 'package:city_bites/src/core/constants/asset_paths.dart';

class CustomerHomeScreen extends StatefulWidget {
  final Function(Map<String, dynamic> restaurant) onSelectRestaurant;
  final VoidCallback onOpenCart;

  const CustomerHomeScreen({
    super.key,
    required this.onSelectRestaurant,
    required this.onOpenCart,
  });

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final List<Map<String, dynamic>> _topProducts = [
    {
      'id': 'tp_1',
      'name': 'Special Chicken Biryani',
      'description':
          'Aromatic basmati rice cooked with spices and tender chicken.',
      'price': 450.0,
      'image': AssetPaths.chickenBiryani,
      'isSpicy': true,
    },
    {
      'id': 'tp_2',
      'name': 'Crispy Zinger Burger',
      'description': 'Crispy chicken sandwich with fresh lettuce and sauce.',
      'price': 380.0,
      'image': AssetPaths.zingerBurger,
      'isSpicy': false,
    },
    {
      'id': 'tp_3',
      'name': 'Chocolate Brownie',
      'description': 'Warm chocolate brownie with dark chocolate drizzle.',
      'price': 250.0,
      'image': AssetPaths.chocolateBrownie,
      'isSpicy': false,
    },
  ];
  @override
  void initState() {
    super.initState();
    context.read<HomeFeedBloc>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeFeedBloc, HomeFeedState>(
          builder: (context, state) {
            if (state is HomeFeedLoading) {
              return ResponsiveWrapper(
                maxWidth: 1100,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 4,
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(
                          width: double.infinity,
                          height: 140,
                          borderRadius: 16,
                        ),
                        SizedBox(height: 8),
                        SkeletonLoader(width: 180, height: 20, borderRadius: 8),
                        SizedBox(height: 4),
                        SkeletonLoader(width: 120, height: 14, borderRadius: 6),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is HomeFeedError) {
              return Center(child: Text(state.message));
            }

            if (state is HomeFeedLoaded) {
              return ResponsiveWrapper(
                maxWidth: 1100,
                padding: EdgeInsets.zero,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeFeedBloc>().fetchHomeData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeHeaderBar(
                          location: state.location,
                          onOpenCart: widget.onOpenCart,
                          onLocationTap: () async {
                            final newLocation = await Navigator.of(context)
                                .push<String?>(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const LocationPickerScreen(),
                                  ),
                                );
                            if (newLocation != null && newLocation.isNotEmpty) {
                              context.read<HomeFeedBloc>().updateLocation(
                                newLocation,
                              );
                            }
                          },
                          onSearchChanged: (_) {},
                          showSearch: false,
                        ),
                        const SizedBox(height: 20),

                        // Auto-Scrolling Promotional Carousel
                        BannerCarousel(
                          restaurants: state.restaurants,
                          onSelectRestaurant: widget.onSelectRestaurant,
                        ),
                        const SizedBox(height: 24),

                        // Featured Restaurants Section
                        FeaturedRestaurantsSection(
                          onSelectRestaurant: widget.onSelectRestaurant,
                        ),
                        const SizedBox(height: 24),

                        // Categories Horizontal List Widget
                        // HomeCategorySelector(
                        //   categories: state.categories,
                        //   selectedCategory: state.selectedCategory,
                        //   onSelectCategory: (catId) {
                        //     context.read<HomeFeedBloc>().selectCategory(catId);
                        //   },
                        // ),
                        // const SizedBox(height: 20),

                        // Top Rated Products header
                        Text(
                          'Top Rated Products',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 14),

                        // Top Rated Products list
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _topProducts.length,
                          itemBuilder: (context, index) {
                            final product = _topProducts[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DishMenuItemTile(
                                dish: {
                                  'id': product['id'],
                                  'name': product['name'],
                                  'description': product['description'] ?? '',
                                  'price': product['price'] ?? 0,
                                  'image': product['image'] ?? '',
                                  'isSpicy': product['isSpicy'] ?? false,
                                },
                                onTap: () {
                                  final sanitized = {
                                    'id': product['id'] ?? '',
                                    'name': product['name'] ?? '',
                                    'description': product['description'] ?? '',
                                    'price': product['price'] ?? 0.0,
                                    'image': product['image'] ?? '',
                                    'isSpicy': product['isSpicy'] ?? false,
                                  };

                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FoodDetailsScreen(
                                        dish: sanitized,
                                        onBack: () =>
                                            Navigator.of(context).pop(),
                                        onAddToCart: (newItem) {
                                          try {
                                            context.read<CartBloc>().addItem(
                                              newItem,
                                            );
                                          } catch (_) {}
                                          Navigator.of(context).pop();
                                        },
                                        onBuyNow: (newItem) {
                                          try {
                                            context.read<CartBloc>().addItem(
                                              newItem,
                                            );
                                          } catch (_) {}
                                          Navigator.of(context).pop();
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CustomerCheckoutScreen(
                                                    onOrderPlaced: () {
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
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
                                  // show bottom sheet like Explore does
                                  showModalBottomSheet<void>(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              product['name'] ?? '',
                                              style: theme
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              product['description'] ?? '',
                                              style: theme.textTheme.bodyMedium,
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      context
                                                          .read<CartBloc>()
                                                          .addItem({
                                                            'id': product['id'],
                                                            'name':
                                                                product['name'],
                                                            'price':
                                                                product['price'] ??
                                                                0,
                                                            'quantity': 1,
                                                            'portion': 'Single',
                                                            'addons': [],
                                                            'image':
                                                                product['image'] ??
                                                                '',
                                                          });
                                                      Navigator.pop(context);
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            '${product['name']} added to cart',
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'Add to cart',
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      widget.onOpenCart();
                                                    },
                                                    child: const Text(
                                                      'View cart',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                onSelectDish: () {},
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
