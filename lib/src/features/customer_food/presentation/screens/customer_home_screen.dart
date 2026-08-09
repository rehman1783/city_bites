import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../../core/widgets/rating_badge.dart';
import '../bloc/home_feed_bloc.dart';

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
              return const Center(child: CircularProgressIndicator());
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

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeFeedBloc>().fetchHomeData();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      // Top Location & Header
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deliver to:',
                                  style: theme.textTheme.labelMedium,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      state.location,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: widget.onOpenCart,
                            icon: Badge(
                              label: const Text('2'),
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Search & Filter Bar
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              labelText: '',
                              hintText: 'Search biryani, burger, restaurants...',
                              prefixIcon: Icons.search_rounded,
                              onChanged: (q) {
                                context
                                    .read<HomeFeedBloc>()
                                    .updateSearchQuery(q);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.tune_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Promotional Carousel
                      SizedBox(
                        height: 150,
                        child: PageView.builder(
                          itemCount: state.banners.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Stack(
                                  children: [
                                    NetworkImageLoader(
                                      imageUrl: state.banners[index],
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withAlpha(160),
                                            Colors.transparent,
                                          ],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 12,
                                      left: 16,
                                      right: 16,
                                      child: Text(
                                        'Flat 20% OFF on Local Sahiwal Kitchens! 🚀',
                                        style: theme.textTheme.titleLarge
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Categories Horizontal List
                      Text(
                        'Categories',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.categories.length,
                          itemBuilder: (context, index) {
                            final cat = state.categories[index];
                            final isSelected =
                                state.selectedCategory == cat['id'];
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<HomeFeedBloc>()
                                    .selectCategory(cat['id']!);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 14),
                                child: Column(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme
                                                .surfaceContainerHighest,
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: theme
                                                      .colorScheme.primary
                                                      .withAlpha(80),
                                                  blurRadius: 8,
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          cat['icon']!,
                                          style: const TextStyle(fontSize: 26),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cat['name']!,
                                      style:
                                          theme.textTheme.labelMedium?.copyWith(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.w500,
                                        color: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Top Rated Section Header
                      Text(
                        'Top Rated Near You in Sahiwal',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 14),

                      // Restaurant Cards List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredRestaurants.length,
                        itemBuilder: (context, index) {
                          final rest = filteredRestaurants[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CustomCard(
                              onTap: () => widget.onSelectRestaurant(rest),
                              padding: EdgeInsets.zero,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: NetworkImageLoader(
                                          imageUrl: rest['image'],
                                          height: 160,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        child: RatingBadge(
                                          rating: rest['rating'],
                                          reviewCount: rest['reviewCount'],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 12,
                                        left: 12,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(180),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time_rounded,
                                                size: 14,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                rest['deliveryTime'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                rest['name'],
                                                style: theme
                                                    .textTheme.titleLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'Fee: PKR ${rest['deliveryFee']}',
                                              style: theme.textTheme.labelMedium
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.secondary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: (rest['tags'] as List<String>)
                                              .map(
                                                (t) => Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 6),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: theme.colorScheme
                                                        .surfaceContainerHighest,
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    t,
                                                    style: theme
                                                        .textTheme.labelSmall,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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
