import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/responsive_wrapper.dart';
import '../bloc/owner_menu_bloc.dart';
import '../widgets/owner_menu_item_tile.dart';

class OwnerMenuManagementScreen extends StatefulWidget {
  final VoidCallback onAddNewItem;
  final VoidCallback? onBack;

  const OwnerMenuManagementScreen({
    super.key,
    required this.onAddNewItem,
    this.onBack,
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
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Menu Management',
        onBack: widget.onBack,
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
            return ResponsiveWrapper(
              maxWidth: 950,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
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

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: OwnerMenuItemTile(
                            item: item,
                            onToggleAvailability: (val) {
                              context
                                  .read<OwnerMenuBloc>()
                                  .toggleAvailability(item['id'], val);
                            },
                            onDelete: () {
                              context
                                  .read<OwnerMenuBloc>()
                                  .deleteItem(item['id']);
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
