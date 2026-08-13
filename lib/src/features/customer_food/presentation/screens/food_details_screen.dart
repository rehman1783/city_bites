import 'package:city_bites/src/core/widgets/custom_button.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:city_bites/src/core/widgets/quantity_stepper.dart';
import 'package:city_bites/src/features/customer_food/presentation/bloc/food_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:city_bites/src/core/services/favorites_service.dart';
import 'package:city_bites/src/core/widgets/snackbar_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../widgets/food_portion_selector_card.dart';
import '../widgets/food_addons_selector_card.dart';

class FoodDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> dish;
  final VoidCallback onBack;
  final Function(Map<String, dynamic> item) onAddToCart;
  final Function(Map<String, dynamic> item) onBuyNow;

  const FoodDetailsScreen({
    super.key,
    required this.dish,
    required this.onBack,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

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
    // For details screen, re-create any necessary state; here we just rebuild
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sanitizedDish = {
      'id': widget.dish['id'] ?? '',
      'name': widget.dish['name'] ?? '',
      'description': widget.dish['description'] ?? '',
      'price': widget.dish['price'] ?? 0.0,
      'image': widget.dish['image'] ?? '',
      'isSpicy': widget.dish['isSpicy'] ?? false,
    };

    return BlocProvider(
      create: (context) => FoodDetailCubit(sanitizedDish),
      child: WillPopScope(
        onWillPop: () async {
          if (MediaQuery.of(context).viewInsets.bottom > 0) {
            FocusScope.of(context).unfocus();
            return false;
          }
          if (_scrollController.hasClients && _scrollController.offset > 0) {
            await _performRefresh();
            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
            return false;
          }
          // Call the provided onBack callback so parent routing logic handles
          // closing the details view (avoids accidental double-pop that
          // could exit the app).
          widget.onBack();
          return false;
        },
        child: Scaffold(
          body: SafeArea(
            child: ResponsiveWrapper(
              maxWidth: 800,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await _performRefresh();
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: BlocBuilder<FoodDetailCubit, FoodDetailState>(
                          builder: (context, state) {
                            final cubit = context.read<FoodDetailCubit>();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Hero Image Banner with back button
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        bottom: Radius.circular(24),
                                      ),
                                      child: NetworkImageLoader(
                                        imageUrl: sanitizedDish['image'],
                                        height: 240,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      left: 12,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.black.withAlpha(
                                          120,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          onPressed: widget.onBack,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child:
                                          ValueListenableBuilder<
                                            List<Map<String, dynamic>>
                                          >(
                                            valueListenable: FavoritesService
                                                .instance
                                                .products,
                                            builder: (context, value, _) {
                                              final isFav = value.any(
                                                (e) =>
                                                    (e['id']?.toString() ??
                                                        '') ==
                                                    (sanitizedDish['id']
                                                            ?.toString() ??
                                                        ''),
                                              );
                                              return CircleAvatar(
                                                backgroundColor: Colors.black
                                                    .withAlpha(120),
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
                                                    final added =
                                                        await FavoritesService
                                                            .instance
                                                            .toggleProduct(
                                                              sanitizedDish,
                                                            );
                                                    if (!context.mounted)
                                                      return;
                                                    showAppSnackBar(
                                                      context,
                                                      added
                                                          ? '${sanitizedDish['name']} added to favorites'
                                                          : '${sanitizedDish['name']} removed from favorites',
                                                    );
                                                    setState(() {});
                                                  },
                                                ),
                                              );
                                            },
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
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
                                              sanitizedDish['name'],
                                              style: theme
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: theme
                                                  .colorScheme
                                                  .primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'PKR ${state.unitPrice.toInt()}',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        sanitizedDish['description'],
                                        style: theme.textTheme.bodyLarge
                                            ?.copyWith(
                                              color: theme
                                                  .colorScheme
                                                  .onSurfaceVariant,
                                            ),
                                      ),
                                      const SizedBox(height: 20),

                                      // Portion Selector Custom Widget
                                      FoodPortionSelectorCard(
                                        selectedPortion: state.selectedPortion,
                                        onPortionSelected: (portion) =>
                                            cubit.selectPortion(portion),
                                      ),
                                      const SizedBox(height: 20),

                                      // Add-ons Selector Custom Widget
                                      FoodAddonsSelectorCard(
                                        selectedAddons: state.selectedAddons,
                                        onToggleAddon: (addon) =>
                                            cubit.toggleAddon(addon),
                                      ),
                                      const SizedBox(height: 20),

                                      // Special Instructions Field
                                      CustomTextField(
                                        labelText: 'Special Instructions',
                                        hintText:
                                            'E.g. Make it less spicy, extra mint raita',
                                        height: 60,
                                        maxLines: 2,
                                        keyboardType: TextInputType.multiline,
                                        onChanged:
                                            cubit.updateSpecialInstructions,
                                      ),
                                      const SizedBox(height: 24),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // Bottom Sticky Bar: show quantity + price row, then action buttons
                  BlocBuilder<FoodDetailCubit, FoodDetailState>(
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withAlpha(20),
                              blurRadius: 10,
                              offset: const Offset(0, -4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top row: Quantity selector and price
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                QuantityStepper(
                                  count: state.quantity,
                                  onChanged: (cnt) {
                                    context
                                        .read<FoodDetailCubit>()
                                        .updateQuantity(cnt);
                                  },
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'PKR ${state.totalPrice.toInt()}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Action row: Buy Now and Add (no price in labels)
                            Row(
                              children: [
                                Expanded(
                                  child: CustomButton(
                                    text: 'Buy Now',
                                    icon: Icons.flash_on,
                                    onPressed: () {
                                      widget.onBuyNow({
                                        'id': sanitizedDish['id'],
                                        'name': sanitizedDish['name'],
                                        'price': state.unitPrice,
                                        'quantity': state.quantity,
                                        'portion': state.selectedPortion,
                                        'addons': state.selectedAddons.toList(),
                                        'image': sanitizedDish['image'],
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: CustomButton(
                                    text: 'Add',
                                    icon: Icons.shopping_bag_outlined,
                                    type: CustomButtonType.secondary,
                                    onPressed: () {
                                      widget.onAddToCart({
                                        'id': sanitizedDish['id'],
                                        'name': sanitizedDish['name'],
                                        'price': state.unitPrice,
                                        'quantity': state.quantity,
                                        'portion': state.selectedPortion,
                                        'addons': state.selectedAddons.toList(),
                                        'image': sanitizedDish['image'],
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
