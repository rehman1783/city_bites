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
import '../widgets/restaurant_card_tile.dart';

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
                            borderRadius: 16),
                        SizedBox(height: 8),
                        SkeletonLoader(
                            width: 180, height: 20, borderRadius: 8),
                        SizedBox(height: 4),
                        SkeletonLoader(
                            width: 120, height: 14, borderRadius: 6),
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
              final filteredRestaurants = state.restaurants.where((r) {
                final matchesCategory = state.selectedCategory == 'all' ||
                    (r['tags'] as List).any((t) =>
                        t.toString().toLowerCase() ==
                        state.selectedCategory.toLowerCase());
                final matchesSearch = state.searchQuery.isEmpty ||
                    (r['name'] as String)
                        .toLowerCase()
                        .contains(state.searchQuery.toLowerCase());
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
                        HomeHeaderBar(
                          location: state.location,
                          onOpenCart: widget.onOpenCart,
                          onSearchChanged: (query) {
                            context
                                .read<HomeFeedBloc>()
                                .updateSearchQuery(query);
                          },
                        ),
                        const SizedBox(height: 20),

                        // Auto-Scrolling Promotional Carousel
                        BannerCarousel(
                          restaurants: state.restaurants,
                          onSelectRestaurant: widget.onSelectRestaurant,
                        ),
                        const SizedBox(height: 24),

                        // Featured Restaurants Section
                        if (state.searchQuery.isEmpty) ...[
                          FeaturedRestaurantsSection(
                            onSelectRestaurant: widget.onSelectRestaurant,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Categories Horizontal List Widget
                        HomeCategorySelector(
                          categories: state.categories,
                          selectedCategory: state.selectedCategory,
                          onSelectCategory: (catId) {
                            context.read<HomeFeedBloc>().selectCategory(catId);
                          },
                        ),
                        const SizedBox(height: 20),

                        // Top Rated Section Header
                        Text(
                          'All Restaurants in Sahiwal',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 14),

                        // Restaurant Cards List or Empty State
                        if (filteredRestaurants.isEmpty)
                          EmptyStateWidget(
                            icon: Icons.search_off_rounded,
                            title: 'No Restaurants Found',
                            description:
                                'We could not find any restaurant or dish matching "${state.searchQuery}" in Sahiwal.',
                            buttonText: 'Clear Search',
                            onRetry: () {
                              context
                                  .read<HomeFeedBloc>()
                                  .updateSearchQuery('');
                            },
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredRestaurants.length,
                            itemBuilder: (context, index) {
                              final rest = filteredRestaurants[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: RestaurantCardTile(
                                  restaurant: rest,
                                  onTap: () => widget.onSelectRestaurant(rest),
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
