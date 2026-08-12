import 'package:flutter/material.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/customer_home_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/restaurants_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/explore_screen.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/food_details_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'package:city_bites/src/core/widgets/snackbar_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:city_bites/src/features/customer_food/presentation/screens/restaurant_details_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_cart_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_checkout_screen.dart';
import 'package:city_bites/src/features/customer_order/presentation/screens/customer_order_tracking_screen.dart';
import 'package:city_bites/src/features/customer_user/presentation/screens/customer_profile_screen.dart';

class MainScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const MainScreen({super.key, required this.onLogout});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? _selectedRestaurant;
  Map<String, dynamic>? _selectedDish;
  bool _isCheckingOut = false;
  String? _trackingOrderId;
  List<Map<String, dynamic>>? _checkoutPreviewItems;

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
        previewItems: _checkoutPreviewItems,
        onBack: () {
          setState(() {
            _isCheckingOut = false;
            _checkoutPreviewItems = null;
          });
        },
        onOrderPlaced: () {
          setState(() {
            _isCheckingOut = false;
            _checkoutPreviewItems = null;
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
          try {
            context.read<CartBloc>().addItem(item);
          } catch (_) {}
          showAppSnackBar(context, '${item['name']} added to cart');
        },
        onBuyNow: (item) {
          setState(() {
            _selectedDish = null;
            _isCheckingOut = true;
            _checkoutPreviewItems = [
              {
                'id': item['id'],
                'name': item['name'],
                'price': item['price'] ?? 0,
                'quantity': item['quantity'] ?? 1,
                'image': item['image'] ?? '',
              },
            ];
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

    // Main Tab Screens: Home, Restaurants, Explore, Cart, Profile
    final List<Widget> screens = [
      CustomerHomeScreen(
        onSelectRestaurant: (rest) {
          setState(() {
            _selectedRestaurant = rest;
          });
        },
        onOpenCart: () {
          setState(() {
            _currentIndex = 3;
          });
        },
      ),

      // Restaurants tab: dedicated RestaurantsScreen (no header/banner/categories)
      RestaurantsScreen(
        onSelectRestaurant: (rest) {
          setState(() {
            _selectedRestaurant = rest;
          });
        },
        onOpenCart: () {
          setState(() {
            _currentIndex = 3;
          });
        },
      ),

      ExploreScreen(
        onSelectRestaurant: (rest) {
          setState(() {
            _selectedRestaurant = rest;
          });
        },
        onSelectDish: (dish) {
          setState(() {
            _selectedDish = dish;
          });
        },
        onOpenCart: () {
          setState(() {
            _currentIndex = 3;
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

      CustomerProfileScreen(
        onNavigateToOrders: () {
          // Push the orders/tracking screen from profile instead of a bottom tab
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CustomerOrderTrackingScreen(
                orderId: 'ORD-SHW-9482',
                onBackToHome: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
            ),
          );
        },
        onLogout: widget.onLogout,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
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
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'Cart',
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
