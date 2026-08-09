import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import '../bloc/owner_menu_bloc.dart';

class OwnerMenuManagementScreen extends StatefulWidget {
  final VoidCallback onAddNewItem;

  const OwnerMenuManagementScreen({
    super.key,
    required this.onAddNewItem,
  });

  @override
  State<OwnerMenuManagementScreen> createState() =>
      _OwnerMenuManagementScreenState();
}

class _OwnerMenuManagementScreenState
    extends State<OwnerMenuManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OwnerMenuBloc>().fetchMenu();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Menu Management',
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: widget.onAddNewItem,
        icon: const Icon(Icons.add),
        label: const Text('Add Food Item'),
      ),
      body: BlocBuilder<OwnerMenuBloc, OwnerMenuState>(
        builder: (context, state) {
          if (state is OwnerMenuLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OwnerMenuLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CustomTextField(
                    labelText: '',
                    hintText: 'Search menu items...',
                    prefixIcon: Icons.search,
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.menuItems.length,
                    itemBuilder: (context, index) {
                      final item = state.menuItems[index];
                      final isAvailable = item['isAvailable'] as bool;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: NetworkImageLoader(
                                  imageUrl: item['image'],
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Category: ${item['category']}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'PKR ${item['price'].toInt()}',
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Switch(
                                    value: isAvailable,
                                    activeThumbColor: Colors.green,
                                    onChanged: (val) {
                                      context
                                          .read<OwnerMenuBloc>()
                                          .toggleAvailability(item['id'], val);
                                    },
                                  ),
                                  Text(
                                    isAvailable ? 'In Stock' : 'Out of Stock',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                onSelected: (action) {
                                  if (action == 'delete') {
                                    context
                                        .read<OwnerMenuBloc>()
                                        .deleteItem(item['id']);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit Dish'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text(
                                      'Delete Item',
                                      style: TextStyle(color: Colors.red),
                                    ),
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
