import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/asset_paths.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/image_loader.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isCustomer = authState.role == UserRole.customer;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // User Info Card
                CustomCard(
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: const ClipOval(
                          child: ImageLoader(
                            imageUrl: AssetPaths.logoPlaceholder,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              authState.userName ?? 'Ali Raza',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              authState.userEmail ?? 'ali.raza@sahiwal.pk',
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isCustomer ? 'Customer Role' : 'Restaurant Owner',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Settings & Preferences Section
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      // Dark Mode Switch Tile
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        builder: (context, themeMode) {
                          final isDark = themeMode == ThemeMode.dark;
                          return SwitchListTile(
                            secondary: Icon(
                              isDark ? Icons.dark_mode : Icons.light_mode,
                              color: theme.colorScheme.primary,
                            ),
                            title: const Text('Dark Mode Theme'),
                            subtitle: Text(isDark ? 'Dark Theme Active' : 'Light Theme Active'),
                            value: isDark,
                            onChanged: (val) {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          );
                        },
                      ),
                      const Divider(height: 1),

                      // Order History Tile
                      ListTile(
                        leading: Icon(Icons.history, color: theme.colorScheme.primary),
                        title: const Text('Order History'),
                        subtitle: const Text('Past 14 orders in Sahiwal'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          _showOrderHistorySheet(context);
                        },
                      ),
                      const Divider(height: 1),

                      // Saved Addresses Tile
                      ListTile(
                        leading:
                            Icon(Icons.location_on_outlined, color: theme.colorScheme.primary),
                        title: const Text('Saved Delivery Addresses'),
                        subtitle: const Text('Scheme 3, College Road, High Street'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                      const Divider(height: 1),

                      // Switch Role Quick Button
                      ListTile(
                        leading: Icon(
                          isCustomer ? Icons.storefront : Icons.person_outline,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(
                          isCustomer
                              ? 'Switch to Restaurant Owner Portal'
                              : 'Switch to Customer View',
                        ),
                        trailing: const Icon(Icons.swap_horiz, size: 20),
                        onTap: () {
                          if (isCustomer) {
                            context.read<AuthCubit>().setRole(UserRole.restaurantOwner);
                            Navigator.of(context).pushReplacementNamed('/owner_dashboard');
                          } else {
                            context.read<AuthCubit>().setRole(UserRole.customer);
                            Navigator.of(context).pushReplacementNamed('/main');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Support & Information Card
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.headset_mic_outlined,
                            color: theme.colorScheme.primary),
                        title: const Text('Help & Support'),
                        subtitle: const Text('Sahiwal Helpline & FAQs'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Icon(Icons.privacy_tip_outlined,
                            color: theme.colorScheme.primary),
                        title: const Text('Privacy & Terms'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    Navigator.of(context).pushReplacementNamed('/auth');
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Logout Account', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showOrderHistorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Orders',
                style: Theme.of(sheetContext).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Royal Taj - 2x Chicken Biryani'),
                      subtitle: Text('Delivered to Scheme 3 • Rs. 840'),
                      trailing: Text('Yesterday'),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.check_circle, color: Colors.green),
                      title: Text('Pizza Haven - Large Pepperoni'),
                      subtitle: Text('Delivered to College Road • Rs. 1,450'),
                      trailing: Text('3 days ago'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
