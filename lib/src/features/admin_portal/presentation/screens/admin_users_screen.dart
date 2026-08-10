import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../bloc/admin_users_bloc.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'User Management',
      ),
      body: BlocBuilder<AdminUsersBloc, AdminUsersState>(
        builder: (context, state) {
          if (state is AdminUsersLoaded) {
            final filtered = state.users.where((u) {
              if (state.activeRoleFilter == 'All') return true;
              return u['role'] == state.activeRoleFilter;
            }).toList();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const CustomTextField(
                    labelText: '',
                    hintText: 'Search user by name, email, or phone...',
                    prefixIcon: Icons.search,
                  ),
                  const SizedBox(height: 16),
                  Row(
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
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final user = filtered[index];
                      final isBlocked = user['status'] == 'Blocked';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CustomCard(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: isBlocked
                                    ? theme.colorScheme.error.withAlpha(40)
                                    : theme.colorScheme.primary.withAlpha(40),
                                child: Icon(
                                  user['role'] == 'Owner'
                                      ? Icons.storefront
                                      : user['role'] == 'Rider'
                                          ? Icons.two_wheeler
                                          : Icons.person,
                                  color: isBlocked
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          user['name'],
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: theme.colorScheme
                                                .surfaceContainerHighest,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            user['role'],
                                            style: theme.textTheme.labelSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      user['contact'],
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    Text(
                                      'Registered: ${user['regDate']}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<AdminUsersBloc>()
                                      .toggleBlockUser(user['id']);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isBlocked
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.error,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                ),
                                child: Text(
                                  isBlocked ? 'Unblock' : 'Block',
                                  style: const TextStyle(fontSize: 12),
                                ),
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
