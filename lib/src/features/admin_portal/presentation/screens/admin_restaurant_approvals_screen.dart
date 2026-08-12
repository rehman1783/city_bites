import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/features/admin_portal/presentation/bloc/admin_approvals_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../widgets/admin_vendor_card.dart';

class AdminRestaurantApprovalsScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const AdminRestaurantApprovalsScreen({
    super.key,
    this.onBack,
  });

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
        onBack: widget.onBack,
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
            return ResponsiveWrapper(
              maxWidth: 950,
              padding: EdgeInsets.zero,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVendorList(context, state.pending, isPending: true),
                  _buildVendorList(context, state.active, isPending: false),
                  _buildVendorList(context, state.suspended, isPending: false),
                ],
              ),
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
          child: AdminVendorCard(
            vendor: v,
            isPending: isPending,
            onApprove: () {
              context.read<AdminApprovalsBloc>().approveVendor(v['id']);
            },
            onReject: () {
              context.read<AdminApprovalsBloc>().rejectVendor(v['id']);
            },
          ),
        );
      },
    );
  }
}
