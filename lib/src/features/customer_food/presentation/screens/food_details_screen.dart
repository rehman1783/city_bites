import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../bloc/food_detail_cubit.dart';

class FoodDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> dish;
  final VoidCallback onBack;
  final Function(Map<String, dynamic> item) onAddToCart;

  const FoodDetailsScreen({
    super.key,
    required this.dish,
    required this.onBack,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => FoodDetailCubit(dish),
      child: Scaffold(
        body: SafeArea(
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
                                  imageUrl: dish['image'],
                                  height: 240,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: CircleAvatar(
                                  backgroundColor: Colors.black.withAlpha(120),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dish['name'],
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'PKR ${state.unitPrice.toInt()}',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  dish['description'],
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Radio Options: Select Portion Size
                                Text(
                                  'Select Portion Size',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomCard(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      RadioListTile<String>(
                                        title: const Text('Single'),
                                        subtitle: const Text('Standard portion'),
                                        secondary: const Text('PKR 0'),
                                        value: 'Single',
                                        groupValue: state.selectedPortion,
                                        onChanged: (val) =>
                                            cubit.selectPortion(val!),
                                      ),
                                      const Divider(height: 1),
                                      RadioListTile<String>(
                                        title: const Text('Double'),
                                        subtitle: const Text('Extra portion'),
                                        secondary: const Text('+ PKR 150'),
                                        value: 'Double',
                                        groupValue: state.selectedPortion,
                                        onChanged: (val) =>
                                            cubit.selectPortion(val!),
                                      ),
                                      const Divider(height: 1),
                                      RadioListTile<String>(
                                        title: const Text('Family Pack'),
                                        subtitle: const Text('Large sharing size'),
                                        secondary: const Text('+ PKR 350'),
                                        value: 'Family',
                                        groupValue: state.selectedPortion,
                                        onChanged: (val) =>
                                            cubit.selectPortion(val!),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Checkbox Options: Add Extra Toppings / Add-ons
                                Text(
                                  'Extra Add-ons',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                CustomCard(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      CheckboxListTile(
                                        title: const Text('Extra Cheese'),
                                        secondary: const Text('+ PKR 80'),
                                        value: state.selectedAddons
                                            .contains('Extra Cheese'),
                                        onChanged: (_) =>
                                            cubit.toggleAddon('Extra Cheese'),
                                      ),
                                      const Divider(height: 1),
                                      CheckboxListTile(
                                        title: const Text('Mayo Dip'),
                                        secondary: const Text('+ PKR 40'),
                                        value: state.selectedAddons
                                            .contains('Mayo Dip'),
                                        onChanged: (_) =>
                                            cubit.toggleAddon('Mayo Dip'),
                                      ),
                                      const Divider(height: 1),
                                      CheckboxListTile(
                                        title: const Text('Cold Drink 345ml'),
                                        secondary: const Text('+ PKR 90'),
                                        value: state.selectedAddons
                                            .contains('Cold Drink 345ml'),
                                        onChanged: (_) => cubit
                                            .toggleAddon('Cold Drink 345ml'),
                                      ),
                                    ],
                                  ),
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

              // Bottom Sticky Bar: Quantity Stepper + Add to Cart CTA
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
                    child: Row(
                      children: [
                        QuantityStepper(
                          count: state.quantity,
                          onChanged: (cnt) {
                            context
                                .read<FoodDetailCubit>()
                                .updateQuantity(cnt);
                          },
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            text: 'Add — PKR ${state.totalPrice.toInt()}',
                            icon: Icons.shopping_bag_outlined,
                            onPressed: () {
                              onAddToCart({
                                'id': dish['id'],
                                'name': dish['name'],
                                'price': state.unitPrice,
                                'quantity': state.quantity,
                                'portion': state.selectedPortion,
                                'addons': state.selectedAddons.toList(),
                                'image': dish['image'],
                              });
                            },
                          ),
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
    );
  }
}
