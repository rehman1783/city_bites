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
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isCustomer = authState.role == UserRole.customer;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // User Info Card
                CustomCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 3,
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
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              authState.userEmail ?? 'ali.raza@sahiwal.pk',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withAlpha(160),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCustomer
                                        ? Icons.person_outline
                                        : Icons.storefront_outlined,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    isCustomer
                                        ? 'Customer Role'
                                        : 'Restaurant Owner',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Settings & Preferences',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

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
                            secondary: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isDark ? Icons.dark_mode : Icons.light_mode,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            title: const Text(
                              'Dark Mode',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              isDark
                                  ? 'Dark Theme Active'
                                  : 'Light Theme Active',
                            ),
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
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.history,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: const Text(
                          'Order History',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Past 14 orders in Sahiwal'),
                        trailing: const Icon(Icons.chevron_right, size: 22),
                        onTap: () {
                          _showOrderHistorySheet(context);
                        },
                      ),
                      const Divider(height: 1),

                      // Saved Addresses Tile
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: const Text(
                          'Saved Delivery Addresses',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          'Scheme 3, College Road, High Street',
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 22),
                        onTap: () {},
                      ),
                      const Divider(height: 1),

                      // Switch Role Quick Button
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isCustomer
                                ? Icons.storefront
                                : Icons.person_outline,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: Text(
                          isCustomer
                              ? 'Switch to Restaurant Owner Portal'
                              : 'Switch to Customer View',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.swap_horiz, size: 20),
                        onTap: () {
                          if (isCustomer) {
                            context.read<AuthCubit>().setRole(
                              UserRole.restaurantOwner,
                            );
                            Navigator.of(
                              context,
                            ).pushReplacementNamed('/owner_dashboard');
                          } else {
                            context.read<AuthCubit>().setRole(
                              UserRole.customer,
                            );
                            Navigator.of(context).pushReplacementNamed('/main');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Support & Information',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Support & Information Card
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.headset_mic_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: const Text(
                          'Help & Support',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text('Sahiwal Helpline & FAQs'),
                        trailing: const Icon(Icons.chevron_right, size: 22),
                        onTap: () {},
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.privacy_tip_outlined,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        title: const Text(
                          'Privacy & Terms',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: const Icon(Icons.chevron_right, size: 22),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Account Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () {
                    context.read<AuthCubit>().logout();
                    Navigator.of(context).pushReplacementNamed('/auth');
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text(
                    'Logout Account',
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side:  BorderSide(color:Colors.red.withAlpha(150)),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
                style: Theme.of(sheetContext).textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
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
