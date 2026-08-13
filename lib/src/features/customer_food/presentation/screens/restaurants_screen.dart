import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../bloc/home_feed_bloc.dart';
import '../widgets/featured_restaurants_section.dart';
import '../widgets/restaurant_card_tile.dart';

class RestaurantsScreen extends StatefulWidget {
  final Function(Map<String, dynamic> restaurant) onSelectRestaurant;
  final VoidCallback onOpenCart;

  const RestaurantsScreen({
    super.key,
    required this.onSelectRestaurant,
    required this.onOpenCart,
  });

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeFeedBloc>().fetchHomeData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> onSystemBackPressed() async {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      await _performRefresh();
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
    await _performRefresh();
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _performRefresh() async {
    await context.read<HomeFeedBloc>().fetchHomeData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Restaurants', showBackButton: false),
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
              final restaurants = state.restaurants;

              return ResponsiveWrapper(
                maxWidth: 1100,
                padding: EdgeInsets.zero,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context.read<HomeFeedBloc>().fetchHomeData();
                    setState(() {});
                  },
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Featured Restaurants
                        FeaturedRestaurantsSection(
                          onSelectRestaurant: widget.onSelectRestaurant,
                        ),
                        const SizedBox(height: 24),

                        // All Restaurants header
                        Text(
                          'All Restaurants in Sahiwal',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 14),

                        // Restaurant Cards List
                        if (restaurants.isEmpty)
                          EmptyStateWidget(
                            icon: Icons.search_off_rounded,
                            title: 'No Restaurants Found',
                            description:
                                'There are no restaurants available right now.',
                            buttonText: 'Try Again',
                            onRetry: () {
                              context.read<HomeFeedBloc>().fetchHomeData();
                            },
                          )
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: restaurants.length,
                            itemBuilder: (context, index) {
                              final rest = restaurants[index];
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
