import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../bloc/checkout_bloc.dart';

class CustomerCheckoutScreen extends StatelessWidget {
  final VoidCallback onOrderPlaced;
  final VoidCallback? onBack;

  const CustomerCheckoutScreen({
    super.key,
    required this.onOrderPlaced,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => CheckoutBloc(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Checkout',
          onBack: onBack,
        ),
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is OrderSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #${state.orderId} Placed Successfully!'),
                  backgroundColor: theme.colorScheme.secondary,
                ),
              );
              onOrderPlaced();
            }
          },
          builder: (context, state) {
            final cubit = context.read<CheckoutBloc>();
            final isPlacing = state is OrderPlacing;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Delivery Address Card
                        Text(
                          'Delivery Address',
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
                                value: 'Scheme 3, College Road, Sahiwal',
                                groupValue: state.selectedAddress,
                                onChanged: (val) => cubit.selectAddress(val!),
                                title: const Text('Home'),
                                subtitle: const Text(
                                    'House #42, Scheme 3, College Road, Sahiwal'),
                                secondary:
                                    const Icon(Icons.home_outlined, size: 20),
                              ),
                              const Divider(height: 1),
                              RadioListTile<String>(
                                value: 'High Street Market, Sahiwal',
                                groupValue: state.selectedAddress,
                                onChanged: (val) => cubit.selectAddress(val!),
                                title: const Text('Office'),
                                subtitle: const Text(
                                    'Plaza 3, High Street Market, Sahiwal'),
                                secondary:
                                    const Icon(Icons.work_outline, size: 20),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Payment Method Selector
                        Text(
                          'Payment Method',
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
                                value: 'COD',
                                groupValue: state.selectedPaymentMethod,
                                onChanged: (val) =>
                                    cubit.selectPaymentMethod(val!),
                                title: const Text('Cash on Delivery (COD)'),
                                subtitle:
                                    const Text('Pay with cash upon delivery'),
                                secondary: const Icon(
                                    Icons.payments_outlined,
                                    color: Colors.green),
                              ),
                              const Divider(height: 1),
                              RadioListTile<String>(
                                value: 'JazzCash',
                                groupValue: state.selectedPaymentMethod,
                                onChanged: (val) =>
                                    cubit.selectPaymentMethod(val!),
                                title: const Text('JazzCash / EasyPaisa'),
                                subtitle: const Text(
                                    'Instant digital mobile wallet payment'),
                                secondary: const Icon(
                                    Icons.account_balance_wallet_outlined,
                                    color: Colors.orange),
                              ),
                              const Divider(height: 1),
                              RadioListTile<String>(
                                value: 'Card',
                                groupValue: state.selectedPaymentMethod,
                                onChanged: (val) =>
                                    cubit.selectPaymentMethod(val!),
                                title: const Text('Credit / Debit Card'),
                                subtitle:
                                    const Text('Visa / MasterCard support'),
                                secondary: const Icon(
                                    Icons.credit_card_outlined,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Order Summary Accordion
                        ExpansionTile(
                          title: Text(
                            'Order Summary Preview',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          initiallyExpanded: true,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('2x Special Chicken Biryani'),
                                      Text('PKR 900',
                                          style: theme.textTheme.titleMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('1x Crispy Zinger Burger'),
                                      Text('PKR 380',
                                          style: theme.textTheme.titleMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Delivery & Platform Fee'),
                                      Text('PKR 80',
                                          style: theme.textTheme.titleMedium),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Sticky CTA Bar
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
                    text: 'Place Order — PKR 1,180',
                    isLoading: isPlacing,
                    icon: Icons.check_circle_outline,
                    onPressed: () {
                      cubit.submitOrder();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
