import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../bloc/owner_orders_bloc.dart';

class OwnerOrdersScreen extends StatefulWidget {
  const OwnerOrdersScreen({super.key});

  @override
  State<OwnerOrdersScreen> createState() => _OwnerOrdersScreenState();
}

class _OwnerOrdersScreenState extends State<OwnerOrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<OwnerOrdersBloc>().loadOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Management',
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: theme.colorScheme.primary,
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Pending (1)'),
            Tab(text: 'Preparing (1)'),
            Tab(text: 'Dispatched (1)'),
            Tab(text: 'Completed (1)'),
          ],
        ),
      ),
      body: BlocBuilder<OwnerOrdersBloc, OwnerOrdersState>(
        builder: (context, state) {
          if (state is OwnerOrdersLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OwnerOrdersLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildOrderList(context, state.pending, statusType: 'Pending'),
                _buildOrderList(context, state.preparing,
                    statusType: 'Preparing'),
                _buildOrderList(context, state.dispatched,
                    statusType: 'Dispatched'),
                _buildOrderList(context, state.completed,
                    statusType: 'Completed'),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildOrderList(
    BuildContext context,
    List<Map<String, dynamic>> orders, {
    required String statusType,
  }) {
    final theme = Theme.of(context);

    if (orders.isEmpty) {
      return Center(
        child: Text('No orders in $statusType'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id'],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order['time'],
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Customer: ${order['customer']} • ${order['address']}',
                  style: theme.textTheme.bodyMedium,
                ),
                const Divider(height: 16),
                Text(
                  'Ordered Items:',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ...(order['items'] as List).map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(item, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            order['paymentStatus'],
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PKR ${order['amount'].toInt()}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.print_outlined),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Printing Thermal Receipt...')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (statusType == 'Pending')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Reject'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<OwnerOrdersBloc>()
                                .updateOrderStatus(order['id'], 'Preparing');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Accept Order'),
                        ),
                      ),
                    ],
                  ),
                if (statusType == 'Preparing')
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        context
                            .read<OwnerOrdersBloc>()
                            .updateOrderStatus(order['id'], 'Dispatched');
                      },
                      icon: const Icon(Icons.two_wheeler),
                      label: const Text('Mark Ready / Dispatch Rider'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
