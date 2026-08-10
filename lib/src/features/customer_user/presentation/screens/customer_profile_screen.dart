import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/core/theme/theme_cubit.dart';
import 'package:city_bites/src/core/widgets/app_logo.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
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
        title: 'Account Settings',
        showBackButton: false,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Card
                  CustomCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const AppLogo(
                          size: 64,
                          borderRadius: 16,
                          showShadow: false,
                          showBorder: true,
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

                  // Section 1: Account Information & Saved Addresses
                  Text(
                    'Account Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: _buildIconContainer(
                            theme,
                            icon: Icons.receipt_long_rounded,
                          ),
                          title: const Text('Order History & Status'),
                          subtitle: const Text('Track active orders & past receipts'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: onNavigateToOrders,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: _buildIconContainer(
                            theme,
                            icon: Icons.location_on_rounded,
                          ),
                          title: const Text('Saved Sahiwal Addresses'),
                          subtitle: Text(state.address, maxLines: 1),
                          trailing:
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Default Delivery Location: Scheme 3, Sahiwal')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 2: App Preferences
                  Text(
                    'Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        BlocBuilder<ThemeCubit, ThemeMode>(
                          builder: (context, mode) {
                            final isDark = mode == ThemeMode.dark;
                            return SwitchListTile(
                              secondary: _buildIconContainer(
                                theme,
                                icon: isDark
                                    ? Icons.dark_mode_rounded
                                    : Icons.light_mode_rounded,
                              ),
                              title: const Text('Dark Theme Mode'),
                              subtitle: Text(
                                isDark
                                    ? 'Switch to Light soft-white theme'
                                    : 'Switch to Deep Navy dark theme',
                              ),
                              value: isDark,
                              onChanged: (val) {
                                context.read<ThemeCubit>().toggleTheme();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 3: Support & Help
                  Text(
                    'Support & Info',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        ListTile(
                          leading: _buildIconContainer(
                            theme,
                            icon: Icons.headset_mic_rounded,
                          ),
                          title: const Text('Sahiwal Help & Customer Care'),
                          subtitle: const Text('Available 10 AM - 10 PM daily'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Support Hotline: 040-1234567')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section 4: Logout
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withAlpha(25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.logout_rounded,
                          color: theme.colorScheme.error,
                          size: 20,
                        ),
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
                  const SizedBox(height: 32),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildIconContainer(ThemeData theme, {required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: theme.colorScheme.secondary,
        size: 20,
      ),
    );
  }
}
