import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../bloc/admin_orders_bloc.dart';

class AdminGlobalOrdersScreen extends StatelessWidget {
  const AdminGlobalOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Global Order Audit',
      ),
      body: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
        builder: (context, state) {
          if (state is AdminOrdersLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CustomTextField(
                    labelText: '',
                    hintText: 'Filter by Order ID, Restaurant, or Customer...',
                    prefixIcon: Icons.search,
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.globalOrders.length,
                    itemBuilder: (context, index) {
                      final order = state.globalOrders[index];
                      final isCancelled =
                          order['status'].toString().contains('Cancelled');

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order['id'],
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isCancelled
                                          ? Colors.red.withAlpha(40)
                                          : theme.colorScheme.secondary
                                              .withAlpha(40),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      order['status'],
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: isCancelled
                                            ? Colors.red
                                            : theme.colorScheme.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Restaurant: ${order['restaurant']}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              Text(
                                'Customer: ${order['customer']} • Date: ${order['date']}',
                                style: theme.textTheme.bodySmall,
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Amount: PKR ${order['amount'].toInt()}',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (!isCancelled)
                                    OutlinedButton(
                                      onPressed: () {
                                        context
                                            .read<AdminOrdersBloc>()
                                            .forceCancelOrder(order['id']);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side:
                                            const BorderSide(color: Colors.red),
                                      ),
                                      child: const Text('Force Cancel'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
