import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/features/admin_portal/presentation/bloc/admin_dashboard_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../widgets/admin_kpi_card.dart';

class AdminDashboardScreen extends StatelessWidget {
  final VoidCallback onNavigateToUsers;
  final VoidCallback onNavigateToApprovals;
  final VoidCallback onNavigateToOrders;
  final VoidCallback onNavigateToAnalytics;
  final VoidCallback onLogout;

  const AdminDashboardScreen({
    super.key,
    required this.onNavigateToUsers,
    required this.onNavigateToApprovals,
    required this.onNavigateToOrders,
    required this.onNavigateToAnalytics,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final crossCount = ResponsiveHelper.gridCrossAxisCount(context, mobile: 2, tablet: 2, desktop: 4);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Master Portal — Sahiwal Ops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: onLogout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text('Super Admin Ops'),
              accountEmail: const Text('admin@sahiwalfoodexpress.com'),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.security, size: 36, color: Colors.deepOrange),
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Dashboard'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('User Management'),
              onTap: () {
                Navigator.pop(context);
                onNavigateToUsers();
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_user_outlined),
              title: const Text('Vendor Approvals'),
              onTap: () {
                Navigator.pop(context);
                onNavigateToApprovals();
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text('Global Order Audit'),
              onTap: () {
                Navigator.pop(context);
                onNavigateToOrders();
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics_outlined),
              title: const Text('Analytics & Density Heatmap'),
              onTap: () {
                Navigator.pop(context);
                onNavigateToAnalytics();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout Console', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onLogout();
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
        builder: (context, state) {
          if (state is AdminDashboardLoaded) {
            return ResponsiveWrapper(
              maxWidth: 1100,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Platform Overview',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Top Metrics Grid
                    GridView.count(
                      crossAxisCount: crossCount,
                      shrinkWrap: true,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        AdminKpiCard(
                          title: 'Platform GMV',
                          value: 'PKR 4.2M',
                          icon: Icons.account_balance_wallet,
                          color: theme.colorScheme.primary,
                        ),
                        AdminKpiCard(
                          title: 'Total Sahiwal Orders',
                          value: '${state.totalOrders}',
                          icon: Icons.shopping_bag,
                          color: theme.colorScheme.primary,
                        ),
                        AdminKpiCard(
                          title: 'Active Vendors',
                          value: '${state.activeRestaurants}',
                          icon: Icons.storefront,
                          color: theme.colorScheme.secondary,
                        ),
                        AdminKpiCard(
                          title: 'Registered Users',
                          value: '18.5k',
                          icon: Icons.group,
                          color: theme.colorScheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Real-time System Health Indicators
                    Text(
                      'System Health & Live Monitoring',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Active Live Orders'),
                              Text(
                                '${state.activeLiveOrders} Active',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Active Riders in Fleet'),
                              Text(
                                '${state.activeRiders} Riders',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('API Latency'),
                              Text(
                                '42 ms (Healthy)',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Admin Actions Quick Grid
                    Text(
                      'Admin Action Modules',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      tileColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Icon(Icons.people, color: theme.colorScheme.primary),
                      title: const Text('User Management'),
                      subtitle: const Text('View customer accounts and block/unblock controls'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onNavigateToUsers,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      tileColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Icon(Icons.verified_user, color: theme.colorScheme.secondary),
                      title: const Text('Vendor Approvals'),
                      subtitle: const Text('Review license applications & set commission rates'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onNavigateToApprovals,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      tileColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: const Icon(Icons.receipt_long, color: Colors.orange),
                      title: const Text('Global Order Audit'),
                      subtitle: const Text('Audit all platform orders and handle disputes'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onNavigateToOrders,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      tileColor: theme.colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: const Icon(Icons.map, color: Colors.purple),
                      title: const Text('Analytics & Regional Density Heatmap'),
                      subtitle: const Text('Sahiwal traffic and SLA leaderboard'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: onNavigateToAnalytics,
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
