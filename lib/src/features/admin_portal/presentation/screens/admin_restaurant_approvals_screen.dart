import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../bloc/admin_approvals_bloc.dart';

class AdminRestaurantApprovalsScreen extends StatefulWidget {
  const AdminRestaurantApprovalsScreen({super.key});

  @override
  State<AdminRestaurantApprovalsScreen> createState() =>
      _AdminRestaurantApprovalsScreenState();
}

class _AdminRestaurantApprovalsScreenState
    extends State<AdminRestaurantApprovalsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: 'Vendor Approvals',
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Active Vendors'),
            Tab(text: 'Suspended'),
          ],
        ),
      ),
      body: BlocBuilder<AdminApprovalsBloc, AdminApprovalsState>(
        builder: (context, state) {
          if (state is AdminApprovalsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildVendorList(context, state.pending, isPending: true),
                _buildVendorList(context, state.active, isPending: false),
                _buildVendorList(context, state.suspended, isPending: false),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildVendorList(
    BuildContext context,
    List<Map<String, dynamic>> vendors, {
    required bool isPending,
  }) {
    final theme = Theme.of(context);

    if (vendors.isEmpty) {
      return const Center(child: Text('No vendors in this queue.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final v = vendors[index];
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
                      v['name'],
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Commission: ${v['commissionRate']}%',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Owner: ${v['ownerName']} (CNIC: ${v['cnic']})',
                  style: theme.textTheme.bodyMedium,
                ),
                Text(
                  'Location: ${v['address']}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.verified_outlined,
                        size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      'License Document Verified',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (isPending)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context
                                .read<AdminApprovalsBloc>()
                                .rejectVendor(v['id']);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Reject Application'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<AdminApprovalsBloc>()
                                .approveVendor(v['id']);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text('Approve Restaurant'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
