import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../bloc/owner_dashboard_cubit.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Restaurant Portal',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: BlocBuilder<OwnerDashboardCubit, OwnerDashboardState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Restaurant Header Card
                CustomCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.storefront_rounded,
                          size: 32,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Royal Taj Restaurant',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Scheme 3, College Road, Sahiwal',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: const Text(
                          'OPEN',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Stats Cards Row
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: "Today's Orders",
                        value: '${state.totalOrdersToday}',
                        icon: Icons.receipt_long,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'Revenue Today',
                        value: '${AppConstants.currency} ${state.revenueToday.toInt()}',
                        icon: Icons.payments_outlined,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        title: 'Active Items',
                        value: '${state.activeItemsCount} / ${state.menuItems.length}',
                        icon: Icons.restaurant_menu,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Quick Action Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu Inventory (${state.menuItems.length})',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddMenuItemDialog(context);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Item'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Menu Items Availability List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = state.menuItems[index];

                    return CustomCard(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ImageLoader(
                            imageUrl: item.imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            borderRadius: 12,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${item.category} • ${AppConstants.currency} ${item.price.toInt()}',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Availability Switch
                          Column(
                            children: [
                              Text(
                                item.isAvailable ? 'In Stock' : 'Sold Out',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: item.isAvailable ? Colors.green : Colors.red,
                                ),
                              ),
                              Switch(
                                value: item.isAvailable,
                                activeThumbColor: theme.colorScheme.primary,
                                onChanged: (val) {
                                  context
                                      .read<OwnerDashboardCubit>()
                                      .toggleItemAvailability(item.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Switch View Button
                CustomButton(
                  text: 'Switch to Customer View',
                  type: CustomButtonType.outline,
                  icon: Icons.swap_horiz,
                  onPressed: () {
                    context.read<AuthCubit>().setRole(UserRole.customer);
                    Navigator.of(context).pushReplacementNamed('/main');
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMenuItemDialog(BuildContext context) {
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final categoryController = TextEditingController(text: 'Biryani');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add New Menu Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: titleController,
                labelText: 'Dish Title',
                hintText: 'e.g. Special Beef Karahi',
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: priceController,
                labelText: 'Price (Rs.)',
                hintText: 'e.g. 850',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: categoryController,
                labelText: 'Category',
                hintText: 'e.g. Karahi, Pizza, Burgers',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  context.read<OwnerDashboardCubit>().addNewMenuItem(
                        titleController.text,
                        price,
                        categoryController.text,
                      );
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add Item'),
            ),
          ],
        );
      },
    );
  }
}
