import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../bloc/home_cubit.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_list.dart';
import '../widgets/food_item_card.dart';
import '../widgets/home_header.dart';

class CustomerHomeScreen extends StatelessWidget {
  final Function(int)? onNavigateTab;

  const CustomerHomeScreen({super.key, this.onNavigateTab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Sahiwal location & Cart Badge
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: HomeHeader(
                  onCartTap: () {
                    if (onNavigateTab != null) {
                      onNavigateTab!(1); // Cart tab
                    } else {
                      Navigator.pushNamed(context, '/cart');
                    }
                  },
                ),
              ),

              // Search Bar & Filter Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        labelText: '',
                        hintText: 'Search Biryani, Burgers, Pizza...',
                        prefixIcon: Icons.search,
                        onChanged: (val) {
                          context.read<HomeCubit>().searchItems(val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white),
                        onPressed: () {
                          _showFilterDialog(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Promo Banners Carousel
              const BannerCarousel(),
              const SizedBox(height: 20),

              // Categories Horizontal List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const CategoryList(),
              const SizedBox(height: 24),

              // Popular Food Items Horizontal Scroll
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Popular Near Scheme 3',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 222,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.foodItems.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final item = state.foodItems[index];
                        return FoodItemCard(
                          item: item,
                          isHorizontal: true,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/food_detail',
                              arguments: item,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Filtered / All Food Items Vertical List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return Text(
                      '${state.selectedCategory} Menu Items (${state.filteredItems.length})',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state.filteredItems.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 48,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No food items found',
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = state.filteredItems[index];
                      return FoodItemCard(
                        item: item,
                        isHorizontal: false,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/food_detail',
                            arguments: item,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Meals & Restaurants',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const CheckboxListTile(
                value: true,
                onChanged: null,
                title: Text('Free Delivery Deals'),
              ),
              const CheckboxListTile(
                value: false,
                onChanged: null,
                title: Text('Top Rated (4.5+)'),
              ),
              const CheckboxListTile(
                value: false,
                onChanged: null,
                title: Text('Under Rs. 500'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        );
      },
    );
  }
}
