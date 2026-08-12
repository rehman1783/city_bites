import 'package:city_bites/src/features/customer_food/presentation/screens/location_picker_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/banner_carousel.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/dish_menu_item_tile.dart';
import 'package:city_bites/src/features/customer_food/presentation/widgets/home_category_selector.dart';
import 'package:city_bites/src/core/constants/asset_paths.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../bloc/home_feed_bloc.dart';

class ExploreScreen extends StatefulWidget {
  final Function(Map<String, dynamic> restaurant) onSelectRestaurant;
  final VoidCallback onOpenCart;

  const ExploreScreen({
    super.key,
    required this.onSelectRestaurant,
    required this.onOpenCart,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final List<Map<String, dynamic>> _productItems = [
    {
      'id': 'prod_1',
      'name': 'Special Chicken Biryani',
      'description':
          'Aromatic basmati rice cooked with spices and tender chicken.',
      'price': 450.0,
      'image': AssetPaths.chickenBiryani,
      'category': 'biryani',
      'isSpicy': true,
    },
    {
      'id': 'prod_2',
      'name': 'Crispy Zinger Burger',
      'description': 'Crispy chicken sandwich with fresh lettuce and sauce.',
      'price': 380.0,
      'image': AssetPaths.zingerBurger,
      'category': 'burgers',
      'isSpicy': false,
    },
    {
      'id': 'prod_3',
      'name': 'Pepperoni Pizza',
      'description': 'Classic pizza topped with cheese and pepperoni.',
      'price': 990.0,
      'image': AssetPaths.pepperPizza,
      'category': 'pizza',
      'isSpicy': false,
    },
    {
      'id': 'prod_4',
      'name': 'Desi Chicken Karahi',
      'description': 'Spiced chicken cooked with tomatoes and green chillies.',
      'price': 1250.0,
      'image': AssetPaths.chickenKarahi,
      'category': 'karahi',
      'isSpicy': true,
    },
    {
      'id': 'prod_5',
      'name': 'Chocolate Brownie',
      'description': 'Warm chocolate brownie with dark chocolate drizzle.',
      'price': 250.0,
      'image': AssetPaths.chocolateBrownie,
      'category': 'desserts',
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
      appBar: const CustomAppBar(title: 'Explore', showBackButton: false),
      body: BlocBuilder<HomeFeedBloc, HomeFeedState>(
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
            final filteredProducts = _productItems.where((product) {
              final matchesCategory =
                  state.selectedCategory == 'all' ||
                  (product['category'] as String).toLowerCase().contains(
                    state.selectedCategory.toLowerCase(),
                  );
              final matchesSearch =
                  state.searchQuery.isEmpty ||
                  (product['name'] as String).toLowerCase().contains(
                    state.searchQuery.toLowerCase(),
                  );
              return matchesCategory && matchesSearch;
            }).toList();

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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              labelText: '',
                              hintText:
                                  'Search items, cuisines, restaurants...',
                              prefixIcon: Icons.search_rounded,
                              isCompact: true,
                              height: 52,
                              onChanged: (query) {
                                context.read<HomeFeedBloc>().updateSearchQuery(
                                  query,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Filter by category',
                                            style: theme.textTheme.headlineSmall,
                                          ),
                                          const SizedBox(height: 16),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: state.categories
                                                .map((category) {
                                                  final isActive =
                                                      state.selectedCategory ==
                                                      category['id'];
                                                  return ChoiceChip(
                                                    label: Text(category['name']),
                                                    selected: isActive,
                                                    onSelected: (_) {
                                                      Navigator.pop(context);
                                                      context
                                                          .read<HomeFeedBloc>()
                                                          .selectCategory(
                                                            category['id']
                                                                as String,
                                                          );
                                                    },
                                                  );
                                                })
                                                .toList()
                                                .cast<Widget>(),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.filter_list),
                              label: const Text('Filter'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      BannerCarousel(
                        restaurants: state.restaurants,
                        onSelectRestaurant: widget.onSelectRestaurant,
                      ),
                      const SizedBox(height: 24),
                      Text('Products', style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 14),
                      HomeCategorySelector(
                        categories: state.categories,
                        selectedCategory: state.selectedCategory,
                        onSelectCategory: (catId) {
                          context.read<HomeFeedBloc>().selectCategory(catId);
                        },
                      ),
                      const SizedBox(height: 20),
                      if (filteredProducts.isEmpty)
                        EmptyStateWidget(
                          icon: Icons.search_off_rounded,
                          title: 'No products found',
                          description:
                              'Try a different search or filter to discover more items.',
                          buttonText: 'Clear Search',
                          onRetry: () {
                            context.read<HomeFeedBloc>().updateSearchQuery('');
                          },
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = filteredProducts[index];
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
    );
  }
}
