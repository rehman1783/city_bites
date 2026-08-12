import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../bloc/owner_dashboard_bloc.dart';
import '../widgets/owner_stat_card.dart';

class OwnerDashboardScreen extends StatefulWidget {
  final VoidCallback onNavigateToMenu;
  final VoidCallback onNavigateToOrders;
  final VoidCallback onNavigateToAnalytics;
  final VoidCallback onLogout;

  const OwnerDashboardScreen({
    super.key,
    required this.onNavigateToMenu,
    required this.onNavigateToOrders,
    required this.onNavigateToAnalytics,
    required this.onLogout,
  });

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerDashboardBloc>().fetchDashboardMetrics();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text(
            'Are you sure you want to log out of the Royal Taj Owner Console?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogCtx);
              widget.onLogout();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crossCount = ResponsiveHelper.gridCrossAxisCount(context, mobile: 2, tablet: 2, desktop: 4);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'Royal Taj Restaurant & Bakers',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Sahiwal Branch Console',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          BlocBuilder<OwnerDashboardBloc, OwnerDashboardState>(
            builder: (context, state) {
              final isOpen =
                  state is DashboardLoaded ? state.isStoreOpen : true;
              return Row(
                children: [
                  Text(
                    isOpen ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isOpen ? Colors.green : Colors.red,
                    ),
                  ),
                  Switch(
                    value: isOpen,
                    activeThumbColor: Colors.green,
                    onChanged: (val) {
                      context
                          .read<OwnerDashboardBloc>()
                          .toggleStoreStatus(val);
                    },
                  ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Logout Owner Session',
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: BlocBuilder<OwnerDashboardBloc, OwnerDashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DashboardLoaded) {
            return ResponsiveWrapper(
              maxWidth: 1100,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 4 Summary Metrics Grid
                    GridView.count(
                      crossAxisCount: crossCount,
                      shrinkWrap: true,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.35,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        OwnerStatCard(
                          title: "Today's Sales",
                          value: 'PKR ${state.todaySales.toInt()}',
                          icon: Icons.payments_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        OwnerStatCard(
                          title: "Today's Orders",
                          value: '${state.todayOrders}',
                          icon: Icons.shopping_bag_outlined,
                          color: theme.colorScheme.primary,
                        ),
                        OwnerStatCard(
                          title: 'Active Items',
                          value: '${state.activeItems}',
                          icon: Icons.restaurant_menu,
                          color: theme.colorScheme.secondary,
                        ),
                        OwnerStatCard(
                          title: 'Pending Alerts',
                          value: '${state.pendingAlerts}',
                          icon: Icons.notifications_active_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions Row
                    Text(
                      'Quick Operations',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: 'Menu',
                            icon: Icons.menu_book,
                            onPressed: widget.onNavigateToMenu,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomButton(
                            text: 'Orders',
                            type: CustomButtonType.secondary,
                            icon: Icons.list_alt,
                            onPressed: widget.onNavigateToOrders,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomButton(
                            text: 'Analytics',
                            type: CustomButtonType.outline,
                            icon: Icons.bar_chart,
                            onPressed: widget.onNavigateToAnalytics,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Live Incoming Orders Queue
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Live Incoming Orders Queue',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(40),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${state.pendingOrders.length} New',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    if (state.pendingOrders.isEmpty)
                      const CustomCard(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: Text('No pending orders right now.'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.pendingOrders.length,
                        itemBuilder: (context, index) {
                          final order = state.pendingOrders[index];
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
                                      Text(
                                        order['time'],
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Customer: ${order['customer']} (${order['address']})',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    order['items'],
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total: PKR ${order['amount'].toInt()}',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          OutlinedButton(
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              foregroundColor: Colors.red,
                                              side: const BorderSide(
                                                  color: Colors.red),
                                            ),
                                            child: const Text('Reject'),
                                          ),
                                          const SizedBox(width: 8),
                                          ElevatedButton(
                                            onPressed: () {
                                              context
                                                  .read<OwnerDashboardBloc>()
                                                  .acceptOrder(order['id']);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                            ),
                                            child: const Text('Accept'),
                                          ),
                                        ],
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
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
