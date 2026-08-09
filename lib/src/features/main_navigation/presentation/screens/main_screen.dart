import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/custom_badge.dart';
import '../../../cart/presentation/bloc/cart_cubit.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../customer_home/presentation/screens/customer_home_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Widget> screens = [
      CustomerHomeScreen(
        onNavigateTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: theme.colorScheme.primary,
            unselectedItemColor: theme.colorScheme.onSurfaceVariant,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: CustomBadge(
                  count: cartState.totalItemCount,
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
                activeIcon: CustomBadge(
                  count: cartState.totalItemCount,
                  child: const Icon(Icons.shopping_bag),
                ),
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}
