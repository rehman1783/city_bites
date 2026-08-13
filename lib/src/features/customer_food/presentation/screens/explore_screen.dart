// Unused imports kept commented for future features
// import 'package:city_bites/src/features/customer_food/presentation/screens/location_picker_screen.dart';
// import 'package:city_bites/src/features/customer_food/presentation/widgets/banner_carousel.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class ExploreScreen extends StatefulWidget {
  final Function(Map<String, dynamic> restaurant) onSelectRestaurant;
  final Function(Map<String, dynamic> dish) onSelectDish;
  final VoidCallback onOpenCart;

  const ExploreScreen({
    super.key,
    required this.onSelectRestaurant,
    required this.onSelectDish,
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

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<String> _searchHistory = [];
  List<Map<String, dynamic>> _currentSuggestions = [];

  @override
  void initState() {
    super.initState();
    context.read<HomeFeedBloc>().fetchHomeData();
    _loadSearchHistory();
    _searchController.addListener(_onSearchChanged);
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        _saveQueryToHistory(_searchController.text.trim());
        setState(() {
          _currentSuggestions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(AppConstants.searchHistoryKey) ?? [];
      setState(() {
        _searchHistory = list;
      });
    } catch (_) {
      // ignore
    }
  }

  Future<void> _saveQueryToHistory(String query) async {
    if (query.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = prefs.getStringList(AppConstants.searchHistoryKey) ?? [];
      final updated = List<String>.from(list);
      // remove existing duplicate
      updated.removeWhere((e) => e.toLowerCase() == query.toLowerCase());
      updated.insert(0, query);
      // limit history length
      if (updated.length > 10) updated.removeRange(10, updated.length);
      await prefs.setStringList(AppConstants.searchHistoryKey, updated);
      setState(() {
        _searchHistory = updated;
      });
    } catch (_) {
      // ignore
    }
  }

  void _onSearchChanged() {
    final q = _searchController.text.trim();
    _updateSuggestions(q);
    context.read<HomeFeedBloc>().updateSearchQuery(q);
  }

  void _updateSuggestions(String query) {
    final q = query.toLowerCase();
    final matches = <Map<String, dynamic>>[];

    // Respect selected category from bloc state
    String selectedCategory = 'all';
    final blocState = context.read<HomeFeedBloc>().state;
    if (blocState is HomeFeedLoaded) {
      selectedCategory = blocState.selectedCategory.toLowerCase();
    }

    bool productInCategory(Map<String, dynamic> p) {
      final cat = (p['category'] as String).toLowerCase();
      return selectedCategory == 'all' || cat.contains(selectedCategory);
    }

    if (q.isEmpty) {
      // show recent history but only those relevant to the selected category
      for (final h in _searchHistory) {
        final hLower = h.toLowerCase();
        final related = _productItems.any((p) {
          return productInCategory(p) &&
              ((p['name'] as String).toLowerCase().contains(hLower) ||
                  (p['description'] as String).toLowerCase().contains(hLower));
        });
        if (related) {
          matches.add({'type': 'history', 'text': h});
        }
      }
    } else {
      // product matches (restricted to selected category)
      for (final p in _productItems) {
        if (!productInCategory(p)) continue;
        final name = (p['name'] as String).toLowerCase();
        final desc = (p['description'] as String).toLowerCase();
        final category = (p['category'] as String).toLowerCase();
        if (name.contains(q) || desc.contains(q) || category.contains(q)) {
          matches.add({'type': 'product', 'product': p});
        }
      }
      // also include matching history entries relevant to category
      for (final h in _searchHistory) {
        if (h.toLowerCase().contains(q)) {
          // ensure history entry maps to selected category
          final hLower = h.toLowerCase();
          final matchesCat = _productItems.any((p) {
            return productInCategory(p) &&
                ((p['name'] as String).toLowerCase().contains(hLower) ||
                    (p['description'] as String).toLowerCase().contains(
                      hLower,
                    ));
          });
          if (matchesCat) {
            matches.insert(0, {'type': 'history', 'text': h});
          }
        }
      }
    }

    setState(() {
      _currentSuggestions = matches;
    });
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
    // Clear search input and suggestions on refresh
    _searchController.clear();
    context.read<HomeFeedBloc>().updateSearchQuery('');
    setState(() {
      _currentSuggestions = [];
    });
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
                  await _performRefresh();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  labelText: '',
                                  hintText:
                                      'Search items, cuisines, restaurants...',
                                  prefixIcon: Icons.search_rounded,
                                  isCompact: true,
                                  height: 52,
                                ),
                                if (_currentSuggestions.isNotEmpty &&
                                    _searchFocusNode.hasFocus)
                                  Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    constraints: const BoxConstraints(
                                      maxHeight: 220,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Theme.of(
                                        context,
                                      ).scaffoldBackgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: _currentSuggestions.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, i) {
                                        final item = _currentSuggestions[i];
                                        if (item['type'] == 'product') {
                                          final prod =
                                              item['product']
                                                  as Map<String, dynamic>;
                                          final img = prod['image'] as String?;
                                          Widget leadingWidget = const SizedBox(
                                            width: 40,
                                            height: 40,
                                          );
                                          if (img != null && img.isNotEmpty) {
                                            if (img.startsWith('http')) {
                                              leadingWidget = Image.network(
                                                img,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              );
                                            } else {
                                              leadingWidget = Image.asset(
                                                img,
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                          }

                                          return ListTile(
                                            leading: leadingWidget,
                                            title: Text(prod['name']),
                                            subtitle: Text(
                                              prod['category'] ?? '',
                                            ),
                                            onTap: () {
                                              _searchController.text =
                                                  prod['name'];
                                              context
                                                  .read<HomeFeedBloc>()
                                                  .updateSearchQuery(
                                                    prod['name'],
                                                  );
                                              _saveQueryToHistory(prod['name']);
                                              widget.onSelectDish(prod);
                                              _searchFocusNode.unfocus();
                                            },
                                          );
                                        }

                                        // history item
                                        return ListTile(
                                          leading: const Icon(
                                            Icons.history,
                                            size: 20,
                                          ),
                                          title: Text(item['text'] ?? ''),
                                          onTap: () {
                                            final txt = item['text'] ?? '';
                                            _searchController.text = txt;
                                            context
                                                .read<HomeFeedBloc>()
                                                .updateSearchQuery(txt);
                                            _saveQueryToHistory(txt);
                                            _searchFocusNode.unfocus();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 0),
                        ],
                      ),
                      // const SizedBox(height: 24),
                      // BannerCarousel(
                      //   restaurants: state.restaurants,
                      //   onSelectRestaurant: widget.onSelectRestaurant,
                      // ),
                      const SizedBox(height: 24),
                      // Text('Products', style: theme.textTheme.headlineMedium),
                      // const SizedBox(height: 14),
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
                                onSelectDish: () =>
                                    widget.onSelectDish(product),
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
