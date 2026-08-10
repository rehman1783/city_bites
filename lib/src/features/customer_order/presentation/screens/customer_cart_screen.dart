import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../../core/widgets/quantity_stepper.dart';
import '../bloc/cart_bloc.dart';

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
            return Column(
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
                            Text(
                              state.restaurantName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
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
                              child: Dismissible(
                                key: Key(item['id']),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (_) {
                                  context
                                      .read<CartBloc>()
                                      .removeItem(item['id']);
                                },
                                child: CustomCard(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        child: NetworkImageLoader(
                                          imageUrl: item['image'],
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['name'],
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if ((item['addons'] as List)
                                                .isNotEmpty) ...[
                                              const SizedBox(height: 2),
                                              Text(
                                                'Addons: ${(item['addons'] as List).join(", ")}',
                                                style: theme.textTheme.bodySmall,
                                              ),
                                            ],
                                            const SizedBox(height: 6),
                                            Text(
                                              'PKR ${(item['price'] * item['quantity']).toInt()}',
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      QuantityStepper(
                                        count: item['quantity'],
                                        onChanged: (cnt) {
                                          context
                                              .read<CartBloc>()
                                              .updateQuantity(
                                                  item['id'], cnt);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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
                                hintText: 'Enter Promo Code (e.g. SAHIWAL50)',
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
                                        content: Text('Promo Code Applied!')),
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

                        // Bill Breakdown Box
                        CustomCard(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment & Bill Summary',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildBillRow(
                                theme,
                                label: 'Item Subtotal',
                                value: 'PKR ${state.subtotal.toInt()}',
                              ),
                              const SizedBox(height: 8),
                              _buildBillRow(
                                theme,
                                label: 'Sahiwal Local Delivery Fee',
                                value: 'PKR ${state.deliveryFee.toInt()}',
                              ),
                              const SizedBox(height: 8),
                              _buildBillRow(
                                theme,
                                label: 'Platform Service Fee',
                                value: 'PKR ${state.serviceFee.toInt()}',
                              ),
                              if (state.discountAmount > 0) ...[
                                const SizedBox(height: 8),
                                _buildBillRow(
                                  theme,
                                  label: 'Promo Discount',
                                  value:
                                      '- PKR ${state.discountAmount.toInt()}',
                                  isDiscount: true,
                                ),
                              ],
                              const Divider(height: 24),
                              _buildBillRow(
                                theme,
                                label: 'Total Payable',
                                value: 'PKR ${state.totalPayable.toInt()}',
                                isTotal: true,
                              ),
                            ],
                          ),
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
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildBillRow(
    ThemeData theme, {
    required String label,
    required String value,
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final style = isTotal
        ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : isDiscount
            ? theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              )
            : theme.textTheme.bodyMedium;

    final valStyle = isTotal
        ? theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
        : isDiscount
            ? theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              )
            : theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: valStyle),
      ],
    );
  }
}
