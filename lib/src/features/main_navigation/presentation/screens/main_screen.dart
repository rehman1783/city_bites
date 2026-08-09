import 'package:flutter/material.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/customer_home_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/food_details_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/restaurant_details_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_cart_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_checkout_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_order_tracking_screen.dart';
import 'package:city_bites/src/features/customer_user/presentation/screens/customer_profile_screen.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({
    super.key,
    required this.onLogout,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _selectedRestaurant;
  Map<String, dynamic>? _selectedDish;
  bool _isCheckingOut = false;
  String? _trackingOrderId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Deep sub-route overlays inside customer flow
    if (_trackingOrderId != null) {
      return CustomerOrderTrackingScreen(
        orderId: _trackingOrderId!,
        onBackToHome: () {
          setState(() {
            _trackingOrderId = null;
            _currentIndex = 0;
          });
        },
      );
    }

    if (_isCheckingOut) {
      return CustomerCheckoutScreen(
        onBack: () {
          setState(() {
            _isCheckingOut = false;
          });
        },
        onOrderPlaced: () {
          setState(() {
            _isCheckingOut = false;
            _trackingOrderId = 'ORD-SHW-9482';
          });
        },
      );
    }

    if (_selectedDish != null) {
      return FoodDetailsScreen(
        dish: _selectedDish!,
        onBack: () {
          setState(() {
            _selectedDish = null;
          });
        },
        onAddToCart: (item) {
          setState(() {
            _selectedDish = null;
            _currentIndex = 1; // Navigate to cart
          });
        },
      );
    }

    if (_selectedRestaurant != null) {
      return RestaurantDetailsScreen(
        restaurant: _selectedRestaurant!,
        onBack: () {
          setState(() {
            _selectedRestaurant = null;
          });
        },
        onSelectDish: (dish) {
          setState(() {
            _selectedDish = dish;
          });
        },
      );
    }

    // Main Tab Screens
    final List<Widget> screens = [
      CustomerHomeScreen(
        onSelectRestaurant: (rest) {
          setState(() {
            _selectedRestaurant = rest;
          });
        },
        onOpenCart: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      CustomerCartScreen(
        onProceedToCheckout: () {
          setState(() {
            _isCheckingOut = true;
          });
        },
      ),
      CustomerOrderTrackingScreen(
        orderId: 'ORD-SHW-9482',
        onBackToHome: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      CustomerProfileScreen(
        onNavigateToOrders: () {
          setState(() {
            _currentIndex = 2;
          });
        },
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _selectedRestaurant = null;
            _selectedDish = null;
            _isCheckingOut = false;
            _trackingOrderId = null;
          });
        },
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.two_wheeler_outlined),
            activeIcon: Icon(Icons.two_wheeler),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
