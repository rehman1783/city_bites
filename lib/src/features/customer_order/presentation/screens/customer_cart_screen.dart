import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_button.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:city_bites/src/core/widgets/empty_state_widget.dart';
import 'package:city_bites/src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_bill_summary_card.dart';

class CustomerCartScreen extends StatefulWidget {
  final VoidCallback onProceedToCheckout;

  const CustomerCartScreen({
    super.key,
    required this.onProceedToCheckout,
  });

  @override
  State<CustomerCartScreen> createState() => _CustomerCartScreenState();
}

class _CustomerCartScreenState extends State<CustomerCartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Your Cart',
        showBackButton: false,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartEmpty) {
            return const EmptyStateWidget(
              icon: Icons.shopping_basket_outlined,
              title: 'Your Basket is Empty',
              description:
                  'Explore top Sahiwal restaurants and add delicious Karahi, Biryani, or Burgers to your cart!',
            );
          }

          if (state is CartLoaded) {
            return ResponsiveWrapper(
              maxWidth: 900,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Restaurant Header Title
                          Row(
                            children: [
                              Icon(
                                Icons.storefront,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.restaurantName,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Items List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final item = state.items[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CartItemTile(
                                  item: item,
                                  onQuantityChanged: (cnt) {
                                    context
                                        .read<CartBloc>()
                                        .updateQuantity(item['id'], cnt);
                                  },
                                  onDismissed: () {
                                    context
                                        .read<CartBloc>()
                                        .removeItem(item['id']);
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // Promo Code Input Box
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _promoController,
                                  labelText: '',
                                  hintText:
                                      'Enter Promo Code (e.g. SAHIWAL50)',
                                  prefixIcon: Icons.local_offer_outlined,
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (_promoController.text.isNotEmpty) {
                                    context.read<CartBloc>().applyPromoCode(
                                        _promoController.text.trim());
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Promo Code Applied!')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                child: const Text('Apply'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Bill Breakdown Summary Widget
                          CartBillSummaryCard(
                            subtotal: state.subtotal,
                            deliveryFee: state.deliveryFee,
                            serviceFee: state.serviceFee,
                            discountAmount: state.discountAmount,
                            totalPayable: state.totalPayable,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Sticky CTA Button
                  Container(
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
                    child: CustomButton(
                      text:
                          'Proceed to Checkout — PKR ${state.totalPayable.toInt()}',
                      icon: Icons.arrow_forward_rounded,
                      onPressed: widget.onProceedToCheckout,
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
