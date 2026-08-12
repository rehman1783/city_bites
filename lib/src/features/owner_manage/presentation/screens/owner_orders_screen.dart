import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../bloc/owner_orders_bloc.dart';
import '../widgets/owner_order_card.dart';

class OwnerOrdersScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const OwnerOrdersScreen({
    super.key,
    this.onBack,
  });

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
        onBack: widget.onBack,
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
            return ResponsiveWrapper(
              maxWidth: 950,
              padding: EdgeInsets.zero,
              child: TabBarView(
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
              ),
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
          child: OwnerOrderCard(
            order: order,
            statusType: statusType,
            onUpdateStatus: (id, nextStatus) {
              context
                  .read<OwnerOrdersBloc>()
                  .updateOrderStatus(id, nextStatus);
            },
          ),
        );
      },
    );
  }
}
