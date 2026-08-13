import 'package:city_bites/src/core/theme/theme_cubit.dart';
import 'package:city_bites/src/core/widgets/custom_appbar.dart';
import 'package:city_bites/src/core/widgets/custom_card.dart';
import 'package:city_bites/src/core/widgets/responsive_wrapper.dart';
import 'package:city_bites/src/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:city_bites/src/features/customer_user/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/profile_user_header_card.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'favorites_screen.dart';
import 'privacy_policy_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/order_history_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/order_status_screen.dart';

class CustomerProfileScreen extends StatefulWidget {
  final VoidCallback onNavigateToOrders;
  final VoidCallback onLogout;

  const CustomerProfileScreen({
    super.key,
    required this.onNavigateToOrders,
    required this.onLogout,
  });

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool> onSystemBackPressed() async {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      await refreshAndScrollToTop();
      return true;
    }
    return false;
  }

  Future<void> refreshAndScrollToTop() async {
    // Profile is mostly static in this demo; rebuild to simulate full refresh
    setState(() {});
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

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
            return ResponsiveWrapper(
              maxWidth: 800,
              padding: EdgeInsets.zero,
              child: RefreshIndicator(
                onRefresh: () async {
                  await refreshAndScrollToTop();
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Profile Header Card
                      ProfileUserHeaderCard(
                        name: state.name,
                        email: state.email,
                        phone: state.phone,
                      ),
                      const SizedBox(height: 24),

                      // Section 1: Account Information & Saved Addresses
                      Text(
                        'Account Information',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
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
                                icon: Icons.history_rounded,
                              ),
                              title: const Text('Order History'),
                              subtitle: const Text(
                                'View past receipts and orders',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const OrderHistoryScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconContainer(
                                theme,
                                icon: Icons.receipt_long_rounded,
                              ),
                              title: const Text('Order Status'),
                              subtitle: const Text('Track active orders'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const OrderStatusScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconContainer(
                                theme,
                                icon: Icons.location_on_rounded,
                              ),
                              title: const Text('Saved Sahiwal Addresses'),
                              subtitle: Text(state.address, maxLines: 1),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Default Delivery Location: Scheme 3, Sahiwal',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconContainer(
                                theme,
                                icon: Icons.favorite_rounded,
                              ),
                              title: const Text('Favorites'),
                              subtitle: const Text('Products & Restaurants'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const FavoritesScreen(),
                                  ),
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
                          color: theme.colorScheme.primary,
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
                                  activeTrackColor: theme.colorScheme.primary,
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
                                        : 'Switch to Deep Charcoal dark theme',
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
                          color: theme.colorScheme.primary,
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
                              subtitle: const Text(
                                'Available 10 AM - 10 PM daily',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Support Hotline: 040-1234567',
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconContainer(
                                theme,
                                icon: Icons.info_outline_rounded,
                              ),
                              title: const Text('About Us'),
                              subtitle: const Text(
                                'Learn more about City Bites',
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AboutUsScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconContainer(
                                theme,
                                icon: Icons.mail_outline_rounded,
                              ),
                              title: const Text('Contact Us'),
                              subtitle: const Text('Reach our support team'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ContactUsScreen(),
                                  ),
                                );
                              },
                            ),
                            const Divider(height: 1),
                            ListTile(
                              leading: _buildIconContainer(
                                theme,
                                icon: Icons.privacy_tip_outlined,
                              ),
                              title: const Text('Privacy & Policy'),
                              subtitle: const Text('Read our privacy terms'),
                              trailing: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 14,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PrivacyPolicyScreen(),
                                  ),
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
                            widget.onLogout();
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
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
        color: theme.colorScheme.primary.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: theme.colorScheme.primary, size: 20),
    );
  }
}
