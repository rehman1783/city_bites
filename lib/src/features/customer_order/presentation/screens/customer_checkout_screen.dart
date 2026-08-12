import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../bloc/checkout_bloc.dart';
import '../widgets/checkout_address_card.dart';
import '../widgets/checkout_payment_card.dart';

class CustomerCheckoutScreen extends StatefulWidget {
  final VoidCallback onOrderPlaced;
  final VoidCallback? onBack;
  final List<Map<String, dynamic>>? previewItems;

  const CustomerCheckoutScreen({
    super.key,
    required this.onOrderPlaced,
    this.onBack,
    this.previewItems,
  });

  @override
  State<CustomerCheckoutScreen> createState() => _CustomerCheckoutScreenState();
}

class _CustomerCheckoutScreenState extends State<CustomerCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController(
    text: '+92 300 1234567',
  );
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => CheckoutBloc(),
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Checkout Confirmation',
          onBack: widget.onBack,
        ),
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is OrderSuccess) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogCtx) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  title: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondary.withAlpha(30),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: theme.colorScheme.secondary,
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Order Confirmed!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  content: Text(
                    'Order #${state.orderId} has been sent to the restaurant in Sahiwal. Track live status now!',
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogCtx);
                        widget.onOrderPlaced();
                      },
                      child: const Text('Track Order Status'),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<CheckoutBloc>();
            final isPlacing = state is OrderPlacing;

            return Form(
              key: _formKey,
              child: ResponsiveWrapper(
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
                            // Address Selection Custom Widget
                            CheckoutAddressCard(
                              selectedAddress: state.selectedAddress,
                              onAddressSelected: (addr) =>
                                  cubit.selectAddress(addr),
                            ),
                            const SizedBox(height: 20),

                            // Contact & Instructions Input
                            Text(
                              'Contact & Rider Instructions',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextField(
                              controller: _phoneController,
                              labelText: 'Phone Number',
                              hintText: 'e.g. +92 300 1234567',
                              prefixIcon: Icons.phone_android_rounded,
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Please enter a contact phone number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _notesController,
                              labelText: 'Delivery Notes (Optional)',
                              hintText: 'e.g. Leave at gate, ring bell twice',
                              prefixIcon: Icons.notes_rounded,
                            ),
                            const SizedBox(height: 24),

                            // Payment Method Custom Widget
                            CheckoutPaymentCard(
                              selectedPaymentMethod:
                                  state.selectedPaymentMethod,
                              onPaymentMethodSelected: (pm) =>
                                  cubit.selectPaymentMethod(pm),
                            ),
                            const SizedBox(height: 24),

                            // Order Items Preview Box
                            ExpansionTile(
                              title: Text(
                                'View Order Breakdown',
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
                                      if ((widget.previewItems ?? [])
                                          .isNotEmpty)
                                        ...widget.previewItems!.map((it) {
                                          final qty = it['quantity'] ?? 1;
                                          final name = it['name'] ?? '';
                                          final price =
                                              ((it['price'] ?? 0) * qty)
                                                  .toInt();
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 6,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('${qty}x $name'),
                                                Text(
                                                  'PKR $price',
                                                  style: theme
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList()
                                      else ...[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '2x Special Chicken Biryani',
                                            ),
                                            Text(
                                              'PKR 900',
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '1x Crispy Zinger Burger',
                                            ),
                                            Text(
                                              'PKR 380',
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Delivery & Platform Fee',
                                            ),
                                            Text(
                                              'PKR 80',
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ],
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
                        text: 'Confirm & Place Order — PKR 1,180',
                        isLoading: isPlacing,
                        icon: Icons.check_circle_outline,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? true) {
                            cubit.submitOrder();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
