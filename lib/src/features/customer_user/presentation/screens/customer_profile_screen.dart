import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/theme/theme_cubit.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/image_loader.dart';
import 'package:city_bites/src/features/auth/presentation/bloc/auth_cubit.dart';
import '../bloc/profile_bloc.dart';

class CustomerProfileScreen extends StatelessWidget {
  final VoidCallback onNavigateToOrders;
  final VoidCallback onLogout;

  const CustomerProfileScreen({
    super.key,
    required this.onNavigateToOrders,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'My Profile & Settings',
        showBackButton: false,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // User Header Card
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: NetworkImageLoader(
                            imageUrl: state.avatarUrl,
                            width: 70,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                state.email,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                state.phone,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Tile Group
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // Dark Mode Switch
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, mode) {
                            final isDark = mode == ThemeMode.dark;
                            return SwitchListTile(
                              secondary: Icon(
                                isDark
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                                color: theme.colorScheme.primary,
                              ),
                              title: const Text('Dark Mode'),
                              subtitle: Text(
                                isDark
                                    ? 'Switch to Light theme'
                                    : 'Switch to Dark theme',
                              ),
                              value: isDark,
                              onChanged: (val) {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            );
                          },
                        ),
                        const Divider(height: 1),

                        ListTile(
                          leading: Icon(
                            Icons.receipt_long_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          title: const Text('My Orders'),
                          subtitle: const Text('Track active orders & history'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: onNavigateToOrders,
                        ),
                        const Divider(height: 1),

                        ListTile(
                          leading: Icon(
                            Icons.location_on_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          title: const Text('Saved Addresses'),
                          subtitle: Text(state.address, maxLines: 1),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                        const Divider(height: 1),

                        ListTile(
                          leading: Icon(
                            Icons.headset_mic_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          title: const Text('Help & Sahiwal Support'),
                          subtitle: const Text('Live support 10am - 10pm'),
                          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout Tile Card
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        Icons.logout,
                        color: theme.colorScheme.error,
                      ),
                      title: Text(
                        'Logout',
                        style: TextStyle(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        context.read<AuthCubit>().logout();
                        onLogout();
                      },
                    ),
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
