import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_cubit.dart';
import 'src/features/auth/presentation/bloc/auth_cubit.dart';
import 'src/features/auth/presentation/screens/auth_screen.dart';
import 'src/features/cart/presentation/bloc/cart_cubit.dart';
import 'src/features/cart/presentation/screens/cart_screen.dart';
import 'src/features/customer_home/presentation/bloc/home_cubit.dart';
import 'src/features/customer_home/presentation/screens/customer_home_screen.dart';
import 'src/features/food_detail/presentation/screens/food_detail_screen.dart';
import 'src/features/main_navigation/presentation/screens/main_screen.dart';
import 'src/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'src/features/owner_dashboard/presentation/bloc/owner_dashboard_cubit.dart';
import 'src/features/owner_dashboard/presentation/screens/owner_dashboard_screen.dart';
import 'src/features/profile/presentation/screens/profile_screen.dart';
import 'src/features/splash/presentation/cubit/splash_cubit.dart';
import 'src/features/splash/presentation/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CityBitesApp());
}

<<<<<<< HEAD
class CityBitesApp extends StatelessWidget {
  const CityBitesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<SplashCubit>(create: (_) => SplashCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<HomeCubit>(create: (_) => HomeCubit()),
        BlocProvider<CartCubit>(create: (_) => CartCubit()),
        BlocProvider<OwnerDashboardCubit>(create: (_) => OwnerDashboardCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'City Bites Sahiwal',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/auth': (context) => const AuthScreen(),
              '/main': (context) => const MainScreen(),
              '/home': (context) => const CustomerHomeScreen(),
              '/cart': (context) => const CartScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/owner_dashboard': (context) => const OwnerDashboardScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/food_detail') {
                final foodItem = settings.arguments as FoodItem?;
                return MaterialPageRoute(
                  builder: (context) => FoodDetailScreen(foodItem: foodItem),
                );
              }
              return null;
            },
          );
        },
=======
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
        ),
        body: const Center(
          child: Text('Hello Flutter'),
        ),
>>>>>>> origin/quratulain-food-project
      ),
    );
  }
}