import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/image_loader.dart';
import '../bloc/cart_cubit.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'My Food Basket',
        showBackButton: true,
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state.isOrderPlaced) {
            _showOrderPlacedSuccessDialog(context);
          }
        },
        builder: (context, state) {
          if (state.items.isEmpty && !state.isOrderPlaced) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your Basket is Empty!',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore Sahiwal eateries and add tasty meals',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    width: 200,
                    text: 'Explore Menu',
                    onPressed: () {
                      Navigator.pushNamed(context, '/main');
                    },
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Delivery Address Card
                CustomCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivering To',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              state.deliveryAddress,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_location_alt_outlined, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Selected Items Header
                Text(
                  'Order Items (${state.totalItemCount})',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Selected Items List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = state.items[index];
                    final food = cartItem.foodItem;

                    return CustomCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ImageLoader(
                            imageUrl: food.imageUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                            borderRadius: 12,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  food.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  food.restaurantName,
                                  style: theme.textTheme.bodySmall,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${AppConstants.currency} ${food.price.toInt()}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Stepper
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                onPressed: () {
                                  context.read<CartCubit>().removeItem(food.id);
                                },
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<CartCubit>()
                                          .updateQuantity(food.id, cartItem.quantity - 1);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.remove, size: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      '${cartItem.quantity}',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<CartCubit>()
                                          .updateQuantity(food.id, cartItem.quantity + 1);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.primary,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Icon(Icons.add, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Promo Code Box
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.local_offer_outlined, color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Voucher / Promo Code',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _promoController,
                              labelText: '',
                              hintText: 'Try code: SAHIWAL30',
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              final success = context
                                  .read<CartCubit>()
                                  .applyPromoCode(_promoController.text);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Promo Code Applied! 30% Off'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid Promo Code. Try SAHIWAL30'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            child: const Text('Apply'),
                          ),
                        ],
                      ),
                      if (state.promoCode != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Code ${state.promoCode} applied!',
                              style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                context.read<CartCubit>().clearPromoCode();
                                _promoController.clear();
                              },
                              child: const Text(
                                'Remove',
                                style: TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Order Summary Breakdown Card
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Summary',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        context,
                        'Subtotal',
                        '${AppConstants.currency} ${state.subtotal.toInt()}',
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        context,
                        'Delivery Fee (Sahiwal)',
                        '${AppConstants.currency} ${state.deliveryFee.toInt()}',
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        context,
                        'GST Tax (5%)',
                        '${AppConstants.currency} ${state.tax.toInt()}',
                      ),
                      if (state.discountAmount > 0) ...[
                        const SizedBox(height: 8),
                        _buildSummaryRow(
                          context,
                          'Discount (30%)',
                          '- ${AppConstants.currency} ${state.discountAmount.toInt()}',
                          isDiscount: true,
                        ),
                      ],
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        'Total Payable',
                        '${AppConstants.currency} ${state.total.toInt()}',
                        isTotal: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Place Order Button
                CustomButton(
                  text: 'Place Order (${AppConstants.currency} ${state.total.toInt()})',
                  icon: Icons.check_circle_outline,
                  onPressed: () {
                    context.read<CartCubit>().placeOrder();
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
              : theme.textTheme.bodyMedium,
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 18 : 14,
            color: isDiscount
                ? Colors.green
                : isTotal
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  void _showOrderPlacedSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'Order Placed Successfully!',
                style: Theme.of(dialogContext).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your food is being prepared by the restaurant in Sahiwal. Our rider will reach you in 25-30 minutes.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  context.read<CartCubit>().resetOrderPlaced();
                  Navigator.of(context).pushNamedAndRemoveUntil('/main', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Back to Home'),
              ),
            ],
          ),
        );
      },
    );
  }
}
