import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_textfield.dart';
import 'package:city_bites/src/features/admin_portal/presentation/bloc/admin_users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/responsive_wrapper.dart';
import '../widgets/admin_user_tile.dart';

class AdminUsersScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const AdminUsersScreen({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'User Management',
        onBack: onBack,
      ),
      body: BlocBuilder<AdminUsersBloc, AdminUsersState>(
        builder: (context, state) {
          if (state is AdminUsersLoaded) {
            final filtered = state.users.where((u) {
              if (state.activeRoleFilter == 'All') return true;
              return u['role'] == state.activeRoleFilter;
            }).toList();

            return ResponsiveWrapper(
              maxWidth: 950,
              padding: EdgeInsets.zero,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CustomTextField(
                      labelText: '',
                      hintText: 'Search user by name, email, or phone...',
                      prefixIcon: Icons.search,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ['All', 'Customer', 'Owner', 'Rider'].map((role) {
                          final isSelected = state.activeRoleFilter == role;
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ChoiceChip(
                              label: Text(role),
                              selected: isSelected,
                              selectedColor: theme.colorScheme.primary,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              onSelected: (_) {
                                context
                                    .read<AdminUsersBloc>()
                                    .setRoleFilter(role);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final user = filtered[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AdminUserTile(
                            user: user,
                            onToggleBlock: () {
                              context
                                  .read<AdminUsersBloc>()
                                  .toggleBlockUser(user['id']);
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
