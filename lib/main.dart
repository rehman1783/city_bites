import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/core/theme/app_theme.dart';
import 'src/core/theme/theme_cubit.dart';
import 'src/core/widgets/role_toggle_button.dart';
import 'src/features/admin_portal/presentation/bloc/admin_approvals_bloc.dart';
import 'src/features/admin_portal/presentation/bloc/admin_dashboard_bloc.dart';
import 'src/features/admin_portal/presentation/bloc/admin_heatmap_bloc.dart';
import 'src/features/admin_portal/presentation/bloc/admin_orders_bloc.dart';
import 'src/features/admin_portal/presentation/bloc/admin_users_bloc.dart';
import 'src/features/admin_portal/presentation/screens/admin_analytics_heatmap_screen.dart';
import 'src/features/admin_portal/presentation/screens/admin_dashboard_screen.dart';
import 'src/features/admin_portal/presentation/screens/admin_global_orders_screen.dart';
import 'src/features/admin_portal/presentation/screens/admin_restaurant_approvals_screen.dart';
import 'src/features/admin_portal/presentation/screens/admin_users_screen.dart';
import 'src/features/auth/presentation/bloc/auth_cubit.dart';
import 'src/features/auth/presentation/screens/auth_screen.dart';
import 'src/features/customer_food/presentation/bloc/home_feed_bloc.dart';
import 'src/features/customer_food/presentation/bloc/onboarding_cubit.dart';
import 'src/features/customer_food/presentation/bloc/restaurant_detail_bloc.dart';
import 'src/features/customer_food/presentation/bloc/splash_cubit.dart';
import 'src/features/customer_food/presentation/screens/splash_screen.dart';
import 'src/features/customer_food/presentation/screens/welcome_onboarding_screen.dart';
import 'src/features/customer_order/presentation/bloc/cart_bloc.dart';
import 'src/features/customer_order/presentation/bloc/order_tracking_bloc.dart';
import 'src/features/customer_user/presentation/bloc/profile_bloc.dart';
import 'src/features/main_navigation/presentation/screens/main_screen.dart';
import 'src/features/owner_manage/presentation/bloc/owner_analytics_bloc.dart';
import 'src/features/owner_manage/presentation/bloc/owner_dashboard_bloc.dart';
import 'src/features/owner_manage/presentation/bloc/owner_menu_bloc.dart';
import 'src/features/owner_manage/presentation/bloc/owner_orders_bloc.dart';
import 'src/features/owner_manage/presentation/screens/owner_add_food_screen.dart';
import 'src/features/owner_manage/presentation/screens/owner_analytics_screen.dart';
import 'src/features/owner_manage/presentation/screens/owner_dashboard_screen.dart';
import 'src/features/owner_manage/presentation/screens/owner_menu_management_screen.dart';
import 'src/features/owner_manage/presentation/screens/owner_orders_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SahiwalFoodExpressApp());
}

class SahiwalFoodExpressApp extends StatelessWidget {
  const SahiwalFoodExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
        BlocProvider<SplashCubit>(create: (_) => SplashCubit()),
        BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()),
        BlocProvider<HomeFeedBloc>(create: (_) => HomeFeedBloc()),
        BlocProvider<RestaurantDetailBloc>(create: (_) => RestaurantDetailBloc()),
        BlocProvider<CartBloc>(create: (_) => CartBloc()),
        BlocProvider<OrderTrackingBloc>(create: (_) => OrderTrackingBloc()),
        BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
        BlocProvider<OwnerDashboardBloc>(create: (_) => OwnerDashboardBloc()),
        BlocProvider<OwnerOrdersBloc>(create: (_) => OwnerOrdersBloc()),
        BlocProvider<OwnerMenuBloc>(create: (_) => OwnerMenuBloc()),
        BlocProvider<OwnerAnalyticsBloc>(create: (_) => OwnerAnalyticsBloc()),
        BlocProvider<AdminDashboardBloc>(create: (_) => AdminDashboardBloc()),
        BlocProvider<AdminUsersBloc>(create: (_) => AdminUsersBloc()),
        BlocProvider<AdminApprovalsBloc>(create: (_) => AdminApprovalsBloc()),
        BlocProvider<AdminOrdersBloc>(create: (_) => AdminOrdersBloc()),
        BlocProvider<AdminHeatmapBloc>(create: (_) => AdminHeatmapBloc()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'City Bites',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const AppNavigationController(),
          );
        },
      ),
    );
  }
}

class AppNavigationController extends StatefulWidget {
  const AppNavigationController({super.key});

  @override
  State<AppNavigationController> createState() => _AppNavigationControllerState();
}

class _AppNavigationControllerState extends State<AppNavigationController> {
  bool _splashDone = false;
  bool _onboardingDone = false;
  String _ownerSubRoute = 'dashboard';
  String _adminSubRoute = 'dashboard';

  @override
  Widget build(BuildContext context) {
    if (!_splashDone) {
      return CustomerSplashScreen(
        onSplashComplete: () {
          setState(() {
            _splashDone = true;
          });
        },
      );
    }

    if (!_onboardingDone) {
      return WelcomeOnboardingScreen(
        onFinishOnboarding: () {
          setState(() {
            _onboardingDone = true;
          });
        },
      );
    }

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          final role = authState.role;

          if (role == UserRole.owner) {
            switch (_ownerSubRoute) {
              case 'menu':
                return OwnerMenuManagementScreen(
                  onAddNewItem: () {
                    setState(() {
                      _ownerSubRoute = 'add_food';
                    });
                  },
                );
              case 'add_food':
                return OwnerAddFoodScreen(
                  onSaved: () {
                    setState(() {
                      _ownerSubRoute = 'menu';
                    });
                  },
                );
              case 'orders':
                return const OwnerOrdersScreen();
              case 'analytics':
                return const OwnerAnalyticsScreen();
              case 'dashboard':
              default:
                return OwnerDashboardScreen(
                  onNavigateToMenu: () {
                    setState(() {
                      _ownerSubRoute = 'menu';
                    });
                  },
                  onNavigateToOrders: () {
                    setState(() {
                      _ownerSubRoute = 'orders';
                    });
                  },
                  onNavigateToAnalytics: () {
                    setState(() {
                      _ownerSubRoute = 'analytics';
                    });
                  },
                );
            }
          }

          if (role == UserRole.admin) {
            switch (_adminSubRoute) {
              case 'users':
                return const AdminUsersScreen();
              case 'approvals':
                return const AdminRestaurantApprovalsScreen();
              case 'orders':
                return const AdminGlobalOrdersScreen();
              case 'analytics':
                return const AdminAnalyticsHeatmapScreen();
              case 'dashboard':
              default:
                return AdminDashboardScreen(
                  onNavigateToUsers: () {
                    setState(() {
                      _adminSubRoute = 'users';
                    });
                  },
                  onNavigateToApprovals: () {
                    setState(() {
                      _adminSubRoute = 'approvals';
                    });
                  },
                  onNavigateToOrders: () {
                    setState(() {
                      _adminSubRoute = 'orders';
                    });
                  },
                  onNavigateToAnalytics: () {
                    setState(() {
                      _adminSubRoute = 'analytics';
                    });
                  },
                  onLogout: () {
                    context.read<AuthCubit>().logout();
                    setState(() {
                      _adminSubRoute = 'dashboard';
                    });
                  },
                );
            }
          }

          // Default Customer Flow
          return MainScreen(
            onLogout: () {
              context.read<AuthCubit>().logout();
            },
          );
        }

        // Unauthenticated -> Auth Screen
        return AuthScreen(
          onAuthSuccess: () {},
        );
      },
    );
  }
}
