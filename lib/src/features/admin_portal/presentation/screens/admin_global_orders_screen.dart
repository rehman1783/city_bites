import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:city_bites/src/features/admin_portal/presentation/bloc/admin_orders_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../widgets/admin_global_order_tile.dart';

class AdminGlobalOrdersScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const AdminGlobalOrdersScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Global Order Audit',
        onBack: onBack,
      ),
      body: BlocBuilder<AdminOrdersBloc, AdminOrdersState>(
        builder: (context, state) {
          if (state is AdminOrdersLoaded) {
            return ResponsiveWrapper(
              maxWidth: 950,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
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

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AdminGlobalOrderTile(
                            order: order,
                            onForceCancel: () {
                              context
                                  .read<AdminOrdersBloc>()
                                  .forceCancelOrder(order['id']);
                            },
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
