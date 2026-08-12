import 'package:city_bites/src/core/widgets/custom_button.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:city_bites/src/core/widgets/quantity_stepper.dart';
import 'package:city_bites/src/features/customer_food/presentation/bloc/food_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../widgets/food_portion_selector_card.dart';
import '../widgets/food_addons_selector_card.dart';

class FoodDetailsScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sanitizedDish = {
      'id': dish['id'] ?? '',
      'name': dish['name'] ?? '',
      'description': dish['description'] ?? '',
      'price': dish['price'] ?? 0.0,
      'image': dish['image'] ?? '',
      'isSpicy': dish['isSpicy'] ?? false,
    };

    return BlocProvider(
      create: (context) => FoodDetailCubit(sanitizedDish),
      child: Scaffold(
        body: SafeArea(
          child: ResponsiveWrapper(
            maxWidth: 800,
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                                      onPressed: onBack,
                                    ),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          sanitizedDish['name'],
                                          style: theme.textTheme.headlineMedium
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          'PKR ${state.unitPrice.toInt()}',
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    sanitizedDish['description'],
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
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
                                    onChanged: cubit.updateSpecialInstructions,
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
                                  style: theme.textTheme.titleMedium?.copyWith(
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
                                    onBuyNow({
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
                                    onAddToCart({
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
    );
  }
}
